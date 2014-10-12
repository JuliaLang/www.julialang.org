#!/bin/sh
# install julia release: ./install-julia.sh juliareleases
# install julia nightly: ./install-julia.sh julianightlies

# stop on error
set -e
# default to juliareleases
if [ $# -ge 1 ]; then
  JULIAVERSION=$1
elif [ -z "$JULIAVERSION" ]; then
  JULIAVERSION=juliareleases
fi

if [ "$JULIAVERSION" = "julianightlies" ]; then
  STATUSURL="http://status.julialang.org/download"
elif [ "$JULIAVERSION" = "juliareleases" ]; then
  STATUSURL="http://status.julialang.org/stable"
else
  echo "Unrecognized JULIAVERSION=$JULIAVERSION, exiting"
  exit 1
fi

case $(uname) in
  Linux)
    # use PPA if add-apt-repository exists
    if [ -n "$(which add-apt-repository 2>/dev/null)" ]; then
      sudo add-apt-repository ppa:staticfloat/julia-deps -y
      sudo add-apt-repository ppa:staticfloat/${JULIAVERSION} -y
      sudo apt-get update -qq -y
      sudo apt-get install libpcre3-dev julia -y
    else # use generic binary
      if [ -e /usr/local/bin/julia ]; then
        echo "/usr/local/bin/julia already exists, exiting"
        exit 1
      elif ! [ "$JULIAVERSION" = "julianightlies" ]; then
        echo "Only have generic Julia binaries for nightlies at this time, exiting"
        exit 1
      fi
      case $(uname -m) in
        x86_64)
          curl -L "$STATUSURL/linux-x86_64" | tar -xz
          ;;
        i386 | i486 | i586 | i686)
          echo "Only have generic Julia binaries for x86_64 at this time, exiting"
          exit 1
          #curl -L "$STATUSURL/linux-i686" | tar -xz
          ;;
        *)
          echo "Do not have generic Julia binaries for this architecture, exiting"
          exit 1
          ;;
      esac
      sudo ln -s $PWD/julia-*/bin/julia /usr/local/bin/julia
    fi
    ;;
  Darwin)
    if [ -e /usr/local/bin/julia ]; then
      echo "/usr/local/bin/julia already exists, exiting"
      exit 1
    elif [ -e julia.dmg ]; then
      echo "julia.dmg already exists, exiting"
      exit 1
    elif [ -e ~/julia ]; then
      echo "~/julia already exists, exiting"
      exit 1
    fi
    curl -Lo julia.dmg "$STATUSURL/osx10.7+"
    hdiutil mount julia.dmg
    cp -Ra /Volumes/Julia/*.app/Contents/Resources/julia ~
    ln -s ~/julia/bin/julia /usr/local/bin/julia
    # TODO: clean up after self?
    ;;
  MINGW* | MSYS* | CYGWIN*)
    echo 'On windows you will probably want to specify the output location.'
    echo 'Try the following in powershell, where JULIAVERSION is "stable/win32"'
    echo 'for 32 bit release, "download/win64" for 64 bit nightly, etc:'
    echo '(new-object net.webclient).DownloadFile($("http://status.julialang.org/"+$env:JULIAVERSION), "julia-binary.exe")'
    echo 'julia-binary.exe /S /D=C:\projects\julia'
    exit 1
    ;;
  *)
    echo "Sorry, don't know how to install Julia binaries on this platform"
    exit 1
    ;;
esac
