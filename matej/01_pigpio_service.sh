#!/bin/bash
# script name:     conf_service.sh
# last modified:   2018/08/12
# credits:         mt08xx
# sudo:            yes

script_name=$(basename -- "$0")

if ! [ $(id -u) = 0 ]; then
   echo "usage: sudo ./$script_name"
   exit 1
fi

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi
env="/home/${usr}/.venv/jns"


# create pigpio_daemon_start.sh in /home/<user> and make it executable
cat << ONE > /home/${usr}/pigpio_daemon_start.sh && chmod a+x /home/${usr}/pigpio_daemon_start.sh
#!/bin/bash
source ${env}/bin/activate
pigpiod -n localhost
ONE

cat << TWO | sudo tee /etc/systemd/system/pigpiodaemon.service
[Unit]
Description=Daemon required to control GPIO pins via pigpio

[Service]
ExecStart=/usr/bin/pigpiod -l -n localhost -p 9999
ExecStop=/bin/systemctl kill pigpiod
Type=forking

[Install]
WantedBy=multi-user.target
TWO

# start jupyter
systemctl daemon-reload
systemctl enable pigpiodaemon.service
systemctl start pigpiodaemon.service
