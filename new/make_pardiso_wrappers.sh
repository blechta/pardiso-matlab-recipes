#!/bin/bash
set -e

# Default values
: ${CXX:=c++}
: ${MEX:=mex}
: ${PREFIX:="${PWD}/build"}

# Download, unpack, and patch pardiso wrappers
wget -c -nc https://pardiso-project.org/manual/pardiso-matlab.tgz
tar -xzf pardiso-matlab.tgz
cp pardisoinfo.h pardisoinfo.cpp pardiso-matlab/
cd pardiso-matlab

# Build Pardiso wrappers
MEXFLAGS="CXX=${CXX} -g -largeArrayDims -lmwblas -lmwlapack -lmkl-cluster -lmwmpi"
$MEXFLAGS="CXX=${CXX} -g -lmwblas -lmwlapack -lmkl-cluster -lmwmpi"
echo $MEXFLAGS
SRC_COMMON="common.cpp matlabmatrix.cpp sparsematrix.cpp pardisoinfo.cpp"
${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisoinit    pardisoinit.cpp    ${SRC_COMMON}
#${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisoreorder pardisoreorder.cpp ${SRC_COMMON}
#${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisofactor  pardisofactor.cpp  ${SRC_COMMON}
#${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisosolve   pardisosolve.cpp   ${SRC_COMMON}
#${MEX} ${MEXFLAGS} -output ${PREFIX}/matlab/pardisofree    pardisofree.cpp    ${SRC_COMMON}
