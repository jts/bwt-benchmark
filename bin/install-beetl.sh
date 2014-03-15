#! /bin/bash

mkdir -p programs
cd programs
git clone https://github.com/BEETL/BEETL.git beetl
cd beetl

# Run necessary autoconf programs
aclocal
autoconf
autoheader
automake -a

./configure --prefix=$PWD
make
make install
