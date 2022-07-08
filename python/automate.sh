#!/bin/bash
# script name:     automate.sh
# last modified:   2022/07/08
# sudo: no

RED='\033[0;31m'
NC='\033[0m' # No Color

script_name=$(basename -- "$0")

usr=$(whoami)

if [ $(id -u) = 0 ]
then
   echo "usage: ./$script_name"
   exit 1
fi

echo -e "${RED}Upgrading 'pip'${NC}"
python3 -m pip install --upgrade pip

echo -e "${RED}Install 'pipx'${NC}"
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.bashrc
# pipx completetions
echo 'eval "$(register-python-argcomplete pipx)"' > ~/.bashrc

echo -e "${RED}Install 'virtualenv'${NC}"
pipx install virtualenv

echo -e "${RED}Install 'Node.js'${NC}"
curl -L https://bit.ly/n-install | bash -s -- -y lts

echo -e "${RED}Install 'pigpio'${NC}"
sudo apt-get install pigpio python3-pigpio