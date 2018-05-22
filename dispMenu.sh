#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

use_dev_cropped ()
{
	sudo update-rc.d fbcpCropped.sh enable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh disable
	echo "Using Cropped Experimental Driver"
	echo "System will Shut Down in 10 Seconds"
	sleep 10
	sudo reboot
}

use_dev_filled ()
{
	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh enable
	sudo update-rc.d fbcp.sh disable
	echo "Using Filled Experimental Driver"
	echo "System will Shut Down in 10 Seconds"
	sleep 10
	sudo reboot
}

use_std ()
{
	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh enable
	echo "Using Standard Driver"
	echo "System will Shut Down in 10 Seconds"
	sleep 10
	sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 4 \
Default "Default Driver" \
Experimental_Cropped "Cropped for the GBA viewport" \
Experimental_Filled "Fills the entire display" \
Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case $menuitem in
	Default) use_std;;
	Experimental_Cropped) use_dev_cropped;;
	Experimental_Filled) use_dev_filled;;
	Exit) echo "No changes made"; break;;
esac

[ -f $INPUT ] && rm $INPUT
