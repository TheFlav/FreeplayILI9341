#!/bin/bash

sudo service fbcpFilled stop
sudo service fbcpCropped stop
sudo service fbcpZero stop

sudo killall fbcpFilled
sudo killall fbcpCropped
sudo killall fbcpZero

sudo update-rc.d fbcpFilled.sh disable
sudo update-rc.d fbcpCropped.sh disable
sudo update-rc.d fbcp.sh enable

sudo rm -rf /usr/local/bin/fbcpFilled
sudo rm -rf /usr/local/bin/fbcpCropped
sudo rm -rf /usr/local/bin/fbcpZero

sudo rm -rf /home/pi/RetroPie/retropiemenu/dispMenu.sh
sudo rm -rf /home/pi/RetroPie/retropiemenu/icons/display.png
sudo rm -rf /etc/init.d/fbcpCropped.sh
sudo rm -rf /etc/init.d/fbcpFilled.sh
sudo rm -rf /etc/init.d/fbcpZero.sh

sudo service fbcp start
