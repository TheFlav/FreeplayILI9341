#!/bin/bash

INSTALL_DIR=/home/pi/Freeplay/$( ls /home/pi/Freeplay | grep -i freeplayili9341 )

git -C $INSTALL_DIR pull

sudo cp $INSTALL_DIR/fbcpFilled /usr/local/bin/fbcpFilled
sudo cp $INSTALL_DIR/fbcpCropped /usr/local/bin/fbcpCropped

mkdir -p "/home/pi/RetroPie/retropiemenu/Freeplay Options"
cp $INSTALL_DIR/dispMenuCM3.sh "/home/pi/RetroPie/retropiemenu/Freeplay Options/dispMenu.sh"
cp $INSTALL_DIR/display.png /home/pi/RetroPie/retropiemenu/icons/display.png
sudo cp $INSTALL_DIR/fbcpCropped.service /lib/systemd/system/fbcpCropped.service
sudo cp $INSTALL_DIR/fbcpFilled.service /lib/systemd/system/fbcpFilled.service

sudo systemctl disable fbcpFilled.service
sudo systemctl disable fbcpCropped.service
sudo update-rc.d fbcp.sh disable
sudo rm -rf /etc/init.d/fbcp.sh

sudo cp $INSTALL_DIR/fbcpOld.service /lib/systemd/system/fbcpOld.service

sudo systemctl enable fbcpOld.service

if grep -q "Freeplay Change Display Driver" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ; then
	echo "Display Driver Menu Item Already Added"
else
	sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./Freeplay Options/dispMenu.sh</path>\n\t\t<name>Freeplay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
fi
