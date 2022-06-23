#!/bin/bash

alias wget="wget --no-check-certificate"
echo -n "Are you working on SMU's M2 SuperComputer? (y/n): "
read m2
if [ $m2='y' ]
then
    module purge
    module load gcc-6.3 spack root cmake gsl yaml-cpp openblas zlib libpng texlive armadillo
    module list
else
    echo "Make sure you have the libraries installed such as cmake, zlib, etc..."
fi
