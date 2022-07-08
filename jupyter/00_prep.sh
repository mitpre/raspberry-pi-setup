#!/bin/bash
# script name:     prep.sh
# last modified:   2019/06/01
# sudo:            yes

script_name=$(basename -- "$0")

if ! [ $(id -u) = 0 ]; then
   echo "usage: sudo ./$script_name"
   exit 1
fi

printf "\n\ndoing: apt update && apt -y upgrade\n"
apt update && apt -y upgrade
printf "\n\ndoing: apt -y install pandoc\n"
apt -y install pandoc
printf "\n\ndoing: apt -y install libxml2-dev libxslt-dev\n"
apt -y install libxml2-dev libxslt-dev
printf "\n\ndoing: apt -y install libblas-dev liblapack-dev\n"
apt -y install libblas-dev liblapack-dev
printf "\n\ndoing: apt -y install libatlas-base-dev gfortran\n"
apt -y install libatlas-base-dev gfortran
printf "\n\ndoing: apt -y install libtiff5-dev libjpeg62-turbo-dev\n"
apt -y install libtiff5-dev libjpeg62-turbo-dev
printf "\n\ndoing: apt -y install zlib1g-dev libfreetype6-dev liblcms2-dev\n"
apt -y install zlib1g-dev libfreetype6-dev liblcms2-dev
printf "\n\ndoing: apt -y install libwebp-dev tcl8.5-dev tk8.5-dev\n"
apt -y install libwebp-dev tcl8.5-dev tk8.5-dev
printf "\n\ndoing: apt -y libharfbuzz-dev libfribidi-dev\n"
apt -y install libharfbuzz-dev libfribidi-dev
printf "\n\ndoing: apt -y install libhdf5-dev\n"
apt -y install libhdf5-dev
printf "\n\ndoing: apt -y install libnetcdf-dev\n"
apt -y install libnetcdf-dev
printf "\n\ndoing: apt -y install python3-pip\n"
apt -y install python3-pip
printf "\n\ndoing: apt -y install python3-venv\n"
apt -y install python3-venv
printf "\n\ndoing: apt -y install libzmq3-dev\n"
apt -y install libzmq3-dev
printf "\n\ndoing: apt -y install sqlite3\n"
apt -y install sqlite3