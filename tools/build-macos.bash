#!/bin/bash

set -euo pipefail

output_dir=$PWD

workdir=$(mktemp --tmpdir --directory)

echo "--Build"
$PYTHON -m venv $workdir/build
source $workdir/build/bin/activate

pip install --progress-bar off scikit-build-core numpy scipy_openblas32 delocate

pip wheel --progress-bar off --verbose --wheel-dir $workdir/inwheels --no-build-isolation .

OPENBLAS_DIR=$(python -c 'import scipy_openblas32; import os.path; print(scipy_openblas32.get_lib_dir())')

echo "--Repair"
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
