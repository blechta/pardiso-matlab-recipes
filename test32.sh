#!/bin/bash

set -e

# Default values
: ${MATLAB:=matlab}
: ${PREFIX:="${PWD}/build32"}

# Load needed environment setup
source "${PREFIX}/share/pardiso_wrappers.conf"

# Tell matlab where to search for Pardiso examples and run tests
export MATLABPATH="${PWD}/pardiso-matlab:${MATLABPATH}"
${MATLAB} -nojvm -nodesktop -r "examplesym; exampleunsym; exampleherm; examplecomplex; exit"
${MATLAB} -nojvm -nodesktop -r "polyfit(1:10, sin(1:10), 2); exit"
