#!/bin/bash

set -euo pipefail

workdir=$(mktemp --tmpdir --directory)

$PYTHON -m venv $workdir/venv
source $workdir/venv/bin/activate

pip install --progress-bar off scikit-build-core numpy scipy_openblas32 auditwheel

pip wheel --progress-bar off --verbose --wheel-dir $workdir/inwheels --no-build-isolation .

ls -lR $workdir/inwheels

auditwheel repair --wheel-dir $workdir/wheelhouse $workdir/inwheels/foo*.whl

cp -r $workdir/wheelhouse .

deactivate

$PYTHON -m venv $workdir/test
source $workdir/test/bin/activate

pip install --progress-bar off wheelhouse/foo*.whl

cd $workdir
python -m foo.test.test_mat_det
