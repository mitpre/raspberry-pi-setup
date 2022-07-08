#!/bin/bash

script_name=$(basename -- "$0")

if ! [ $(id -u) = 0 ]; then
   echo "usage: sudo ./$script_name"
   exit 1
fi

if [ $SUDO_USER ]; then usr=$SUDO_USER; else usr=`whoami`; fi

cat << ONE | sudo tee /etc/systemd/system/pigpiodaemon.service
[Unit]
Description=Daemon required to control GPIO pins via pigpio

[Service]
ExecStart=/usr/bin/pigpiod -l -n localhost -p 9999
ExecStop=/bin/systemctl kill pigpiod
Type=forking

[Install]
WantedBy=multi-user.target
ONE

systemctl daemon-reload
systemctl enable pigpiodaemon.service
systemctl start pigpiodaemon.service
#systemctl status pigpiodaemon.service
