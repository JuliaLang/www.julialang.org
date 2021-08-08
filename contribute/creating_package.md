# Creating a Julia package

A detailed page on Julia packages is available [here](http://pkgdocs.julialang.org/v1/). Including the part on [creating packages](http://pkgdocs.julialang.org/v1/creating-packages/).

Julia packages consist of modules. Hence, before creating a package, make sure to understand how [modules](https://docs.julialang.org/en/v1/manual/modules/) work in Julia.


Here we provide a step-by-step example, using [PkgTemplates.jl](https://juliahub.com/docs/PkgTemplates/IGiQL/0.6.4/), inspired by the [video](https://www.youtube.com/watch?v=QVmU29rCjaA&t=112s) of Chris Rackauckas.

In case of any issues, remember that [help](https://github.com/elizavetasemenova/www.julialang.org/blob/main/contribute/contributing_for_everyone.md#where-to-get-help) is available.

## Prerequisites

- an [IDE](https://github.com/elizavetasemenova/www.julialang.org/blob/main/contribute/contributing_for_everyone.md#what-are-the-ide-options)
- a GitHub account

## Starting a package

1. You need to create a folder to store a new package. For example, if you use Atom as an IDE, create a new folder called `tiddlywinks.jl`. Then, open the GitHub panel and select **Initialize and publish on GitHub**. Now, you can go to your GitHub page and see that 'tiddlywinks.jl' has appeared there, as well as locally.

2. In your terminal application, use the change directory (cd) command to change the current working directory to the location of your package.

3. In the Julia REPL, install `PkgTemplate.jl` as follows:
   
   ```
    using Pkg
    Pkg.add("PkgTemplates")
   ```


## Creating package template

Now `PkgTemplates.jl` has been installed and we want to use it to create a template for a package.

Run the following commands in the Julia REPL to create the template:

```
using PkgTemplates

t = Template(;
           user="elizavetasemenova",
           license="MIT",
           authors=["ES"],
           plugins=[
               TravisCI(),
               Codecov(),
               Coveralls(),
               AppVeyor(),
           ],
       )
```

The package called "tiddlywinks" can now be created using the template `t`:
```
t("tiddlywinks")
```

As we have not specified the folder, the package has been created at `~/.julia/dev` on Linux, and at `username/julia/dev` in Windows. If this is not the repository we want to be working from, let's move the files to the original repo which we have created. Now in `tiddlywinks.jl` we have

- LICENSE (the MIT license which we have chosen),
- Manifest.toml (includes ifnormation on dependencies, very useful for reproducibility, see [mode details](http://pkgdocs.julialang.org/v1/toml-files/) about Project annd Manifest files),
- Project.toml (contains high level information about the project),
- README.md,
- src folder (here we will write the code for the package;)
- test folder (here we will be placng tests).

## Writing code
Everything is ready for us to write code. Folder `/src` already contains a file with the same name as the name of our package (`tiddlywinks.jl`). We may not want to write all of the code in this file directly. Instead, we can create varaious pieces in external files within the `/src` directory, and then assemble them in the main file with the `include` command. Let us go ahead and

- create a file called `functions.jl` where we define a function
```
function tiddly_greet()
    println("tiddlywinks")
end
```
- include the file with functions into the main file `tiddlywinks.jl` using the following line: `include("functions.jl")`
- export the function to be available to users with `export tiddly_greet`


## Writing tests
Tests are necessary to make sure that the code is working correctly. There is never enought testing. The `/test` folder already has a starter. We edit it to call the newly implemented function:
```
using tiddlywinks
using Test

@testset "tiddlywinks.jl" begin
    @test tiddlywinks.tiddly_greet() == "tiddlywinks is working"
    @test tiddlywinks.tiddly_greet() != "hello world"
end
```

## Running tests
- in your REPL, check that you are still in the repository of the project by running `pwd()`
- typre `]` which will get you into the "package mode"
- run `activate .` to activate the environment from Project.toml
- run `test` to perform tests

## Continuous integration (CI)

Make sure to have pushed all of the changes to GitHub. Click on the first badge which has appeared in the GitHub repository of the package, and sign in with Travis CI.

## More to come
Stay tuned for more: continuous integration, publishing a package, branches and pull requests, code review
