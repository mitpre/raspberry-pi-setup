#!/bin/bash
# script name:     inst_stack.sh
# last modified:   2022/07/08
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
  virtualenv $env
fi

# activate virtual environment
source $env/bin/activate

pip install --upgrade pip

pip install jupyter jupyter-core jupyterlab ipykernel ipyparallel
pip install matplotlib
pip install numpy
pip install bqplot
pip install bash_kernel

# if you have some spcific requirements you can put them in the requirements.txt with versions etc ...
# cat requirements.txt | xargs -n 1 pip install