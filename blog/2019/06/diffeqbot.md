@def rss_pubdate = Date(2019, 6, 18)
@def rss_description = """ Hello @DiffEqBot | Hi! Today we all got a new member to the DiffEq family. Say hi to our own DiffEqBot (https://github.com/DiffEqBot) - A bot which helps run benchmarks and compares with the current master of a given package. It also generates and stores the Reports generated in a repository (https://github.com/DiffE... """
@def published = "18 June 2019"
@def title = "Hello @DiffEqBot"
@def authors = """<a href="https://github.com/kanav99">Kanav Gupta</a>"""
@def hascode = true

Hi! Today we all got a new member to the DiffEq family. Say hi to our own [DiffEqBot](https://github.com/DiffEqBot) - A bot which helps run benchmarks and compares with the current master of a given package. It also generates and stores the Reports generated in a [repository](https://github.com/DiffEqBot/Reports). What's special about this is that it is completely stateless (no databases involved at all, just juggling between repositories!) and it has no exposed public URLs. Even though highly inspired by Nanosoldier, this has a completely unique workflow.

\toc

## How do you make it work?

So what all you need to do is call `@DiffEqBot runbenchmarks` in a comment in a PR of a JuliaDiffEq repository and it will do all the work for you.  It will benchmark your pull request against the current master and post the link of report when the job gets completed. Found a bug in PR and now you don't need to complete previous job? Just comment `@DiffEqBot abort` and it won't run now. You also need to maintain two folders `diagrams` (For diagrams generation of the report) and `benchmark`(for comparing the results with master) (like `test` folder) in the root of your repository. `benchmark` folder should have `benchmark/runbenchmarks.jl` (it uses the package `PkgBenchmark`) and `diagrams` should have `diagrams/diagrams.jl`. You can store `REQUIRE`/`Project.toml` in the `diagrams` folder to define the dependencies specifically for `diagrams` generation.

For collecting diagrams, all you have to do is to make a dictionary called `DIAGRAMS` and save all the plot references in that dictionary. For eg -

```julia
DIAGRAMS = Dict()
sol = solve(prob, Tsit5())
DIAGRAMS["Fig1"] = plot(sol)
```

Right now, `DIAGRAMS` cannot be a recursive dictionary, i.e. an element of the dictionary can only be a reference to the plot.

## How does DiffEqBot work internally?

DiffEqBot works by jumping across many repositories and it has been all possible due to awesome APIs both GitHub and Gitlab has provided us with! I will explain the workflow of DiffEqBot in the steps it take to get a particular job done -

1. You make a comment on the pull request to run the benchmarks. With the help of GitHub webhooks, `comment` event is posted on a Heroku app. You get the repository's name and pull request number where this comment is made. It makes sure all the sanity checks, like if the person can run benchmarks or not, or the repository is registered or not etc.

![](https://i.imgur.com/YoigTvy.png)

2. DiffEqBot checks if there is another job is pending/running for the same pull request. It rejects the request if there is, otherwise it accepts the job. It makes the respective comment on the GitHub PR. This is done using the [Jobs API](https://docs.gitlab.com/ee/api/jobs.html) of Gitlab. (I know you must be confused from where did Gitlab come from; this will be explained in the next point)

![](https://i.imgur.com/lWS8i7X.jpg)

3. Here comes the tricky part. We have a separate dedicated Gitlab private repository called `BenchmarkingRepo` which is basically an empty repository, but plays an important role which would be explained now. DiffEqBot checks out a branch with name formatted as `REPONAME-PR` and generates a Gitlab CI configuration script (`.gitlab-ci.yml`) and makes a commit on this branch. What this configuration does is, pull the PR where the request is made, run the benchmarks, and post the results back to the bot. Basically the script is -

```yaml
main:
  script:
    - git clone https://github.com/${org}/${repo}
    - cd ${repo}
    - git fetch origin pull/${pr}/head:pr/${pr}
    - git checkout pr/${pr}
    - julia -e "using Pkg;Pkg.clone(pwd());"
    - cd ..
    - julia some_script_to_run_benchmarks.jl "${repo}" "${pr}" "${commit}"

failed_job:
  script:
    - curl "https://endpoint_to_tell_that_report_failed?repo=${repo}&pr=${pr}&commit=${commit}"
  when: on_failure
```

![](https://i.imgur.com/ORRPWx7.jpg)

4. As soon as we make this commit on the `BenchmarkingRepo` on the branch, the Gitlab CI detects that this pushed branch has a config file in it and it goes wild. It knows now that it needs to run this script! It looks for available Gitlab Runners. We don't use shared runner as they are not suitable for benchmarking jobs. We have our own dedicated Gitlab Runner for this purpose.

![](https://i.imgur.com/vYvx4Ta.jpg)

5. In the `some_script_to_run_benchmarks.jl` file, we make a request back to DiffEqBot along with the report in JSON format in the end. When this happens, DiffEqBot makes a commit on the Reports repository on GitHub submitting the markdown script.

![](https://i.imgur.com/49pIrAe.jpg)

6. Then it makes a comment on the same PR notifying that the job is complete and report is generated.

![](https://i.imgur.com/XN8sQMo.png)

Voila 🎉 The job is done, all thanks to DiffEqBot!

## Configuring the Bot

All the configuration of DiffEqBot is done through a file `config.json` in the Heroku Dyno. It contains all sorts of information you need to pass to the Bot so that it works right. That means to deploy your own bot, you only need to edit this file. The `config.json` file looks something like this -

```json
{
  "admin"               : "kanav99",
  "homepage_url"        : "https://appnameffeqbot.herokuapp.com",
  "org"                 : "JuliaDiffEq",
  "registered_repos"    : ["OrdinaryDiffEq.jl"],
  "benchmarkers"        : ["kanav99", "ChrisRackauckas"],
  "bot_name"            : "DiffEqBot",
  "gitlab_runner_secret": "secret_secret_secret",
  "github_app"          :
    {
      "client_id"           : "github-app-client-id",
      "client_secret"       : "github-app-client-secret",
      "bot_endpoint"        : "/bot/secret/endpoint"
    },
  "gitlab_account"      :
    {
      "benchmarking_repo_id": 12345678,
      "access_token"        : "access_token_of_bot_account_gitlab"
    },
  "github_account"      :
    {
      "access_token"        : "access_token_of_bot_account_gitlab"
    }
}
```

* `admin` -  This is the admin and maintainer of the bot. Bot will ping this person in case of any problem.
* `homepage_url` - This is the URL of the heroku app of bot. It's named like this because we may host this as the homepage of the frontend of the bot.
* `org` - Organization which deployed the bot
* `registered_repos` - These are the repositories that will work with DiffEqBot. You can `runbenchmarks` from these repositories only.
* `benchmarkers` - An array of GitHub handles of members who can run benchmarks (see [the next section](#access_control_and_security) for more information)
* `bot_name` - Handle of the bot on GitHub and Gitlab
* `gitlab_runner_secret` - This is the token to be attached by the Gitlab Runner for every request it makes to the bot. If this token is not right, Bot rejects any request made by the runner.
* `github_app.client_id`/`github_app.client_secret` - You have to make an instance of a Github App for the bot, these are the client ID and client secret of the same app.
* `github_app.bot_endpoint` - Github App interacts with the Heroku app by a webhook. This is the endpoint where the app should make requests.
* `gitlab_account.benchmarking_repo_id` - Project ID of the BenchmarkingRepo on Gitlab
* `gitlab_account.access_token` - Gitlab Personal Access token of Bot account with repo:write rights.
* `github_account.access_token` - Github Personal access token with `public_repo` scope. You can directly generate this [here](https://github.com/settings/tokens/new?description=DiffEqBot&scopes=public_repo).

## Access Control and Security

We have for now given access to only certain members of the organization. We call these members "Benchmarkers". Basically there is an array called `benchmarkers` in the bot configuration. When you make a comment in repository, the GitHub webhook provides you with the handle of the person which made the comment, so that way you can check if this person is in the `benchmarkers` list. The main reason behind this restriction is that you are allowing code from a non-member to be run on your runner. This can be very bad for your machine. Dockerizing the runner can help in this situation. Also currently, there is no provision to provide repository wise access. This can be done easily and expect this patch soon! Another thing which would be needed is easy access control - you cannot edit the heroku dyno everytime. What all we can do is
1. Make a repository (yet again) for this purpose - maintain a heirarchial access control in its file(s). For requesting access, you make a PR over there and once its approved and merged - you get the permission to run benchmarks.
2. Add the command `addbenchmarker` to DiffEqBot which would make the specified person a benchmarker. Internally this would need the Bot to make a commit to the access-control repository (remember that the bot is stateless).


## Shortcomings and Road ahead

I absolutely love this new member of our community. But it still has several shortcomings. As seen above, due to security concerns, we have allowed only certain members of the organization access to run the benchmarks. Also, we have a basic frontend ready for display of reports, but an even more better design is welcome! We might also need more commands for DiffEqBot than just `runbenchmarks` and `abort`. All these extra features would be a cherry on top. I also plan to make it open source and maintain a proper documentation so that other communities can also deploy this for their uses and maybe help in its development too!
