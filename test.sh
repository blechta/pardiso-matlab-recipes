#!/bin/bash

set -e

# Default values
: ${MATLAB:=matlab}
: ${PREFIX:="${PWD}/build"}

# Load needed environment setup
source "${PREFIX}/share/pardiso_wrappers.conf"

# Tell matlab where to search for the examples and run them
export MATLABPATH="${PWD}/pardiso-matlab:${MATLABPATH}"
${MATLAB} -nojvm -nodesktop -r "examplesym; exampleunsym; exampleherm; examplecomplex; exit"
