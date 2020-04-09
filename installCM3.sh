#!/bin/bash

stop_all_running_services ()
{
	sudo service fbcp stop
	sudo systemctl stop fbcpOld.service
	sudo systemctl stop fbcpCropped.service
	sudo systemctl stop fbcpFilled.service
	sudo systemctl stop fbcpBPCropped.service
	sudo systemctl stop fbcpCroppedNoSleep.service
	sudo systemctl stop fbcpFilledNoSleep.service
	sudo systemctl stop fbcpBPCroppedNoSleep.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpOld
	sudo killall fbcpCropped
	sudo killall fbcpOldNoSleep
	sudo killall fbcpCroppedNoSleep
	sudo killall fbcpBPCropped
	sudo killall fbcpBPCroppedNoSleep
}

INSTALL_DIR=/home/pi/Freeplay/$( ls /home/pi/Freeplay | grep -i freeplayili9341 )

git -C $INSTALL_DIR pull

stop_all_running_services

sudo cp $INSTALL_DIR/fbcpFilled /usr/local/bin/fbcpFilled
sudo cp $INSTALL_DIR/fbcpCropped /usr/local/bin/fbcpCropped
sudo cp $INSTALL_DIR/fbcpBPCropped /usr/local/bin/fbcpBPCropped
sudo cp $INSTALL_DIR/fbcpFilledNoSleep /usr/local/bin/fbcpFilledNoSleep
sudo cp $INSTALL_DIR/fbcpCroppedNoSleep /usr/local/bin/fbcpCroppedNoSleep
sudo cp $INSTALL_DIR/fbcpBPCroppedNoSleep /usr/local/bin/fbcpBPCroppedNoSleep

mkdir -p "/home/pi/RetroPie/retropiemenu/Freeplay Options"
cp $INSTALL_DIR/dispMenuCM3.sh "/home/pi/RetroPie/retropiemenu/Freeplay Options/dispMenu.sh"
cp $INSTALL_DIR/display.png /home/pi/RetroPie/retropiemenu/icons/display.png
sudo cp $INSTALL_DIR/fbcpCropped.service /lib/systemd/system/fbcpCropped.service
sudo cp $INSTALL_DIR/fbcpFilled.service /lib/systemd/system/fbcpFilled.service
sudo cp $INSTALL_DIR/fbcpBPCropped.service /lib/systemd/system/fbcpBPCropped.service
sudo cp $INSTALL_DIR/fbcpCroppedNoSleep.service /lib/systemd/system/fbcpCroppedNoSleep.service
sudo cp $INSTALL_DIR/fbcpFilledNoSleep.service /lib/systemd/system/fbcpFilledNoSleep.service
sudo cp $INSTALL_DIR/fbcpBPCroppedNoSleep.service /lib/systemd/system/fbcpBPCroppedNoSleep.service
sudo cp $INSTALL_DIR/fbcpOld.service /lib/systemd/system/fbcpOld.service

sudo systemctl disable fbcpFilled.service
sudo systemctl disable fbcpCropped.service
sudo systemctl disable fbcpBPCropped.service
sudo systemctl disable fbcpFilledNoSleep.service
sudo systemctl disable fbcpCroppedNoSleep.service
sudo systemctl disable fbcpBPCroppedNoSleep.service
sudo update-rc.d fbcp.sh disable
sudo rm -rf /etc/init.d/fbcp.sh

sudo systemctl enable fbcpOld.service
sudo systemctl start fbcpOld.service

sudo sed -i "s|^#dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

if grep -q "Freeplay Change Display Driver" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ; then
	echo "Display Driver Menu Item Already Added"
else
	sudo sed -i 's|</gameList>|\t<game>\n\t\t<path>./Freeplay Options/dispMenu.sh</path>\n\t\t<name>Freeplay Change Display Driver</name>\n\t\t<desc>Choose which display driver to use, between two versions of the experimental driver and the default driver</desc>\n\t\t<image>./icons/display.png</image>\n\t\t<playcount>0</playcount>\n\t\t<lastplayed>20180514T205700</lastplayed>\n\t</game>\n</gameList>|' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
fi
