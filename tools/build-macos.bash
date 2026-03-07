#!/bin/bash

set -xeuo pipefail

output_dir=$PWD

workdir=$(mktemp --tmpdir --directory)

echo "--Build"
$PYTHON -m venv $workdir/build
source $workdir/build/bin/activate

pip install --progress-bar off scikit-build-core numpy scipy_openblas32

pip wheel --progress-bar off --verbose --wheel-dir $workdir/inwheels --no-build-isolation .

deactivate

echo "--Repair"

# repair in a different venv
$PYTHON -m venv $workdir/repair
source $workdir/repair/bin/activate

pip install --progress-bar off scipy_openblas32 delocate

OPENBLAS_DIR=$(python -c 'import scipy_openblas32; import os.path; print(scipy_openblas32.get_lib_dir())')

lib_loc=$(python -c"import scipy_openblas32; print(scipy_openblas32.get_lib_dir())")

echo --file-listting of lib_loc=$lib_loc
ls $lib_loc

echo --otool -L of lib_loc/libsci-star
otool -L $lib_loc/libsci*

install_name_tool -change @loader_path/../.dylibs/libgfortran.5.dylib @rpath/libgfortran.5.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libgcc_s.1.1.dylib @rpath/libgcc_s.1.1.dylib $lib_loc/libsci*
install_name_tool -change @loader_path/../.dylibs/libquadmath.0.dylib @rpath/libquadmath.0.dylib $lib_loc/libsci*

DYLD_LIBRARY_PATH=$OPENBLAS_DIR delocate-wheel --wheel-dir $workdir/wheelhouse $workdir/inwheels/f77ex*.whl

deactivate

echo "--Test"

$PYTHON -m venv $workdir/test
source $workdir/test/bin/activate
pip install --progress-bar off $workdir/wheelhouse/f77ex*.whl

cd $workdir
python -m f77ex.test.test_mat_det

echo "--Copy"

cp --recursive $workdir/wheelhouse $output_dir
