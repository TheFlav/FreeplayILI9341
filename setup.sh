#!/bin/bash

sudo cp fbcpFilled /usr/local/bin
sudo cp fbcpCropped /usr/local/bin
sudo cp fbcpZero /usr/local/bin
sudo cp dispMenu.sh /home/pi/RetroPie/retropiemenu
sudo cp display.png /home/pi/RetroPie/retropiemenu/icons
sudo cp fbcpCropped.sh /etc/init.d
sudo cp fbcpFilled.sh /etc/init.d
sudo cp fbcpZero.sh /etc/init.d

sudo chmod +x /etc/init.d/fbcpCropped.sh
sudo chmod +x /etc/init.d/fbcpFilled.sh
sudo chmod +x /etc/init.d/fbcpZero.sh

sudo chown root:root /etc/init.d/fbcpCropped.sh 
sudo chown root:root /etc/init.d/fbcpFilled.sh
sudo chown root:root /etc/init.d/fbcpZero.sh

sudo update-rc.d fbcpFilled.sh defaults
sudo update-rc.d fbcpCropped.sh defaults
sudo update-rc.d fbcpZero.sh defaults

sudo update-rc.d fbcpFilled.sh disable
sudo update-rc.d fbcpCropped.sh disable
sudo update-rc.d fbcpZero.sh disable
sudo update-rc.d fbcp.sh enable

sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./dispMenu.sh</path>\n\t\t<name>FreePlay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
