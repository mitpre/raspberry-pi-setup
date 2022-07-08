#!/bin/bash
# script name:     automate.sh
# last modified:   2022/07/08
# sudo: no

RED='\033[0;31m'
GREEN='\033[0;33m'
NC='\033[0m' # No Color

script_name=$(basename -- "$0")

usr=$(whoami)

if [ $(id -u) = 0 ]
then
   echo "usage: ./$script_name"
   exit 1
fi

echo -e "${GREEN}Upgrading 'pip'${NC}"
python3 -m pip install --upgrade pip

echo -e "${GREEN}Install 'pipx'${NC}"
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.bashrc
# pipx completetions
#echo 'eval "$(register-python-argcomplete pipx)"' > ~/.bashrc