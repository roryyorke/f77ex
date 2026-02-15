#!/bin/bash

PYTHON=python3.13

rm -rf venv wheels
python3.13 -m venv venv
source venv/bin/activate

pip install scikit-build-core numpy scipy_openblas32 repairwheel

pip wheel --verbose --wheel-dir wheels --no-build-isolation .

repairwheel --output-dir repaired wheels/foo*.whl
