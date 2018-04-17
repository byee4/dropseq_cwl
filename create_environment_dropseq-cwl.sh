#!/bin/bash

conda create -y -n dropseq-cwl
source activate dropseq-cwl

conda install -y -c anaconda openjdk picard=2.18.2 star=2.5.2b

### add these dirs to path ###
export PATH=${PWD}/bin/:$PATH;
export PATH=${PWD}/bin/Drop-seq_tools-1.13:$PATH;
export PATH=${PWD}/cwl/:$PATH;
export PATH=${PWD}/wf:$PATH;

### Install CWL and helpers ###
pip install --ignore-installed six;
pip install cwlref-runner;
pip install cwltool==1.0.20180306140409;

### required by toil source ###
pip install cwltest;
pip install galaxy-lib==17.9.3;

### use development branch of toil, latest stable has some bugs with torque resource alloc ###
# pip install toil[all];
cd ${PWD}/bin;
git clone https://github.com/byee4/toil; # frozen fork of master
cd toil;
python setup.py install;
cd ../;

wget http://mccarrolllab.com/download/1276/Drop-seq_tools-1.13.zip
unzip Drop-seq_tools-1.13.zip
cd ../../;
