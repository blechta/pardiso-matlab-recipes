=========================================
Build recipes for Pardiso-Matlab bindings
=========================================

This is a collection of scripts for building `Pardiso
<https://www.pardiso-project.org/>`_ wrappers for Matlab.
Wrapper source code is `officially available from Pardiso
website <https://pardiso-project.org/manual/pardiso-matlab.tgz>`_
but documentation of the build process is basically missing.
The aim of this repository is to address this issue.

Warning: BLAS integer size issue
================================

Matlab is shipped with MKL BLAS/LAPACK built with 64-bit
wide integers. Available Pardiso binaries are build against
BLAS with 32-bit wide integers. This recipe downloads
and builds `OpenBLAS <https://github.com/xianyi/OpenBLAS>`_,
both with 32-bit and 64-bit integers.  32-bit version works
with Pardiso but makes Matlab segfault on any call to BLAS.
Examples is Matlab ``polyfit()`` function. It is not known
how much functionality this breaks in Matlab.

Quick install guide
===================

::

    cp /path/to/{libpardiso600-GNU720-X86-64.so,pardiso.lic} .
    ./make_openblas.sh
    ./make_pardiso_wrappers.sh
    ./test32.sh
    cp -r build32/* <prefix>  # optionally install to other location

Note that the last line in ``test32.sh`` will segfault as
explained above.

To use Pardiso from Matlab::

    source build32/share/pardiso_wrappers.conf     # if kept in build dir
    source <prefix>/share/pardiso_wrappers.conf  # if installed elsewhere

    matlab

    >> pardisoinit(...);
    >> ...

Usage of Matlab/Pardiso
=======================

See https://pardiso-project.org/manual/manual.pdf#page=34.

Dependencies
============

Combinations known to work:

* Matlab R2018a, G++ 5.4.0 (Ubuntu 16.04), OpenBLAS 0.3.0, libpardiso600-GNU720-X86-64.so
* Matlab R2018a, G++ 7.3.0 (Ubuntu 18.04), OpenBLAS 0.3.0, libpardiso600-GNU720-X86-64.so
* Matlab R2019a, G++ 5.4.0 (Ubuntu 16.04), OpenBLAS 0.3.6, libpardiso600-GNU720-X86-64.so
* Matlab R2019a, G++ 7.4.0 (Ubuntu 18.04), OpenBLAS 0.3.6, libpardiso600-GNU720-X86-64.so
* Matlab R2019a, G++ 7.4.0 (Ubuntu 18.04), OpenBLAS 0.3.6, libpardiso600-GNU800-X86-64.so
* Matlab R2020a, G++ 5.4.0 (Ubuntu 16.04), OpenBLAS 0.3.10, libpardiso600-GNU720-X86-64.so
* Matlab R2020a, G++ 9.3.0 (Ubuntu 20.04), OpenBLAS 0.3.10, libpardiso600-GNU720-X86-64.so
* Matlab R2020a, G++ 9.3.0 (Ubuntu 20.04), OpenBLAS 0.3.10, libpardiso600-GNU800-X86-64.so

Combinations known not working:

* Matlab R2020a, G++ 5.4.0 (Ubuntu 16.04), OpenBLAS 0.3.10, libpardiso600-GNU800-X86-64.so::

    >> pardisoinit(1, 0)
    Invalid MEX-file '/home/jan/dev/pardiso-matlab-recipes/build32/matlab/pardisoinit.mexa64':
    /lib/x86_64-linux-gnu/libm.so.6: version `GLIBC_2.27' not found (required by
    /home/jan/dev/pardiso-matlab-recipes/build32/lib/libpardiso.so)

Detailed install guide
======================

Step 0. Obtain Pardiso
----------------------

Go to https://www.pardiso-project.org and obtain
``libpardiso600-GNU720-X86-64.so`` and ``pardiso.lic``.

Step 1. Build OpenBLAS
----------------------

Run ``./make_openblas.sh``. That will download OpenBLAS,
build single-threaded version, and install it into ``build32/``
amd ``build64/`` directories. You might need to tweak the
file in order to

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

Run ``./test32.sh`` and check that Matlab output looks like::

    [...]
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
    !!! Now running failing tests !!!
    [...]


If you spot some erros then you probably have to go back
to the previous steps.

Step 4. Install
---------------

Installation in the ``build32`` directory is relocatable.
You can just move its contents to any ``<prefix>`` (or
leave it where it is) and setup the environment by
``source <prefix>/share/pardiso_wrappers.conf`` before
launching ``matlab`` binary.

Note of ``LD_PRELOAD="${PREFIX}/lib/libopenblas.so"`` trick
in the configuration file which makes your Matlab use
OpenBLAS instead of MKL.

Testing
=======

There is obviously no public CI because Matlab and Pardiso
license do not allow to do that. So you have to believe me
that this works.

License
=======

BSD 2-clause. Note that this license only applies to
the recipes in this repository and in no way applies to
source codes and binaries downloaded, built, linked,
and installed by these recipes.

Authors
=======

`Jan Blechta <https://www-user.tu-chemnitz.de/~blej/>`_
