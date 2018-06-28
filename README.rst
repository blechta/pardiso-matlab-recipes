=======================
Pardiso Matlab wrappers
=======================

This is a collection of scripts for building `Pardiso
<https://www.pardiso-project.org/`_ wrappers for Matlab.
Wrapper source code is `officially available from Pardiso
website <https://pardiso-project.org/manual/pardiso-matlab.tgz>`_
but documentation of the build process is basically missing.
The aim of this repository is to address this issue.

MKL BLAS/LAPACK issue
=====================

Matlab is shipped with MKL BLAS/LAPACK but it seems to be
impossible to link official Pardiso binaries against it.
Specifically there is a certain ABI incompatibility leading
to weird error messages, e.g.::

    Intel MKL ERROR: Parameter 9 was incorrect on entry to DGER  .

or SIGSEGV crashes. These recipes circumevent this by
building `OpenBLAS <https://github.com/xianyi/OpenBLAS>`_
and dynamically linking it instead of MKL shipped with Matlab.
It is not known whether this breaks something in Matlab.

Quick install guide
===================

::

    cp /path/to/{libpardiso600-GNU720-X86-64.so,pardiso.lic} .
    ./make_openblas.sh
    ./make_pardiso_wrappers.sh
    ./test.sh
    cp -r build/* <prefix>  # optional

To configure environment to use the wrappers::

    source build/share/pardiso_wrappers.conf
    source <prefix>/share/pardiso_wrappers.conf  # if installed elsewhere

Dependencies
============

The recipes are known to work on

* Matlab R2018a, G++ 5.4.0 (Ubuntu 16.04),
* Matlab R2018a, G++ 7.3.0 (Ubuntu 17.04).

Note that none of these GCC versions are officially
supported by R2018a but it seems to work fine.

Usage
=====

Step 0. Obtain Pardiso
----------------------

Go to https://www.pardiso-project.org and obtain
``libpardiso600-GNU720-X86-64.so`` and ``pardiso.lic``.

Step 1. Build OpenBLAS
----------------------

Run ``./make_openblas.sh``. That will download OpenBLAS,
build single-threaded version, and install it into ``build/``
directory. You might need to tweak the file in order to

* use ``make TARGET=...`` if CPU autodetection fails;
* use ``make DYNAMIC_ARCH=1`` to support heterogenous platform;
* fix any other problem;

see https://github.com/xianyi/OpenBLAS/wiki.

Step 2. Build Pardiso Matlab wrappers
-------------------------------------

Drop the files obtained in Step 0 in this directory.
Run ``./make_pardiso_wrappers.sh``. This will download
the wrappers source from the Pardiso website and build
them. You might need to set ``CXX`` and/or ``MEX`` variables.
For example::

    export CXX=/usr/bin/g++-5
    export MEX=/usr/local/MATLAB/R2018a/bin/mex
    ./make_pardiso_wrappes.sh

Step 3. Test
------------

Run ``./test.sh`` and check that Matlab output looks like::

    The factors have 17 nonzero entries.
    The matrix has 3 positive and 1 negative eigenvalues.
    PARDISO performed 0 iterative refinement steps.
    The maximum residual for the solution X is 1.72e-13.
    The factors have 14 nonzero entries.
    PARDISO performed 0 iterative refinement steps.
    The maximum residual for the solution X is 8.88e-16.
    The factors have 289 nonzero entries.
    PARDISO performed 0 iterative refinement steps.
    The maximum residual for the solution is 8.89e-16.
    Grid size: 30 x 240
    The factors have 130416 nonzero entries.
    PARDISO performed 0 iterative refinement steps.
    The maximum residual for the solution is 9.9e-12.

If you spot some erros then you probably have to get back
to the previous steps.

Step 4. Install
---------------

Installation in the ``build`` directory is relocatable.
You can just move its contents to any ``<prefix>`` (or
leave it where it is) and setup the environment by
``source <prefix>/share/pardiso_wrappers.conf`` before
launching ``matlab`` binary.

Note of ``LD_PRELOAD="${PREFIX}/lib/libopenblas.so"`` trick
in the configuration file which makes your Matlab use
OpenBLAS instead of MKL.

License
=======

BSD 2-clause. Note that this license only applies to
the recipes of this repository and in no way applies to
source code and binaries it downloads, builds and links.

Authors
=======

`Jan Blechta <https://www.karlin.mff.cuni.cz/~blechta/>`_
