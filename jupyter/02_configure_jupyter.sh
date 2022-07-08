#!/bin/bash
# script name:     conf_jupyter.sh
# last modified:   2018/09/23
# sudo:            no

RED='\033[0;31m'
GREEN='\033[0;33m'
NC='\033[0m' # No Color

script_name=$(basename -- "$0")

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi
env="/home/${usr}/.venv/jupyter"

# i think this never worked
#read -sp 'Enter a desired password for jupyter: ' pass_str
#sha1=$(echo -n $pass_str | tr -d '\n' | sha1sum | awk '{ print $1 }')

if [ $(id -u) = 0 ]
then
   echo "usage: ./$script_name"
   exit 1
fi

# activate virtual environment
echo -e "${GREEN}Activating 'jupyter' virtual environment ${NC}"
source $env/bin/activate

# generate config and create notebook directory
# if Notebook directory exists, we keep it (-p)
# if configuration file exeists, we overwrite it (-y)

echo -e "${GREEN}Generating config file${NC}"
jupyter notebook -y --generate-config
cd $HOME
#mkdir -p Notebooks

target=~/.jupyter/jupyter_notebook_config.py

# set up dictionary of changes for jupyter_config.py
declare -A arr
app='c.NotebookApp'
arr+=(["$app.open_browser"]="$app.open_browser = False")
arr+=(["$app.ip"]="$app.ip = '0.0.0.0'")
arr+=(["$app.port"]="$app.port = 8888")
arr+=(["$app.enable_mathjax"]="$app.enable_mathjax = True")
#arr+=(["$app.notebook_dir"]="$app.notebook_dir = \"/home/${usr}/Notebooks\"")
#arr+=(["$app.password"]="$app.password = \"sha1:${sha1}\"")
arr+=(["$app.allow_remote_access"]="$app.allow_remote_access = True")

# apply changes to jupyter_notebook_config.py

for key in ${!arr[@]};do
    if grep -qF $key ${target}; then
        # key found -> replace line
        sed -i "/${key}/c ${arr[${key}]}" $target
    else
        # key not found -> append line
        echo "${arr[${key}]}" >> $target
    fi
done

# install bash kernel
echo -e "${GREEN}Running: 'bash_kernel.install' ${NC}"
python -m bash_kernel.install

# install extensions
echo -e "${GREEN}Installing: jupyter extensions ${NC}"
jupyter serverextension enable --py jupyterlab
jupyter nbextension enable --py widgetsnbextension --sys-prefix
jupyter nbextension enable --py --sys-prefix bqplot

# activate clusters tab in notebook interface
/home/${usr}/.venv/jupyter/bin/ipcluster nbextension enable --user

# install jupyter lab extensions
bash -i ./03_inst_lab_ext.sh

