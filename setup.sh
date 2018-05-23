#!/bin/bash

sudo cp fbcpFilled /usr/local/bin/fbcpFilled
sudo cp fbcpCropped /usr/local/bin/fbcpCropped
sudo cp dispMenu.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
sudo cp display.png /home/pi/RetroPie/retropiemenu/icons/display.png
sudo cp fbcpCropped.sh /etc/init.d/fbcpCropped.sh
sudo cp fbcpFilled.sh /etc/init.d/fbcpFilled.sh

sudo chmod +x /etc/init.d/fbcpCropped.sh
sudo chmod +x /etc/init.d/fbcpFilled.sh
sudo chown root:root /etc/init.d/fbcpCropped.sh 
sudo chown root:root /etc/init.d/fbcpFilled.sh

sudo update-rc.d fbcpFilled.sh defaults
sudo update-rc.d fbcpCropped.sh defaults

sudo sed -i 's|hdmi_mode=16|hdmi_mode=4|' /boot/config.txt
sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./dispMenu.sh</path>\n\t\t<name>Freeplay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
