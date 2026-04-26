#!/bin/bash
export CIBW_ENVIRONMENT="CMAKE_ARGS='-DF77EX_BUNDLE_OPENBLAS=ON'"
export CIBW_BUILD=cp313-manylinux_x86_64
cibuildwheel
