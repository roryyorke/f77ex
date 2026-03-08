#!/bin/bash

set -eux

if [ ! -x ./tools/basic-build.bash ]; then
    echo "run from project root";
fi

rm -f pypa-build/f77ex-0.0.1-cp313-cp313-linux_x86_64.whl

pyproject-build . -w -o pypa-build

python -m venv --clear pypa-build/venv

source pypa-build/venv/bin/activate

pip install pypa-build/f77ex-0.0.1-cp313-cp313-linux_x86_64.whl

python -I -m f77ex.test.test_mat_det
