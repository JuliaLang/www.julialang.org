# Platform Specific Instructions for Official Binaries

All official Julia binaries produce portable installations.
Once installed, the directory in which Julia was installed can be moved to a
different location on the same computer, or even to a different computer.

## Windows

Julia is available for Windows 7 and later for both 32 bit and 64 bit versions.

**We highly recommend running Julia using a modern terminal, such as installing the [Windows Terminal from the Microsoft Store](https://aka.ms/terminal).**

\newcommand{\winpath}{~~~<code>C:\Users\JohnDoe\AppData\Local\Programs\Julia {{stable_release}}</code>~~~}
\newcommand{\winpathbin}{~~~<code>C:\Users\JohnDoe\AppData\Local\Programs\Julia {{stable_release}}\bin</code>~~~}


### Installation Notes
@@tight-list
1.  Download the Windows Julia installer from https://julialang.org/downloads/. Note, the 32-bit Julia binaries work on both 32-bit and 64-bit Windows  (x86 and x86\_64), but the 64-bit Julia binaries only run on 64-bit Windows (x86\_64).
2. Run the installer and note the installation directory. The installation directory should look something like \winpath, *please note this path*.
@@

To invoke Julia by simply typing `julia` in the command line, the Julia executable directory needs to be added to PATH. Perform the following steps to add Julia to PATH.


#### Adding Julia to PATH on Windows 10,

@@tight-list
1.  Open Run (Windows Key + R),  type in `rundll32 sysdm.cpl,EditEnvironmentVariables` and hit enter.
2.  Under either the "User Variables" or "System Variables" section, find the row with "Path", and click edit.
3.  The "Edit environment variable" UI will appear. Here, click "New", and paste in the directory noted from the installation stage. This should look something like \winpathbin.
4.  Click OK. You can now run Julia from the command line, by typing `julia`!
@@

#### Adding Julia to PATH on Windows 7 or 8

@@tight-list
1.  Open Run (Windows Key + R),  type in `rundll32 sysdm.cpl,EditEnvironmentVariables` and hit enter.
2.  In the System Variables window, highlight Path, and click Edit.
3.  In the Edit System Variables window, move the cursor to the end of the field.
4.  If there is no semicolon at the end, add it and paste in the path to the `bin` folder within the installation directory noted earlier. This path should look something like \winpathbin.
5.  Click OK. You can now run Julia from the command line, by typing `julia`!
@@


### Windows 7 / Windows Server 2012 Installation Notes

Windows 7 / Windows Server 2012 users also need to install:

@@tight-list
*   the [TLS easy\_fix](https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in) for the package manager to work, see [this Discourse thread](https://discourse.julialang.org/t/errors-for-git-pkg/9351) for more details.
*   [Windows Management Framework 3.0 or later](https://docs.microsoft.com/en-us/powershell/scripting/wmf/overview) to include PowerShell 3.0 or later.
@@

### Uninstallation

Uninstallation is preferably performed by using the Windows uninstaller. The directory in `%HOME%/.julia` can then be deleted if you want to remove all traces of Julia (this includes user installed packages).


## macOS

On macOS, a ~~~<code>julia-{{stable_release}}-mac64.dmg</code>~~~ file is provided, which contains ~~~<code>Julia-{{stable_release_short}}.app</code>~~~. Installation is the same as any other Mac software: drag the ~~~<code>Julia-{{stable_release_short}}.app</code>~~~ to Applications Folder's Shortcut. The Julia download runs on macOS 10.9 Mavericks and later releases. You can build from source for macOS 10.6 Snow Leopard (possibly earlier versions as well) and 32-bit but neither are fully supported.

You can launch Julia by opening the Julia app [like any other application](https://www.howtogeek.com/409411/how-to-launch-applications-on-your-mac/).

### Optional: Add Julia to PATH

If you want to launch Julia from the command line, first [open a new terminal window](https://www.howtogeek.com/682770/how-to-open-the-terminal-on-a-mac/), then run the following snippet from your [shell](https://superuser.com/questions/144666/what-is-the-difference-between-shell-console-and-terminal) (e.g., using the Terminal app, not inside the Julia prompt).

~~~
<pre><code class="language-shell">rm -f /usr/local/bin/julia
ln -s /Applications/Julia-{{stable_release_short}}.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia</code></pre>
~~~

This code creates a [symlink](https://en.wikipedia.org/wiki/Symbolic_link) to a Julia version (here {{stable_release_short}}) of your choosing.
To launch Julia, simply type `julia` inside your shell and press return.

### Uninstallation

You can uninstall Julia by deleting Julia.app and the packages directory in `~/.julia`. Multiple Julia.app binaries can co-exist without interfering with each other. If you would also like to remove your preferences files, remove `~/.julia/config/startup.jl` and `~/.julia/logs/repl_history.jl`.

## Linux and FreeBSD

It is strongly recommended that the official generic binaries from the downloads page be used to install Julia on Linux and FreeBSD. The following set of commands downloads the latest version of Julia into a directory named ~~~<code>julia-{{stable_release}}</code>~~~.

~~~
<pre><code class="language-shell">wget https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{ stable_release }}-linux-x86_64.tar.gz
tar zxvf julia-{{ stable_release }}-linux-x86_64.tar.gz</code></pre>
~~~

### Running Julia

The generic Linux and FreeBSD binaries do not require any special installation steps, but you will need to ensure that your system can find the `julia` executable. The directory where Julia is installed is referred to as `<Julia directory>`.

To run Julia, you can do any of the following:

*   Invoke the `julia` executable by using its full path: `<Julia directory>/bin/julia`
*   Create a symbolic link to `julia` inside a folder which is on your system `PATH`
*   Add Julia's `bin` folder (with full path) to your system `PATH` environment variable

To add Julia's `bin` folder (with full path) to `PATH` environment variable, you can edit the `~/.bashrc` (or `~/.bash_profile`) file. Open the file in your favourite editor and add a new line as follows:

```shell
export PATH="$PATH:/path/to/<Julia directory>/bin"
```

Apart from this, there are several ways through which you can change environment variable. You can follow [this guide](https://help.ubuntu.com/community/EnvironmentVariables) to find out a way convenient for you.

Julia installs all its files in a single directory. Deleting the directory where Julia was installed is sufficient. If you would also like to remove your packages, remove `~/.julia`. The startup file is at `~/.julia/config/startup.jl` and the history at `~/.julia/logs/repl_history.jl`.

## Cross-platform installer

[Jill.py](https://github.com/johnnychen94/jill.py) is a community-maintained command-line tool that automates the installation workflow for all platforms. After installing this using `pip install jill -U`, you can then use `jill install` to install the current stable release, and `jill install latest` to install the nightly builds.

# Platform Specific Instructions for Unofficial Binaries



The following distribution-specific packages are community contributed. They may not use the right versions of Julia dependencies or include important patches that the official binaries ship with. All these distributions are community maintained, and hence they may not always have the latest versions of Julia, and sometimes, the instructions may not work. In general, bug reports will only be accepted if they are reproducible on the official generic binaries on the downloads page.



## Chocolatey on Windows

If you use Chocolatey for package management, you can install the latest Julia release by executing the following one-liner, in either a powershell or command prompt:

```shell
choco install julia --confirm
```

Chocolatey automatically creates a shim for the Julia executable, so you simply type `julia` to run Julia in the terminal. When a new version is released simply execute `choco upgrade julia --confirm`. If you want to uninstall Julia run `choco uninstall julia --confirm`.



## HomeBrew on Mac

Julia can be installed using the [Homebrew package manager](https://formulae.brew.sh/cask/julia) as follows:

```shell
brew install --cask julia
```

This automatically puts the binary into a directory in the user's PATH, so you can simply type `julia` to run Julia in the terminal.



## MacPorts on Mac

Julia can also be installed using the [MacPorts package manager](https://ports.macports.org/port/julia/summary) as follows:

```shell
sudo port install julia
```

The installed binary will reside in `/opt/local/bin` by default, so you need to make sure that this directory is in the user's PATH.



## Fedora/RHEL/CentOS/SL/OEL Linux

A [Copr repository](https://copr.fedoraproject.org/coprs/nalimilan/julia/) is provided for Fedora, RHEL, CentOS, Scientific Linux and Oracle Enterprise Linux systems to allow for automatic updating to the latest stable version of Julia.  On Fedora and CentOS 8, Julia is available in 
the main repositories, and you do not need to use the Copr repository.

If you are using RHEL, CentOS, Scientific Linux or Oracle Enterprise Linux (version 5 or higher), first [enable EPEL](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) for your distribution version. Then follow the steps below.

If you are using Fedora (version 32 or higher), directly run:

```shell
sudo dnf install julia
```

If you are using CentOS (version 7), directly run:

```shell
sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/nalimilan/julia/repo/epel-7/nalimilan-julia-epel-7.repo
sudo yum install julia
```

If you are using CentOS (version 8), directly run:

```shell
sudo dnf install julia
```

If both `dnf` and `yum-config-manager` are not available for your distribution, download the relevant `.repo` file from the Copr webpage, copy it to `/etc/yum.repos`, and run the install command.

Note that Fedora guidelines advise against uploading new breaking releases to official repositories: therefore your distribution may not provide the new major versions of Julia. When reporting issues, please ensure you are using the latest available release, and if it is not available using one of the Copr repositories displayed on this page. In order to use nightly Julia builds, use

```shell
sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/nalimilan-nightlies/julia/repo/epel-7/nalimilan-julia-epel-7.repo
sudo yum install julia
```
These can then be updated with `yum upgrade julia`.

## Debian/Ubuntu Linux

Recent Debian/ubuntu distributions include their own build of Julia, which can be installed in the usual way. Check the versions of Julia provided in [Ubuntu](https://packages.ubuntu.com/search?keywords=julia) and [Debian](https://packages.debian.org/search?keywords=julia). If this is not the version of Julia you want, you will need to use the official binaries.

```shell
sudo apt install julia
```

## Arch Linux
The Arch User Repository has [a package for Julia](https://aur.archlinux.org/packages/julia-bin) that is built from the official binaries of Julia. To install it run:

```shell
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/julia-bin.git
cd julia-bin
makepkg -si
```

## FreeBSD Ports

Julia is available in the [Ports Collection](https://svnweb.freebsd.org/ports/head/lang/julia/). To install from the FreeBSD binary package manager, `pkg`, run

```shell
pkg install julia
```
