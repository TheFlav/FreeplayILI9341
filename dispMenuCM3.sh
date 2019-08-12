#!/usr/bin/env bash

INPUT=/tmp/menu.sh.$$

stop_all_running_services ()
{
	sudo service fbcp stop
	sudo systemctl stop fbcpOld.service
	sudo systemctl stop fbcpCropped.service
	sudo systemctl stop fbcpFilled.service
	sudo systemctl stop fbcpCroppedNoSleep.service
	sudo systemctl stop fbcpFilledNoSleep.service
	sudo killall Freeplay-fbcp
	sudo killall fbcpOld
	sudo killall fbcpCropped
	sudo killall fbcpOldNoSleep
	sudo killall fbcpCroppedNoSleep
}

disable_all_services ()
{
	sudo update-rc.d fbcp.sh disable
	sudo systemctl disable fbcpOld.service
	sudo systemctl disable fbcpCropped.service
	sudo systemctl disable fbcpFilled.service
	sudo systemctl disable fbcpCroppedNoSleep.service
	sudo systemctl disable fbcpFilledNoSleep.service
}

update ()
{
	git -C /home/pi/Freeplay/FreeplayILI9341 pull

	stop_all_running_services

	/home/pi/Freeplay/FreeplayILI9341/installCM3.sh

	dialog --clear --title "Update"
}

use_dev_cropped ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services

	sleep 1
	sudo systemctl enable fbcpCropped.service
	sudo reboot
}

use_dev_filled ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services

	sleep 1
	sudo systemctl enable fbcpFilled.service
	sudo reboot
}

use_bp_cropped ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services
	sudo systemctl enable fbcpBPCropped.service

	sleep 1
	sudo reboot
}

use_dev_cropped_sleep ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services
	sudo systemctl enable fbcpCroppedNoSleep.service

	sleep 1
	sudo reboot
}


use_bp_cropped_sleep ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services
	sudo systemctl enable fbcpBPCroppedNoSleep.service

	sleep 1
	sudo reboot
}

use_dev_filled_sleep ()
{
	sudo sed -i "s|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|" /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services
	sudo systemctl enable fbcpFilledNoSleep.service

	sleep 1
	sudo reboot
}

use_std ()
{
	sudo sed -i 's|^#FP#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt

	stop_all_running_services

	sleep 1

	disable_all_services
	sudo systemctl enable fbcpOld.service

	sleep 1
	sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
	--menu "Choose which LCD Driver you would like to use" 15 50 10 \
	Default "Default Driver" \
	Exp_Cropped "Cropped for the GBA viewport" \
	Exp_Filled "Fills the entire display" \
	Exp_NoSleep_Cropped "Cropped for the GBA viewport, no sleep" \
	Exp_NoSleep_Filled "Fills the entire display, no sleep" \
	Exp_BP_Crop "Boxy Pixel Cropped" \
	Exp_BP_NoSleep_Crop "Boxy Pixel Cropped, No Sleep" \
	Update "Update binaries and Menu" \
	Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
	Default) use_std;;
	Exp_Cropped) use_dev_cropped;;
	Exp_Filled) use_dev_filled;;
	Exp_NoSleep_Cropped) use_dev_cropped_sleep;;
	Exp_NoSleep_Filled) use_dev_filled_sleep;;
	Exp_BP_Crop) use_bp_cropped;;
	Exp_BP_NoSleep_Crop) use_bp_cropped_sleep;;
	Update) update;;
	Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
