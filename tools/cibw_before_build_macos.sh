#!/bin/bash

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh
set -ex

echo ==gfortran -Wl,---help output
gfortran-15 -Wl,--help
echo ==gfortran -Wl,---help output end

exit 1
