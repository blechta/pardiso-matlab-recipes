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
: ${PREFIX:="${PWD}/build"}

# Locate libpardiso and install into the build dir
if [ ! -f "${PARDISO_LIB}" ]; then
    echo "Did not find ${PARDISO_LIB}. Please specify PARDISO_PATH."
    exit 1
fi
mkdir -p ${PREFIX}/lib ${PREFIX}/share
cp ${PARDISO_LIB} ${PREFIX}/lib/libpardiso.so
cp ${PARDISO_LIC} ${PREFIX}/share/pardiso.lic

# Download and unpack pardiso wrappers
wget -c https://pardiso-project.org/manual/pardiso-matlab.tgz
tar -xzf pardiso-matlab.tgz
cd pardiso-matlab

# Build
MEXFLAGS="CXX=${CXX} -largeArrayDims -L\"${PREFIX}/lib\" -lpardiso"
SRC_COMMON="common.cpp matlabmatrix.cpp sparsematrix.cpp pardisoinfo.cpp"
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisoinit    pardisoinit.cpp    ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisoreorder pardisoreorder.cpp ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisofactor  pardisofactor.cpp  ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisosolve   pardisosolve.cpp   ${SRC_COMMON}
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisofree    pardisofree.cpp    ${SRC_COMMON}
