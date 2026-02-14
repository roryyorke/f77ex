#!/bin/bash

set -euo pipefail

proj=$PWD

workdir=$(mktemp --tmpdir --directory rorybt-XXXXXX )

echo Working directory is $workdir

cd $workdir

# clone
git clone --depth 1 file://$proj src

# build
( cd src && pyproject-build . )

# create venv, install
python -m venv venv

source venv/bin/activate

pip install src/dist/*.whl # only 1, I hope!

# run test
python -c 'from example import square; print(f"{square(2)=}")'
