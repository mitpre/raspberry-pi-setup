#!/bin/bash
# script name:     inst_stack.sh
# last modified:   2019/06/01
# sudo: no

script_name=$(basename -- "$0")

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi
env="/home/${usr}/.venv/jns"

if [ $(id -u) = 0 ]
then
   echo "usage: ./$script_name"
   exit 1
fi

if [ ! -d "$venv" ]; then
  python3 -m venv $env
fi

# activate virtual environment
source $env/bin/activate

pip3 install pip==9.0.0
pip3 install setuptools
pip3 install --upgrade pip

pip3 install jupyter jupyter-core jupyterlab ipykernel ipyparallel
pip3 install matplotlib
pip3 install numpy
pip3 install bqplot
pip3 install bash_kernel

# if you have some spcific requirements you can put them in the requirements.txt with versions etc ...
# cat requirements.txt | xargs -n 1 pip3 install