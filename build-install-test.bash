#!/bin/bash

set -euo pipefail

pipx run build

venvdir=$(mktemp --tmpdir --directory venv-XXXXXX )
echo venvdir is $venvdir
python -m venv $venvdir

source $venvdir/bin/activate

pip install dist/*.whl

# run test
(cd / && python -c 'from foo import square, foo; print(f"{square(2)=} {foo(2)=}")')
