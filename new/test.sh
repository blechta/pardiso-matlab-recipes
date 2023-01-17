#!/bin/bash

set -e

# Default values
: ${MATLAB:=matlab}
: ${PREFIX:="${PWD}/build"}

# Tell matlab where to search for Pardiso examples and run tests
export MATLABPATH="${PWD}/pardiso-matlab:${PREFIX}/matlab:${MATLABPATH}"
#${MATLAB} -nojvm -nodesktop -r "polyfit(1:10, sin(1:10), 2); exit"
#${MATLAB} -nojvm -nodesktop -batch "examplesym; exampleunsym; exampleherm; examplecomplex; exit"
/usr/local/MATLAB/R2021a/bin/matlab -singleCompThread -Dgdb -nojvm -batch "dbmex on; info = pardisoinit(-2,0)"
