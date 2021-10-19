# Creating a Julia package

A detailed page on Julia packages is available [here](http://pkgdocs.julialang.org/v1/). Including the part on [creating packages](http://pkgdocs.julialang.org/v1/creating-packages/).

Julia packages consist of modules. Hence, before creating a package, make sure to understand how [modules](https://docs.julialang.org/en/v1/manual/modules/) work in Julia.


Here we provide a step-by-step example, using [PkgTemplates.jl](https://juliahub.com/docs/PkgTemplates/IGiQL/0.6.4/), inspired by a videoof Chris Rackauckas (please note that the video uses Travis as a Continuous Integration tool which we no longer encourage, and prefer [Github Actions](https://docs.github.com/en/actions) instead). Here is the video:

[<img src="VideoFakeImage.png" width="200" class="center">](https://www.youtube.com/watch?v=QVmU29rCjaA&t=112s)

In case of any issues, remember that [help](https://github.com/elizavetasemenova/www.julialang.org/blob/main/contribute/contributing_for_everyone.md#where-to-get-help) is available.

## Prerequisites

- an [IDE](https://github.com/elizavetasemenova/www.julialang.org/blob/main/contribute/contributing_for_everyone.md#what-are-the-ide-options)
- a GitHub account

## Starting a package

1. You need to create a folder to store a new package. For example, if you use Atom as an IDE, create a new folder called `Tiddlywinks.jl` (packages in Julia generally have a capital first letter). Then, open the GitHub panel and select **Initialize and publish on GitHub**. Now, you can go to your GitHub page and see that 'Tiddlywinks.jl' has appeared there, as well as locally.

2. In your terminal application, use the change directory (cd) command to change the current working directory to the location of your package.

3. In the Julia REPL, install `PkgTemplate.jl` as follows:

   ```
    using Pkg
    Pkg.add("PkgTemplates")
   ```


## Creating package template

Now `PkgTemplates.jl` has been installed and we want to use it to create a template for a package.

Run the following commands in the Julia REPL to create the template (make sure to replace `myusername` with your username and `your name` with your name):

```
using PkgTemplates

t = Template(;
           user="myusername",
           license="MIT",
           authors=["your name"],
           plugins=[
           ],
       )
```

The package called "" can now be created using the template `t` by running the following line in Julia REPL:
```
t("Tiddlywinks")
```

Last line in the REPL shows where the new package has been created:
`Info: New package is at *package_repo*`. As the folder has not been specified, the package has been created at `~/.julia/dev` on Linux, and at `%USERNAME%/.julia/dev` on Windows. If this is not the repository you want to be working from, move the files to the original repo which you have created. Now in `Tiddlywinks.jl` you should have

- LICENSE (the MIT license which we have chosen),
- Manifest.toml (includes information on dependencies, very useful for reproducibility, see [mode details](http://pkgdocs.julialang.org/v1/toml-files/) about Project and Manifest files),
- Project.toml (contains high level information about the project),
- README.md,
- `src` folder with the file `Tiddlywinks.jl` in it (here we will write the code for the package),
- `test` folder with the file `runtests.jl` in it (here we will be placing tests).

## Writing code
Everything is ready for you to write code. Folder `/src` already contains a file with the same name as the name of the package (`Tiddlywinks.jl`). You may not want to write all of the code in this file directly. Instead, you can create various pieces in external files within the `/src` directory, and then assemble them in the main file with the `include` command. Here are the steps to follow:

- create a file called `functions.jl` and in this file define a function
```
function tiddly_greet()
    println("Tiddlywinks")
end
```
- include the file with functions into the main file `Tiddlywinks.jl` using the command `include("functions.jl")`
- export the function to be available to users with `export tiddly_greet`


## Writing tests
Tests are necessary to make sure that the code is working correctly. There is never enough testing. The `/test` folder already has a starter. We edit it to call the newly implemented function:
```
using Tiddlywinks
using Test

@testset "Tiddlywinks.jl" begin
    @test Tiddlywinks.tiddly_greet() == "Tiddlywinks is working"
    @test Tiddlywinks.tiddly_greet() != "hello world"
end
```

## Running tests

To run tests on your package:

- in your REPL, check that you are still in the repository of the project by running `pwd()`
- type `]` which will get you into the "package mode"
- run `activate .` to activate the environment from Project.toml
- run `test`, or, alternatively `test Tiddlywinks` to perform tests. Test summary will provide you with the number of passed tests out of the total number of tests.

## Continuous integration

Continuous integration (CI) is a software development practice of merging all working copies into a mainline repository. CI tools can help you test the package on various versions of Julia, as well as various operating systems. We recommend using [Github Actions](https://docs.github.com/en/actions).

## Propose changes via Pull Requests

To make your first Julia pull request, we recommend reading the detailed [guide](https://kshyatt.github.io/post/firstjuliapr/) by Katharine Hyatt. Here we provide the summary of required steps, using the example package from above.

To propose a change to an existing repository, you need to create a pull request (PR). Follow the steps below. The example
describes a case when you would like to add more testing options to your package:

- clone the repository which you would like to change (skip this step if the repository already exists under your username on GitHub)

- create a new branch of the project

Example: create a branch of `Tiddlywinks.jl` called `more_testing_options`

- make and save changes on the new branch

- push the changes to your GitHub repository

- to create a pull request on GitHub, press the arrow to the right from the word `Contribute`, and then press `Open pull request`

- add title for your pull request and (optional) leave more comments to the proposed changes

- click `Create pull request`

Now your request has appeared on the tab `Pull requests` of the package. If you click on this tab, `Files changed` will show you exact changes that you are proposing. [Continuous integration](#continuous-integration) tools, if they have been included into the project, will run the tests to check that they can be passed by the new branch.

If all test will be passed, package maintainers will review your code and either leave comments or approve it to be merged into the `main` branch.

- delete the branch after it has been merged in

## More to come
Stay tuned for more: publishing a package, branches and pull requests, code review
