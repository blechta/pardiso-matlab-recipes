#!/bin/bash
set -e

# Default values
: ${CXX:=c++}
: ${MEX:=mex}
: ${PARDISO_PATH:="${PWD}"}
: ${PARDISO_LIB_PATH:="${PARDISO_PATH}"}
: ${PARDISO_LIB:="${PARDISO_LIB_PATH}/libpardiso600-GNU720-X86-64.so"}
: ${PARDISO_LIC_PATH:="${PARDISO_PATH}"}
: ${PARDISO_LIC:="${PARDISO_LIC_PATH}/pardiso.lic"}
: ${PREFIX32:="${PWD}/build32"}
: ${PREFIX64:="${PWD}/build64"}

# Locate libpardiso and install
if [ ! -f "${PARDISO_LIB}" ]; then
    echo "Did not find ${PARDISO_LIB}. Please specify PARDISO_PATH."
    exit 1
fi
mkdir -p ${PREFIX32}/lib ${PREFIX32}/share
cp ${PARDISO_LIB} ${PREFIX32}/lib/libpardiso.so
cp ${PARDISO_LIC} ${PREFIX32}/share/pardiso.lic
mkdir -p ${PREFIX64}/lib ${PREFIX64}/share
cp ${PARDISO_LIB} ${PREFIX64}/lib/libpardiso.so
cp ${PARDISO_LIC} ${PREFIX64}/share/pardiso.lic

# Download and unpack pardiso wrappers
wget -c https://pardiso-project.org/manual/pardiso-matlab.tgz
tar -xzf pardiso-matlab.tgz
cd pardiso-matlab

# Build Pardiso wrappers with 32-bit integers BLAS
MEXFLAGS="CXX=${CXX} -largeArrayDims -L\"${PREFIX32}/lib\" -lpardiso"
SRC_COMMON="common.cpp matlabmatrix.cpp sparsematrix.cpp pardisoinfo.cpp"
${MEX} ${MEXFLAGS} -output ${PREFIX32}/matlab/pardisoinit    pardisoinit.cpp    ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX32}/matlab/pardisoreorder pardisoreorder.cpp ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX32}/matlab/pardisofactor  pardisofactor.cpp  ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX32}/matlab/pardisosolve   pardisosolve.cpp   ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX32}/matlab/pardisofree    pardisofree.cpp    ${SRC_COMMON}

# Build Pardiso wrappers with 64-bit integers BLAS
MEXFLAGS="CXX=${CXX} -largeArrayDims -L\"${PREFIX64}/lib\" -lpardiso"
SRC_COMMON="common.cpp matlabmatrix.cpp sparsematrix.cpp pardisoinfo.cpp"
${MEX} ${MEXFLAGS} -output ${PREFIX64}/matlab/pardisoinit    pardisoinit.cpp    ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX64}/matlab/pardisoreorder pardisoreorder.cpp ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX64}/matlab/pardisofactor  pardisofactor.cpp  ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX64}/matlab/pardisosolve   pardisosolve.cpp   ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX64}/matlab/pardisofree    pardisofree.cpp    ${SRC_COMMON}
