# How to develop a Julia package
A package contains modules, tests, and documentation. It extends core Julia functionality. You can share your code with the community by developing a package. In this tutorial, you’ll learn how to develop a Julia package and register it to the [Julia General Registry](https://github.com/JuliaRegistries/General).  

You can create a Julia package using the built-in package manager [PkgDev.jl](https://github.com/JuliaLang/PkgDev.jl) or the package [PkgTemplates.jl](https://invenia.github.io/PkgTemplates.jl/stable/). This example uses `PkgTemplates.jl` and is inspired in the video below:

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/QVmU29rCjaA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

In the video, Chris Rackauckas uses Travis as a Continuous Integration (CI) tool. For this tutorial, we use [GitHub Actions](https://github.com/features/actions) instead which is the current preferred method.

Moreover, this is a summary of the video above. If you want to see more details, we suggest that you watch the full video. To find further information on developing packages and contributing to existing ones, see the timestamps in the description of the video.

## Prerequisites

Before you begin developing a package, make sure you perform the following steps:

1. [Install Julia](https://julialang.org/downloads/) on your local machine.
2. Install an [IDE](/contribute/#tools) and configure it to work with Julia.
3. [Understand how modules work in Julia](https://docs.julialang.org/en/v1/manual/modules/).
4. [Create a GitHub account](https://docs.github.com/en/get-started/signing-up-for-github/signing-up-for-a-new-github-account) if you don’t have one already.

**Note:** In case of any issues, remember you can [get help](/contribute/#get_help) from the community.

## Step 1: Create your package

As we mentioned above, a package contains modules, tests, and documentation. We use PkgTemplates.jl that helps us create all of these files and the configuration for a package.

Before creating your package, you need to define a template that contains the initial configuration. First, you need to install `PkgTemplates.jl`. 

In the Julia REPL, run the following commands:

```
using Pkg
Pkg.add("PkgTemplates")  
```

Now, create your package template by executing the following commands in the Julia REPL:

```
using PkgTemplates

t = Template(;
           user="your-GitHub-username",
           license="MIT",
           authors=["your-name"],
           plugins=[Git(),
               GitHubActions(),
           ],
       )
```

Make sure to replace `your-GitHub-username` with your actual GitHub username and `your-name` with your name. For more information on all of the options available, see the [PkgTemplates User Guide](https://invenia.github.io/PkgTemplates.jl/stable/user/#PkgTemplates-User-Guide-1).

Now, to create the package, in the Julia REPL execute the following command: 

```
t("YourPackageName")
```

Replace `YourPackageName` with the actual name of your package. Note that packages in Julia start with a capital letter. For more information on how to properly name your package, see [Package naming conventions](https://pkgdocs.julialang.org/v1/).

After `PkgTemplates.jl` creates your new package, it stores the source files at  `~/.julia/dev` on Linux, and at `%USERNAME%/.julia/dev` on Windows. If this is not where you want to be working from, then move the source files to your preferred location. Your package directory contains the following:

* `LICENSE`: The license that your package uses. In this example, we set the [MIT license](https://opensource.org/licenses/MIT).
* `Manifest.toml`: It includes information on the package dependencies. For more information on Project and Manifest files, see [Pkg.jl documentation](https://pkgdocs.julialang.org/v1/toml-files/). 
* `Project.toml`: It contains high-level information about the project.
* `README.md`: It contains information about your package. For example, a README file has information on how to install your package and examples of how to use it.
* `src`:  It contains the file `YourPackageName.jl`.  This is where you write the code for your package.
* `test`:  It contains the file `runtests.jl`. This is where you write the code for testing your package.
* `.github`: It contains `yaml` files for [Continuous Integration using GitHub Actions](https://lab.github.com/githubtraining/github-actions:-continuous-integration). 

## Step 2: Create a GitHub repository for your package

You need to create a GitHub repository to store and share your package. For more information on how to create a new GitHub repository, see [Create a repository](https://docs.github.com/en/get-started/quickstart/create-a-repo#create-a-repository). In particular, make sure that you consider the following when creating the repository:

* Name the repository as your package name.
* Add `.jl` to the name of the repository. In this example, you need to name your repository as `YourPackageName.jl`.
* Keep the options of **Initialize this repository with** unselected.

## Step 3: Write code

Now, you can start writing code. You can find a file with the same name as your package (`YourPackageName.jl`) in the subfolder `src/`. You can add your code to the file  `YourPackageName.jl`. However, If your package contains many functions, then it is best to divide it into several files. Then, you can call these functions from the main file  (`YourPackageName.jl`)  using the [include](https://docs.julialang.org/en/v1/manual/code-loading/) command.

To include a function from a different file in `YourPackageName.jl`:

1. In the folder `src/`, create a file called `functions.jl`. 
2. Add the following text to the file `functions.jl`:

```
function greet_your_package_name()
    println("Hello YourPackageName!")
end
```
3. Export the function `greet_your_package_name()` so that is available to users as follows:
   
```
export greet_your_package_name
```

4. In the main file `YourPackageName.jl`, include the `functions.jl` file with the following command:

```
include("functions.jl")
```

Finally, the full content of the main file (YourPackageName.jl)  is the following:

```
module YourPackageName

export greet_your_package_name
include("functions.jl")

end
```

You can include as many functions and files as you need following the process described above. 

## Step 4: Test your package

Tests are necessary to make sure that your package is working correctly. When you create a new package, `PkgTemplates.jl` creates a starter code (`test/runtests.jl`) for your tests. Then, you can add tests for each new function that you write. 

For example, the following code tests the function `greet_your_package_name()`:

```
using YourPackageName
using Test

@testset "YourPackageName.jl" begin
    @test YourPackageName.greet_your_package_name() == "Hello YourPackageName!"
    @test YourPackageName.greet_your_package_name() != "Hello world!"
end
```

To run the test defined above:

1. In your terminal, go to your package directory.
2. Open the Julia REPL.
3. Go to the **package mode** by typing `]`. 
4. Activate the package environment by running the following command:

```
activate .
```

5. In the package mode, run the command `test`.

The Test summary provides the number of passed tests out of the total of existing tests.

## Step 5: Register your package

When you are ready to share your package, you need to register it in the [Julia General Registry](https://github.com/JuliaRegistries/General). After registering your package, other users can install it using `Pkg.add(“PackageName”)`.  

To register your package:

1. Go to the [Registrator](https://github.com/JuliaRegistries/Registrator.jl) repository.
2. Click the **install app** button to install the Julia Registrator application.
3. In your package repository, [create a new issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue). 
4. In the **Leave a comment** text field, add the following text:

```
@JuliaRegistrator register()
```

The Julia Registrator application creates a new pull request to the Julia General Registry automatically. The community will review your package and might make comments or suggest changes. After the Julia General Registry maintainers approve the pull request, your package is added to the list of packages available.

## Further steps

You might need to add new features or fix bugs as you continue developing your package,  Also, you might decide that you need to add dependencies to the project (other packages). As a result, you need to update the `Project.toml` file so that it reflects the updates to your package.

In this section, we go through the steps for versioning your package and adding new dependencies. 

### Versioning

While you continue to develop your package, you need to update its version. It enables you to keep track of the different changes to your package. A [package version](https://pkgdocs.julialang.org/v1/toml-files/#The-version-field) is a number that contains three digits (`X.X.X`). The digits in the version indicate the following:

* First digit: Major version
* Second digit: Minor version
* Third digit: Patch number 

Update your package version digits according to the following guidelines:

* If you make a breaking change, increase the first digit. 
* If you add a new feature, increase the second digit.
* If you fix a bug, increase the third digit.

To update the version of your package, open the `Project.toml` file and modify the `version` variable.

### Adding new dependencies

Instead of reinventing the wheel and creating everything from scratch, you can load packages that the community has already created. You just need to add the new dependency to the project and [call the functions](https://docs.julialang.org/en/v1/manual/modules/#Standalone-using-and-import) as you usually do in Julia.

To add a new dependency to your package:

1. In your terminal, go to your package directory.
2. Open the Julia REPL.
3. Go to the **package** mode by typing `]`. 
4. Activate the package environment by running the following command:

```
activate .
```

5. Add the new package by running the command `add PackageName`.

**Note:** You can add more than one package by leaving white spaces between the names of the packages.

The Julia package manager [Pkg.jl](https://pkgdocs.julialang.org/v1/) adds the new dependency to the file `Project.toml` and other resulting dependencies to the file `Manifest.toml`. 

Congratulations! You **have created your first Julia package and registered it to the Julia General Registry**. Now, you can continue your open source contribution journey and create your own packages or [propose changes to others](/contribute/opportunities). 
