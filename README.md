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
