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
	Stable "Stable, slow driver" \
	FastCropped "Cropped for the GBA viewport" \
	FastFilled "Fills the entire display" \
	FastNoSleepCropped "Cropped, no sleep" \
	FastNoSleepFilled "Fills, no sleep" \
	FastBPCrop "Boxy Pixel Cropped" \
	FastBPNoSleepCrop "BP Cropped, No Sleep" \
	Update "Update binaries and Menu" \
	Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
	Stable) use_std;;
	FastCropped) use_dev_cropped;;
	FastFilled) use_dev_filled;;
	FastNoSleepCropped) use_dev_cropped_sleep;;
	FastNoSleepFilled) use_dev_filled_sleep;;
	FastBPCrop) use_bp_cropped;;
	FastBPNoSleepCrop) use_bp_cropped_sleep;;
	Update) update;;
	Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
