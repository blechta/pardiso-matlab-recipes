#!/bin/bash
set -e

# Default values
: ${PROCS:=1}
: ${OPENBLAS_VERSION:=0.3.0}
: ${PREFIX:="${PWD}/build"}

# Download and unpack
wget -c -O OpenBLAS-${OPENBLAS_VERSION}.tar.gz https://github.com/xianyi/OpenBLAS/archive/v${OPENBLAS_VERSION}.tar.gz
tar -xzf OpenBLAS-${OPENBLAS_VERSION}.tar.gz

# Build and install OpenBLAS into the build dir
cd OpenBLAS-${OPENBLAS_VERSION}
make -j${PROCS} USE_OPENMP=1
make install PREFIX="${PREFIX}"
