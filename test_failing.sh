#!/bin/bash

set -e

# Default values
: ${MATLAB:=matlab}
: ${PREFIX:="${PWD}/build"}

# Load needed environment setup
source "${PREFIX}/share/pardiso_wrappers.conf"

# Run the failing test case
${MATLAB} -nojvm -nodesktop -r "polyfit(1:10, sin(1:10), 2)"
