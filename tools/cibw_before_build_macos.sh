#!/bin/bash

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh
set -ex

# echo PATH is $PATH

# FC=$(command -v gfortran-15)
# FC_DIR=$(dirname $FC)

# echo FC is $FC
# echo FC_DIR is $FC_DIR

# ls -l $FC_DIR

ls -l /opt/homebrew/Cellar/gcc/15.2.0_1/lib/gcc/current/gcc/aarch64-apple-darwin23/15/

echo ==gfortran -Wl,-t output
gfortran-13 -Wl,-t
echo ==gfortran -Wl,-t output end

gcc13libdir=$(dirname gfortran-13 -Wl,-t 2>/dev/null|grep libgcc.a)
echo gcclibdir is $gcclibdir

exit 1
