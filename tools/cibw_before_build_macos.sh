#!/bin/bash

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh
set -ex

echo PATH is $PATH

FC=$(command -v gfortran-15)
FC_DIR=$(dirname $FC)

echo FC is $FC
echo FC_DIR is $FC_DIR

ls -l $FC_DIR

echo ==gfortran -Wl,---help output
gfortran-15 --help
echo ==gfortran -Wl,---help output end

exit 1
