#!/bin/bash
# script name:     inst_stack.sh
# last modified:   2022/07/08
# sudo: no

RED='\033[0;31m'
GREEN='\033[0;33m'
NC='\033[0m' # No Color

script_name=$(basename -- "$0")

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi
env="/home/${usr}/.venv/jupyter"

if [ $(id -u) = 0 ]
then
   echo "usage: ./$script_name"
   exit 1
fi

env="/home/${usr}/.venv/jupyter"
if [ ! -d "$env" ]; then
   echo -e "${GREEN}Create virtual environment for 'jupyter'${NC}"
   virtualenv $env
else
   echo -e "${GREEN}'jupyter' virtual environment already exists${NC}"
fi

# activate virtual environment
echo -e "${GREEN}Activating 'jupyter' virtual environment ${NC}"
source $env/bin/activate

pip install --upgrade pip

echo -e "${GREEN}Installing: 'jupyter jupyter-core jupyterlab ipykernel ipyparallel' ${NC}"
pip install jupyter jupyter-core jupyterlab ipykernel ipyparallel
echo -e "${GREEN}Installing: 'matplotlib' ${NC}"
pip install matplotlib
echo -e "${GREEN}Installing: 'numpy' ${NC}"
pip install numpy
echo -e "${GREEN}Installing: 'bqplot' ${NC}"
pip install bqplot
echo -e "${GREEN}Installing: 'bash_kernel' ${NC}"
pip install bash_kernel

# if you have some spcific requirements you can put them in the requirements.txt with versions etc ...
# cat requirements.txt | xargs -n 1 pip install