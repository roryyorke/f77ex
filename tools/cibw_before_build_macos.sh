#!/bin/bash

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh
set -ex

echo ==gfortran -Wl,---verbose output
gfortran-15 -Wl,--verbose
echo ==gfortran -Wl,---verbose output end

exit 1
