#!/bin/bash

sudo update-rc.d fbcp.sh disable
sudo rm -rf /etc/init.d/fbcp.sh

sudo cp ./fbcpOld.service /lib/systemd/system/fbcpOld.service

sudo systemctl enable fbcpOld.service
