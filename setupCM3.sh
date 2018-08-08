#!/bin/bash

sudo cp fbcpFilled /usr/local/bin
sudo cp fbcpCropped /usr/local/bin
sudo rm /home/pi/RetroPie/retropiemenu/dispMenu.sh
cp dispMenuCM3.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
sudo rm /home/pi/RetroPie/retropiemenu/icons/display.png
cp display.png /home/pi/RetroPie/retropiemenu/icons
sudo cp fbcpCropped.service /lib/systemd/system/fbcpCropped.service
sudo cp fbcpFilled.service /lib/systemd/system/fbcpFilled.service

sudo systemctl disable fbcpFilled.service
sudo systemctl disable fbcpCropped.service
sudo update-rc.d fbcp.sh enable

sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./dispMenu.sh</path>\n\t\t<name>FreePlay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
