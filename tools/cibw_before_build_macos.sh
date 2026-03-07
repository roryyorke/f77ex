#!/bin/bash

python -m pip install scipy-openblas32
lib_loc=$(python -c"import scipy_openblas32; print(scipy_openblas32.get_lib_dir())")

echo --file-listting of lib_loc=$lib_loc
ls $lib

echo --otool -L of lib_loc/libsci-star
otool -L $lib_loc/libsci*

install_name_tool -change @loader_path/../.dylibs/libgfortran.5.dylib @rpath/libgfortran.5.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libgcc_s.1.1.dylib @rpath/libgcc_s.1.1.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libquadmath.0.dylib @rpath/libquadmath.0.dylib $lib_loc/libsci*
