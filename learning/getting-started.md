
# Getting Started with Julia


## What is Julia?

Welcome to the Julia language project! We’re excited to see you exploring Julia,learning it and contributing to our project and community. Julia is a general purpose language, which means that you can find a way to build basically any software in it that you could with another language. However, no programming language is the best tool for every problem.

Julia was designed with technical and scientific users in mind.Many of it features are well suited for numerical analysis and computational science.Most of the programming languages that run very fast are also quite a bit trickier to use than some “high level” languages that you might have heard of, like Python or Matlab. For example, C and Fortran are known to be very fast,but they require that the user provides a lot of information to the computer about the program they are writing as they write it. This takes more time and often more programming experience than working in a language like Python.

Few Years ago, It was a common notion that when choosing a language there is a tradeoff between code readability/writing and performance.Julia was designed to solve this exact problem -to be relatively easy and quick to write programs in, but also to run code and perform calculations fast.

## Install Julia

To download and install Julia on your system:[Install Julia](/downloads/platform).

The first thing to do is [download Julia](/downloads/). Pre-built versions are available from our website. Download the version(recommended "Generic Linux Binaries”) for your operating system(recommended for all OS types). . If you have more experience working with Linux or with programming generally, another option on a Linux machine is to download Julia using your system package manager, like yup, apt-get etc.

Once you download Julia, and run the installer (Windows/Mac -- on linux you just unzip the downloaded file), you will get a `julia` binary in the _bin_ directory where your install lives. Running that program will leave you in a textual prompt, which is usually called a REPL - Read-Eval-Print-Loop.

![Julia REPL](/assets/images/julia-repl.png)

Julia can be worked with directly from REPL.History of all commands is stored even across restarts which can accessed using up-arrow key or ctrl-r for search.

If you wish to keep your code more organized and wish to work on larger projects,there are many IDE/editor options available to explore:
- [VS-code](https://code.visualstudio.com/)-Julia [Extension](https://www.julia-vscode.org/docs/dev/gettingstarted/#Installation-and-Configuration-1)
- [Atom](https://atom.io/)- Julia Extension [Juno](http://docs.junolab.org/latest/man/installation/) Extension 
- [Pluto](https://github.com/fonsp/Pluto.jl)- Interactive notebooks with similar features as jupyter notebooks
- **Jupyter Notebook**-Julia can be used in jupyter using IJulia
- **Repl.it**-Online repl to start exploring Julia instantly

## *Hello world!* example
We have two methods to do this,we can write a julia script or we can use julia repl to print "Hello World!!" 

### - Method-1
Instructions for the julia developement environment in Visual Studio Code can be found here:[Julia-VScode](https://www.julia-vscode.org/docs/dev/gettingstarted/#Installation-and-Configuration-1)
1. Create a new file and save it in your workspace as *hello.jl*:
2. Add the following source code in the *hello.jl*
3. Run it,Output can be seen in terminal
![VSCODE-Example](/assets/images/vscode-helloworld.png)

### - Method-2
1. Open a command Prompt and cd to home directory.
2. Type **Julia** in command prompt and julia repl will be shown.
3. Execute the commands as shown below:

In the Julia-Repl:

![julia-repl](/assets/images/juliarepl-helloworld.png)

**To explore more examples**:[Julia Tutorials](/learning/code-examples)

### Getting Packages
Julia usually comes with compiler and standard library(basic functionality) which has limited use.
For most use cases, you will need to download and run external packages in Julia. 
- List of publicly available packages is [available here](https://pkg.julialang.org)

Packages can be installed using builtin package manager Pkg.Press `]` (right square bracket) on your keyboard when you are at the REPL, which will put the REPL into _pkg_ mode.

![Package Installation](/assets/images/packages.png)

In this mode, you type package management commands directly into the REPL. For example, `add PackageName` will add a package to your local environment, and `rm PackageName` will remove it. Using the package manager will also typically manage the package’s dependencies for you; this means the package manager makes sure your computer/environment has everything it needs in order to run the package you want to install. A [video](https://www.youtube.com/watch?v=76KL8aSz0Sg) showing how to use the package manager in more detail can be seen on our youtube channel.

### Coming from other languages
If you have experience programming in another language, you will find that most of your knowledge will be easily transferred to Julia. We have documented some [noteworthy differences](https://docs.julialang.org/en/v1/manual/noteworthy-differences/) from other popular languages: [Matlab](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-MATLAB-1), [R](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-R-1), [Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Python-1) and [C/C++](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-C/C-1)


### Developing packages
It is easy to move from using Julia packages to developing them. Most of our contributors started that way. If you are the user of a Julia package, please believe that you have the skills to contribute bug fixes and new features. Chris Rackaukas has created a video that walks you through the process of creating a new package, or contributing code to an existing package. Find it [here on our Youtube channel](https://www.youtube.com/watch?v=QVmU29rCjaA)


### Looking for help

Programming is fun and exciting. The Julia programming language is no exception. While it is always best to try to answer a question yourself if you can, feel free to ask someone else more experienced! Take a look at the [Julia Community](/community/) tab on the website to find all the places you can connect and get help in the Julia Community.
