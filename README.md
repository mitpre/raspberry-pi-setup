# raspberry-pi-setup

Collection of steps to set up a fresh rPi.

### Formatting a Raspbian SD card on MacOS can be a pain in the ass
Solution by "tjklemz" from [apple.stackexchange.com](https://apple.stackexchange.com/a/329075/334048)

1. find the card by `diskutil list`; identifiers are `disk0`, `disk1`, ...
!**do not accidentaly write the wrong identifier in the following steps**!
2. (OPTIONAL) completely remove the data from the card by the following commands
    - unmount: `diskutil unmountDisk <identifier>`
    - zero out the disk (option 1): `diskutil zeroDisk <identifier>`
    - random out the disk (option 2): `diskutil randomDisk <identifier>`
3. formatting the disk by `diskutil eraseDisk FAT32 <CAPITAL NAME OF THE CARD> MBRFormat <identifier>` (unmounting/mounting is handled automatically by `diskutil`)
    - `FAT32` partition type supported by rPi
    - `MBRFormat` Master Boot Record

### Installing the Raspbian
1. Download the latest Raspbian for Raspberry Pi then follow [projects.raspberrypi.org](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)

2. (headless configuration) Create an empty file called "ssh" on the boot partition of the SD card to enable SSH

3. (headless configuration) enable wifi: [raspberrypi.org](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) 

4. boot

5. rPi Menu > Prefrences > Raspberry Pi Configuration:
	 - System > Change Hostname: yes!
	 - System > Boot: To CLI; needed to change the user; after reboot you login in console and can afterwards start the desktop with `startx`
	 - System > Auto Login: untick
	 - Interfaces: thick what you need
	 - Localisation > Locale: here you can change the language, & shit
	 - Localisation > Timezone: set it
	 - Localisation > WiFi Country: is it needed?
	 - OK > Reboot

### Change the default `pi` user

Step by step tuorial by "Dr Beco" from [raspberrypi.stackexchange.com](https://raspberrypi.stackexchange.com/a/68963/52236) (summed up here). Worth to take a look also [here](https://raspberrypi.stackexchange.com/questions/7133/how-to-change-user-pi-sudo-permissions-how-to-add-other-accounts-with-different).

1) While logged in with user `pi` start the terminal and set the password for the root account with `sudo passwd root`
2) Reboot: `sudo reboot`
3) Login with user `root`
4) Check with `ps -u pi` to see an empty list; no processes owned by user `pi`
5) Change the `pi` user in `/etc/passwd` to `<new user>`:
	- `usermod -l <new user> pi`
	- You can check the `/etc/passwd` before/after with `tail /etc/passwd`.
6) Check if `<new user>` is working with: `su <new user>` 
7) Change the group name in `/etc/group` from `pi` to `<new user>`:
	- `groupmod -n <new user> pi`.
	- You can check the `/etc/group` before/after with `tail /etc/group`.
	- At this point '/home/pi' folder should belong to `<new user>`. Check with `ls -la /home/pi`.
8) Rename the `/home/pi` folder to `/home/<new user>`
	- `mv /home/pi /home/<new user>`
9) Associate the `<new user>` home folder with `<new user>`
	- `usermod -d /home/<new user> <new user>`
10) Reboot: `sudo reboot`
11) Login to `<new user>`
12) Check that `<new user>` is `sudoer` with `sudo su -`
13) Change the following folder `/etc/sudoers.d`:
	 - `ls -la /etc/sudoers.d` should give you: `010_at-export, 010_pi-nopasswd, README`
	 - change `010_pi-nopasswd` to `010_<new user>-passwd` with `sudo mv ...`
	 - change the content of `010_<new user>-passwd` from `pi ALL=(ALL) NOPASSWD: ALL` to `<new user> ALL=(ALL) PASSWD: ALL`
14) Reboot: `sudo reboot`
15) login as `<new user>` and delete `root` account with:
	 - `sudo passwd -l root`
16) Get the graphical interface with `startx` and you can set up the login to Desktop if needed, but I would still not use auto login.

### Setting a static IP
The following steps can be used to set a static IP on rPi. Follow it only if you cannot reserve a static IP for rPi on your router. The instructions are based on the "Milliways" answer from [raspberrypi.stackexchange.com](https://raspberrypi.stackexchange.com/a/74428/52236)
1. PREREQUISITES:
     - the IP that you want to set and the network size: `ip -4 addr show | grep global` command returns <current ip>/<network size> for all global connections on rPi.
     - router address/gateway: `ip route | grep default | awk '{print $3}'`
     - DNS server: `cat /etc/resolv.conf`
2. I followed the `dhcpcd method` and it worked. For other options look into "Milliways" answer.
Edit the following file `/etc/dhcpcd.conf` via `sudo nano /etc/dhcpcd.conf` and enter the following:
```
# Example static IP configuration:
interface wlan0
static ip_address=<wanted ip>/<network size>
static routers=<router address/gateway>
static domain_name_servers=<DNS server> 8.8.8.8 fd51:42f8:caae:d92e::1
```
That should do it.


### Set up the passw-less SSH Access

This is nicely decribed on [raspberrypi.org](https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md).


### Python

USE VIRTUALENV AS THINGS LIKE TO GO HAYWIRE AND THAT WAY THE DEFAULT SETUP IS SAFE. The following was reused/modified from [github.com/kleinee/jns](github.com/kleinee/jns).

1) Installing some prerequisites collected in `python/prep.sh` with `./prep.sh` if it doesn't work, you have to set executable permissions with `chmod +x prep.sh`.

```
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
```

2) Create an environment with the `python/create_env.sh` with `./create_env.sh` if it doesn't work, you have to set executable permissions with `chmod +x create_env.sh`.

```
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
```
### Node/NodeJS/npm

[https://github.com/nodesource/distributions](https://github.com/nodesource/distributions)

### Jupyter

The following was reused/modified from [github.com/kleinee/jns](github.com/kleinee/jns).

1) If you didn't already run the first step from Python chapter, and the complete Node/NodeJS/npm chapter (without the latter jupyter lab will most likely fail).
2) 

### Shut down command without timeout

`sudo shutdown -h now` or `sudo halt -p`
