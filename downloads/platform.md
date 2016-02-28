---
layout: default
title:  Platform specific instructions for installing Julia
---

# Platform Specific Instructions

## Windows

Julia is available for both 32-bit and 64-bit Windows since XP SP2.

1. Download the Windows julia.exe installer for your platform. 32-bit julia works on both x86 and x86_64. 64-bit julia will only run on 64-bit Windows (x86_64).
2. Run the downloaded program to extract julia
3. Double-click the julia shortcut in the unpacked folder to start julia

The [Windows README](https://github.com/JuliaLang/julia/blob/master/README.windows.md) contains information on dependencies.

Uninstallation is performed by deleting the extracted directory and the packages directory in `%HOME%/.julia`. If you would also like to remove your preferences files, remove `%HOME%/.juliarc.jl` and `%HOME%/.julia_history`.

## OS X

On Mac, a Julia-version.dmg file is provided, which contains Julia.app. Installation is the same as any other Mac software -- copy the Julia.app to your hard-drive (anywhere) or run from the disk image. Julia supports all OS X 10.7 and later. If you use Snow Leopard (OSX 10.6), Julia 0.2.1 was the last release of Julia that supported it.

Uninstall Julia by deleting Julia.app and the packages directory in ~/.julia. Multiple Julia.app binaries can co-exist without interfering with each other. If you would also like to remove your preferences files, remove `~/.juliarc.jl`.

## Linux

Instructions will be added here as more linux distributions start including julia. If your Linux distribution is not listed here, you should still be able to run julia by building from source. See the [Julia README](https://github.com/JuliaLang/julia/blob/master/README.md) for more detailed information.

### Ubuntu
A [PPA](https://launchpad.net/~staticfloat/+archive/juliareleases) (Personal Package Archive) is provided for Ubuntu systems to allow for automatic updating to the latest stable version of Julia.  To use this PPA and install julia on Ubuntu 12.04 or later, run the following commands:

    sudo add-apt-repository ppa:staticfloat/juliareleases
    sudo add-apt-repository ppa:staticfloat/julia-deps
    sudo apt-get update
    sudo apt-get install julia

Note that Ubuntu has deadlines for accepting new versions of software into their default repositories, and as such the default repositories often have Julia versions that lag behind significantly.  When reporting issues, please ensure you are using the latest available release by using one of the PPA repositories displayed on this page.

### Fedora/RHEL/CentOS/SL/OEL
A [Copr repository](https://copr.fedoraproject.org/coprs/nalimilan/julia/) is provided for Fedora, RHEL, CentOS, Scientific Linux and Oracle Enterprise Linux systems to allow for automatic updating to the latest stable version of Julia.

If you are using RHEL, CentOS, Scientific Linux or Oracle Enterprise Linux (version 5 or higher), first [enable EPEL](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) for your distribution version. Then follow the steps below.

If you are using Fedora (version 19 or higher), directly run:

    sudo dnf copr enable nalimilan/julia
    sudo yum install julia

If `dnf` is not available for your distribution, download the relevant `.repo` file from the Copr webpage, copy it to `/etc/yum.repos`, and run the second command.

Note that Fedora guidelines advise against uploading new breaking releases to official repositories: therefore your distribution will not provide the new major versions of Julia which were published after it. When reporting issues, please ensure you are using the latest available release by using one of the Copr repositories displayed on this page.

### Ubuntu nightlies installation instructions
A [PPA](https://launchpad.net/~staticfloat/+archive/julianightlies) (Personal Package Archive) is provided for Ubuntu systems to allow for automatic updating to the latest development version of Julia.  To use this PPA and install julia on Ubuntu 12.04 or later, run the following commands:

    sudo apt-add-repository ppa:staticfloat/julianightlies
    sudo apt-add-repository ppa:staticfloat/julia-deps
    sudo apt-get update
    sudo apt-get install julia

New versions are built every night. If you have already installed julia and you want to upgrade to the latest version, do:

    sudo apt-get update
    sudo apt-get upgrade

### Fedora/RHEL/CentOS/SL/OEL nightlies installation instructions
A [Copr repository](https://copr.fedoraproject.org/coprs/nalimilan/julia-nightlies/) is provided for Fedora, RHEL, CentOS, Scientific Linux and Oracle Enterprise Linux systems to allow for automatic updating to the latest development version of Julia.

If you are using RHEL, CentOS, Scientific Linux or Oracle Enterprise Linux (version 5 or higher), first [enable EPEL](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) for your distribution version. Then follow the steps below.

If you are using Fedora (version 19 or higher), directly run:

    sudo dnf copr enable nalimilan/julia-nightlies
    sudo yum install julia

If `dnf` is not available for your distribution, download the relevant `.repo` file from the Copr webpage, copy it to `/etc/yum.repos`, and run the second command.

New versions are built every night. If you have already installed julia and you want to upgrade to the latest version, do:

    sudo yum upgrade julia

## Uninstalling Julia

Uninstallation depends on the method you used to install Julia. If you installed from a package manager such as `apt-get` or `yum`, use the package manager to remove julia, for example `apt-get remove julia` or `yum remove julia`. If you did a source build, you can remove it by deleting your julia source folder. If you would also like to remove your preferences files, they are `~/.julia` and `~/.juliarc.jl`.
