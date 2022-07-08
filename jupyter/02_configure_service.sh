#!/bin/bash
# script name:     conf_service.sh
# last modified:   2022/07/08
# credits:         mt08xx
# sudo:            yes

RED='\033[0;31m'
GREEN='\033[0;33m'
NC='\033[0m' # No Color
echo -e "${GREEN}Creating jupyter service${NC}"

script_name=$(basename -- "$0")

if ! [ $(id -u) = 0 ]; then
   echo "usage: sudo ./$script_name"
   exit 1
fi

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi
env="/home/${usr}/.venv/jupyter"


# create jupyter.sh in /home/<user> and make it executable
cat << ONE > /home/${usr}/jupyter_start.sh && chmod a+x /home/${usr}/jupyter_start.sh
#!/bin/bash
source ${env}/bin/activate
jupyter lab --ip="0.0.0.0" --no-browser
ONE

cat << TWO | sudo tee /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter

[Service]
Type=simple
ExecStart=/bin/bash -c "/home/${usr}/jupyter_start.sh"
User=${usr}
Group=${usr}
WorkingDirectory=/home/${usr}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
TWO

# start jupyter
systemctl daemon-reload
systemctl enable jupyter.service
systemctl start jupyter.service
