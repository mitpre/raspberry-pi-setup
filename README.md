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
     - Set Cuntry: leave everything as it is and you will change it afterwards ... they have some problems with it.
     - Change Password: d00h
     - Set Up Screen: tick the box if you agree
     - Select WiFi Network & Enter WiFi Password: recomended
     - Update Software: yes

Step by step instruction can be found on [projects.raspberrypi.org](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up) if needed...

### Change/modify the following
**password**, hostname, screen size, what you plan on using on the rPi (I2C, SPI, remote GPIO, ...)

### Change the default `pi` username
will be done tomorrow

### Update

### Reinstall `pip` and `pip3` to get the most recent version

### Jupyter

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
