#!/usr/bin/env bash

INPUT=/tmp/menu.sh.$$

update ()
{
	git -C /home/pi/Freeplay/freeplayili9341 pull

	sudo cp /home/pi/Freeplay/freeplayili9341/fbcpZero /usr/local/bin/fbcpZero
	sudo cp /home/pi/Freeplay/freeplayili9341/fbcpZeroNoDMA /usr/local/bin/fbcpZeroNoDMA
	sudo cp /home/pi/Freeplay/freeplayili9341/dispMenuZero.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
	sudo cp /home/pi/Freeplay/freeplayili9341/fbcpZero.service /lib/systemd/system/fbcpZero.service
	sudo cp /home/pi/Freeplay/freeplayili9341/fbcpZeroNoDMA.service /lib/systemd/system/fbcpZeroNoDMA.service

	sudo mv /home/pi/RetroPie/retropiemenu/dispMenu.sh /home/pi/RetroPie/retropiemenu/oldDispMenu.sh
	sudo cp /home/pi/Freeplay/freeplayili9341/dispMenuZero.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
	sudo rm /home/pi/RetroPie/retropiemenu/oldDispMenu.sh
}

use_zero ()
{
	sudo sed -i 's|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|' /boot/config.txt

		sudo service fbcp stop
	sudo systemctl stop fbcpZero.service
	sudo systemctl stop fbcpZeroNoDMA.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpZero
	sudo killall fbcpZeroNoDMA

	sleep 1

	sudo update-rc.d fbcp.sh disable
	sudo systemctl disable fbcpZeroNoDMA.service
	sudo systemctl enable fbcpZero.service

	sleep 1
	sudo reboot
}

use_zero_no_dma ()
{
	sudo sed -i 's|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|' /boot/config.txt

		sudo service fbcp stop
	sudo systemctl stop fbcpZero.service
	sudo systemctl stop fbcpZeroNoDMA.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpZero
	sudo killall fbcpZeroNoDMA

	sleep 1

	sudo update-rc.d fbcp.sh disable
	sudo systemctl enable fbcpZeroNoDMA.service
	sudo systemctl disable fbcpZero.service

	sleep 1
	sudo reboot
}

use_std ()
{
	sudo sed -i 's|^#FP#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt

	sudo service fbcp stop
	sudo systemctl stop fbcpZero.service
	sudo systemctl stop fbcpZeroNoDMA.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpZero
	sudo killall fbcpZeroNoDMA

	sudo sed -i 's/VIEWPORT=0/VIEWPORT=1/' /boot/freeplayfbcp.cfg

	sleep 1

	sudo update-rc.d fbcp.sh enable
	sudo systemctl disable fbcpZero.service
	sudo systemctl disable fbcpZeroNoDMA.service

	sleep 1
	sudo reboot
}

use_std_no_crop ()
{
	sudo sed -i 's|^#FP#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt

	sudo service fbcp stop
	sudo systemctl stop fbcpZero.service
	sudo systemctl stop fbcpZeroNoDMA.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpZero
	sudo killall fbcpZeroNoDMA

	sudo sed -i 's/VIEWPORT=1/VIEWPORT=0/' /boot/freeplayfbcp.cfg

	sleep 1


	sudo update-rc.d fbcp.sh enable
	sudo systemctl disable fbcpZero.service
	sudo systemctl disable fbcpZeroNoDMA.service

	sleep 1
	sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
	--menu "Choose which LCD Driver you would like to use" 15 50 4 \
	Default "Default Driver" \
	Exp_Zero "Exp Cropped for FP Zero" \
	NoDMA_Zero "FP Zero w/out DMA" \
	Update "Update binaries and Menu" \
	Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
	Default) use_std;;
	Default_Uncropped) use_std_no_crop;;
	Exp_Zero) use_zero;;
	NoDMA_Zero) use_zero_no_dma;;
	Update) update;;
	Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
