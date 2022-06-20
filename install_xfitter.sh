#!/bin/bash

start_dir=$(pwd)

echo -n "All prexisting installations of xfitter dependencies in the directory specified will be overwritten do you wish to continue? (y/n): "
read overwriter
if [ $overwriter = 'n' ]
then
    exit
fi

# File to install xfitter and dependencies to the user's liking
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

# This will be where the the code will run ./configure --prefix=$config_path
echo -n 'Where will your software be configured? (Write full path): '
read config_path

if [ -d $config_path ]
then 
    echo "config path exits"
else
    echo "making $config_path"
    mkdir $config_path
fi

echo 'PATH, LD_LIBRARY_PATH, LD_RUN_PATH set for config_path'
export PATH=./:~/bin/:$config_path/bin/:$PATH
export LD_LIBRARY_PATH=$config_path/lib/:$LD_LIBRARY_PATH
export LD_RUN_PATH=$config_path/lib/:$LD_RUN_PATH

echo -e "\n PATH: \n $PATH \n"
echo -e "LD_LIBRARY_PATH: \n $LD_LIBRARY_PATH \n"
echo -e "LD_RUN_PATH: \n $LD_RUN_PATH \n"

# The user has chosen one path for all dependencies to lie in
# structure will look like 
# ../xfitter_dependencies/
#       hoppet/
#       apfel/
#       apfelgrid/
#       qcdnum/
#       lhapdf/
#       applgrid/

echo -n 'Enter path for xfitter dependencies installation location (Write full path): '
read dep_path

if [ -d $dep_path ]
then 
    echo "dependencies path exits"
else
    echo "making $dep_path"
    mkdir $dep_path
fi

cd $dep_path
# install HOPPET
echo 'Installing HOPPET'

git clone https://github.com/gavinsalam/hoppet
cd hoppet

echo "configuring HOPPET to $config_path"

./configure --prefix=$config_path
make -j
make check 
make install

cd $dep_path
#------------------------#
# install LHAPDF
echo "Installing LHAPDF 6.5.1"

wget --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.1.tar.gz -O LHAPDF-6.5.1.tar.gz
tar -xvzf LHAPDF-6.5.1.tar.gz
rm LHAPDF-6.5.1.tar.gz
cd LHAPDF-6.5.1

echo "configuring LHAPDF to $config_path"

./configure --prefix=$config_path
make -j
make install

cd $dep_path
#------------------------#
# install QCDNUM
echo "Installing QCDNUM-18-00/00"

wget --no-check-certificate https://www.nikhef.nl/~h24/qcdnum-files/download/qcdnum180000.tar.gz
tar -xvzf qcdnum180000.tar.gz
rm qcdnum180000.tar.gz
cd qcdnum-18-00-00

echo "configuring QCDNUM to $config_path"

./configure --prefix=$config_path
make -j
make install

cd $dep_path
#------------------------#
# install APFEL
echo "Installing APFEL 2.0.0"

git clone https://github.com/scarrazza/apfel.git
cd apfel

echo "configuring APFEL to $config_path"

./configure --prefix=$config_path
make -j
make install

cd $dep_path
#------------------------#
# install APPLGRID 
echo "Installing APPLGRID 1.5.46"

wget --no-check-certificate https://applgrid.hepforge.org/downloads?f=applgrid-1.5.46.tgz -O applgrid-1.5.46.tgz
tar -xvzf applgrid-1.5.46.tgz
rm applgrid-1.5.46.tgz
cd applgrid-1.5.46

echo "configuring APPLGRID to $config_path"

./configure --prefix=$config_path
make -j
make install

cd $dep_path
#------------------------#
# install APFELGRID 
echo "Installing APFELGRID"

git clone https://github.com/nhartland/APFELgrid.git
cd APFELgrid

echo "configuring APFELGRID to $config_path"

./setup.sh
make install

cd $dep_path
#------------------------#

# install xfitter now
cd $start_dir

echo -n "Download pdf sets from pdfsetlist.txt?: "
read dwnld 
if [ $dwnld = 'y' ]
then

    echo "downloading pdfsets"
    cat pdfsetlist.txt | while read line 
    do
        wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/$line.tar.gz -O- | tar xz -C $config_path/share/LHAPDF
    done
fi

echo "Grabbing NNPDF30_nlo_as_0118, the pdf used in the example"
wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF30_nlo_as_0118.tar.gz -O- | tar xz -C $config_path/share/LHAPDF

if [ -d xfitter ]
then 
    echo "xfitter is already installed"
    cd xfitter
    ./make.sh install
else
    echo "Installing xfitter in current directory"
    git clone https://gitlab.cern.ch/fitters/xfitter.git
    cd xfitter
    ./make.sh install
fi
