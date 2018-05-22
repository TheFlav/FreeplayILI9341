#!/bin/bash

sudo cp fbcpFilled /usr/local/bin/fbcpFilled
sudo cp fbcpCropped /usr/local/bin/fbcpCropped
sudo cp dispMenu.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
sudo cp display.png /home/pi/RetroPie/retropiemenu/icons/display.png

sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./dispMenu.sh</path>\n\t\t<name>Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
