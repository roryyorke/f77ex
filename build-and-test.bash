#!/bin/bash

set -euo pipefail

venvdir=$(mktemp --directory venv-XXXXXX )

echo venvdir is $venvdir

python -m venv $venvdir

source $venvdir/bin/activate

pip install numpy scikit-build-core

pip install --no-build-isolation --verbose .

# run test
python -c 'from example import square, foo; print(f"{square(2)=} {foo(2)=}")'
