#!/bin/bash
set -e

# Default values
: ${OPENBLAS_VERSION:=0.3.6}
: ${PREFIX32:="${PWD}/build32"}
: ${PREFIX64:="${PWD}/build64"}

# Download and unpack
wget -c -O OpenBLAS-${OPENBLAS_VERSION}.tar.gz https://github.com/xianyi/OpenBLAS/archive/v${OPENBLAS_VERSION}.tar.gz
tar -xzf OpenBLAS-${OPENBLAS_VERSION}.tar.gz
cd OpenBLAS-${OPENBLAS_VERSION}

# Build and install OpenBLAS with 32-bit integers
make clean
make INTERFACE64=0 NO_LAPACKE=1 NO_CBLAS=1 USE_OPENMP=0 USE_THREAD=0
make install INTERFACE64=0 NO_LAPACKE=1 NO_CBLAS=1 NO_STATIC=1 PREFIX="${PREFIX32}"

# Build and install OpenBLAS with 64-bit integers
make clean
make INTERFACE64=1 NO_LAPACKE=1 NO_CBLAS=1 USE_OPENMP=0 USE_THREAD=0
make install INTERFACE64=1 NO_LAPACKE=1 NO_CBLAS=1 NO_STATIC=1 PREFIX="${PREFIX64}"
