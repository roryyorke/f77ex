#!/bin/bash

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh
set -ex

ARCH=$(uname -m)
if [ "$ARCH" == "arm64" ]; then
    sudo ln -fs /opt/homebrew/bin/gfortran-12 /opt/homebrew/bin/gfortran
else
    sudo ln -fs /usr/local/bin/gfortran-12 /usr/local/bin/gfortran
fi

echo ==gfortran -Wl,---verbose output
gfortran -Wl,--verbose
echo ==gfortran -Wl,---verbose output end
