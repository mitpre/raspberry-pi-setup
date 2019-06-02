#!/bin/bash
# script name:     create_env.sh
# last modified:   2019/06/01
# sudo: no

script_name=$(basename -- "$0")

usr=$(whoami)

read -p 'Name of the Virual Environment: ' venvname

env="/home/${usr}/.venv/${venvname}"

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

# upgrades pip to version 19+
pip3 install --upgrade pip