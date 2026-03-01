#!/bin/bash

set -euo pipefail

if [ ! -f ./tools/inplace-build.bash ]; then
    echo "Run this from project root"
    exit 1;
fi

echo "--Build"
python -m venv venv-build
source venv-build/bin/activate

pip install --progress-bar off setuptools_scm scikit-build-core numpy scipy_openblas32 auditwheel patchelf pytest scipy

pip install --editable . --verbose --config-settings skbuild.build.verbose=true --config-settings skbuild.build-dir=build
