# PiShrink-FrontEnd-for-PowerShell

![PiShrink Frontend](https://github.com/user-attachments/assets/7ba450e8-055b-4700-81c6-fa8e7084101a)

FrontEnd PowerShell script to show all .img files within its directory, then quickly pass the selected filename to PiShrink.sh for compression

From PiShrink readme: 

PiShrink is a bash script that automatically shrink a pi image that will then resize to the max size of the SD card on boot. 

This will make putting the image back onto the SD card faster and the shrunk images will compress better.


Notes:

You need PiShrink.sh https://github.com/Drewsif/PiShrink

You need Windows Subsystem for Linux (WSL) with a Debian variant installed

You need at least Windows 10 v1903, or Windows 11, to install the Windows Subsystem for Linux. See PiShrink readme for details


Run in the same directory as PiShrink.sh

This display all available .img files in the script's directory

Select an .img file and it will be passed to PiShrink to compress, then output appended with "_Shrunk.img" to same directory
