#!/bin/bash

set -ex

dest_dir=$1
wheel=$2

# copied from Scipy
# See https://github.com/scipy/scipy/issues/20852
python -m pip install scipy-openblas32
lib_loc=$(python -c"import scipy_openblas32; print(scipy_openblas32.get_lib_dir())")

ls $lib_loc

otool -L $lib_loc/libsci*

install_name_tool -change @loader_path/../.dylibs/libgfortran.5.dylib @rpath/libgfortran.5.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libgcc_s.1.1.dylib @rpath/libgcc_s.1.1.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libquadmath.0.dylib @rpath/libquadmath.0.dylib $lib_loc/libsci*

# from pdfo https://github.com/pdfo/pdfo/blob/main/python/build_tools/cibw_before_build_macos.sh

if [ ! -z $DYLD_FALLBACK_LIBRARY_PATH ]; then
    echo "DYLD_FALLBACK_LIBRARY_PATH set to $DYLD_FALLBACK_LIBRARY_PATH";
    exit 1;
fi

export DYLD_FALLBACK_LIBRARY_PATH=$lib_loc

delocate-listdeps $wheel
delocate-wheel -w $dest_dir $wheel
