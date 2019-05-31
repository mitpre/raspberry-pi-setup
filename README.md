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
The easiest step: [raspberrypi.org>Downloads>NOOBS](https://www.raspberrypi.org/downloads/noobs/)
1. Download
2. Extract
3. Place the files to the root of the SD card that you formatted in the previous step.
4. SD to rPi
5. Boot up and choose Raspbian (at least the one with Desktop ...)

### Change/modify the following
**password**, hostname, screen size, what you plan on using on the rPi (I2C, SPI, remote GPIO, ...)

### Change the default `pi` username
will be done tomorrow

### Update

### Reinstall `pip` and `pip3` to get the most recent version

### Jupyter
