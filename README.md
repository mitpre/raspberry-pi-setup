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

### Installing the *NOOBS* software
The easiest task:
1. Download [raspberrypi.org>Downloads>NOOBS](https://www.raspberrypi.org/downloads/noobs/)
2. Extract
3. Place the files to the root of the SD card that you formatted in the previous step.
4. SD to rPi
5. Boot up, choose Raspbian (at least the one with Desktop) and wait
6. Follow the Welcome to Raspberry Pi 'setup' guide
     - Set Cuntry: leave it as it is (my personal preference)
     - Change Password: d00h
     - Set Up Screen: tick the box if you agree
     - Select WiFi Network & Enter WiFi Password: recomended
     - Update Software: yes
     - Restart

Step by step instruction to this point can be found on [projects.raspberrypi.org](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up) if needed...

7. rPi Menu > Prefrences > Raspberry Pi Configuration:
	 - System > Change Hostname: yes!
	 - System > Boot: To CLI; needed to change the user; after reboot you login in console and can afterwards start the desktop with `startx`
	 - System > Auto Login: untick
	 - Interfaces: thick what you need
	 - Localisation > Locale: here you can change the language, & shit
	 - Localisation > Timezone: set it
	 - Localisation > WiFi Country: is it needed?
	 - OK > Reboot

8. Just to be sure run the following update commands (if everything went as it should those commands won't do a thing, if not they will make sure to update the system)
     - `sudo apt-get update`
     - `sudo apt-get upgrade`
     - `sudo apt-get dist-upgrade`
     - `sudo apt-get autoremove`
     - `sudo apt-get autoclean`

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


### Reinstall `pip` and `pip3` to get the most recent version

`pip` versions installed with raspberry pi are ancient, therefore run the following (by 'sorin' from [stackoverflow.com](https://stackoverflow.com/a/37531821/3290167))
```
sudo apt-get remove python-pip python3-pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
rm get-pip.py
pip3 install --upgrade pip
pip install --upgrade pip
```

If you only use `pip install --upgrade pip` and `pip3 install --upgrade pip` you end up in a fucked up situation. Then you have to remove the following:
```
/home/mip/.local/bin/pip
/home/mip/.local/bin/pip3
/home/mip/.local/bin/pip3.5
/home/mip/.local/lib/python3.5/site-packages/pip-19.1.1.dist-info/*
/home/mip/.local/lib/python3.5/site-packages/pip/*
```
And the same for python2.

### Jupyter

Installing is now easy as you have pip 19+:
1) pip3 install jupyter
2) If you want to access it remotely
	- `jupyter notebook --generate-config` this generates config file in `/home/<new user>/.jupyter/jupyter_notebook_config.py`
	- in that config file you have to change and/or uncomment:
		 - `c.NotebookApp.ip = '0.0.0.0'` so that it listens on all ip addresses
		 - `c.NotebookApp.port = 8888`
		 - `c.Notebook.open_browser = False` since you wanna do it remotely it's pointless to have a session starting locally
	- if you don't want to copy the token every time you should set up a password:
		 - start python and type in the following
		 ```
		 python3
		 from notebook.auth import passwd
		 passwd()
		 ```

