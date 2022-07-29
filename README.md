# raspberry-pi-setup

Collection of steps to set up a fresh rPi.

### System setup

1. Use Raspberry Pi OS (https://www.raspberrypi.com/software/)
2. With settings (bottom right icon) set the following:
    - pi's name (i.e., rPi),
    - enable ssh,
    - enable keyd login; you need to have public key generated on your machine --> this makes step 4. obsolete.
    - user name (i.e., rPi) and password, and
    - configure wifi

   Now everything is ready for boot. 

3. Perform a SSH login via `ssh rPi@rPi.local` and run `sudo raspi-config`:
	 - `System Options > Boot / Auto Login > Console` after logging in you can start the graphical interface via `startx`.
	 - `Display Options > VNC Resolution > 1280x1024`
	 - `Interface Options > VNC > Yes`
	 - `Update`
	 
4. Set the passwordless SSH acces. Nicely decribed on [raspberrypi.org](https://www.raspberrypi.com/documentation/computers/remote-access.html#passwordless-ssh-access).

5. Python is already nicely supported by newer version, but use `virtualenv` so that you don't f*ck up the system version.
	- Install `pipx` [Documentation](https://pypa.github.io/pipx/)
		- `python3 -m pip install --upgrade pip`
		- `python3 -m pip install --user pipx`
		- `python3 -m pipx ensurepath`
		- `pipx completions`
	- Install `virtualenv` [Documentation](https://virtualenv.pypa.io/)
		- `pipx install virtualenv`
		
6. Node.js; [Instructions](https://github.com/mklement0/n-install)
	- `curl -L https://bit.ly/n-install | bash -s -- -y lts`

7. Install `pigpio` [Documentation](https://abyz.me.uk/rpi/pigpio/download.html)
	- `sudo apt-get install pigpio python3-pigpio`

8. Run scripts in Jupyter

9. Run script in GPIO

### Setting a static IP (might still be needed)

Lower instructions are still up-to-date, however, it is best to check the actual state at [raspberry pi documentation](https://www.raspberrypi.com/documentation/computers/configuration.html#the-dhcp-daemon).

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
	
### Changing SSH port
	
If you are opening the Pi to the public, it might be good to change the default SSH port. You do this by `sudo nano /etc/ssh/sshd_config` and you change `#Port 22` --> `Port <desired port>` (notice the removed `#`). The `ssh` command is then `ssh -p <desired port> <user>@<pi>`.

### Shut down command without timeout

`sudo shutdown -h now` or `sudo halt -p`
