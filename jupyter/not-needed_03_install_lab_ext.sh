#!/bin/bash
# script name:     inst_lab_ext.sh
# last modified:   2019/04/06
# sudo:            no

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

source /home/${usr}/.bashrc
echo -e "${GREEN}Activating 'jupyter' virtual environment ${NC}"
source $env/bin/activate
jupyter lab clean
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter labextension install bqplot --no-build
jupyter labextension install jupyterlab_bokeh --no-build
jupyter labextension install jupyter-leaflet --no-build
jupyter lab build
