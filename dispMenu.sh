#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

use_dev_cropped ()
{
	sudo pkill fbcp
	sudo rm -rf /usr/local/bin/Freeplay-fbcp
	sudo cp fbcpCropped /usr/local/bin/Freeplay-fbcp
	sudo /usr/local/bin/Freeplay-fbcp
}

use_dev_filled ()
{
	sudo pkill fbcp
	sudo rm -rf /usr/local/bin/Freeplay-fbcp
	sudo cp fbcpFilled /usr/local/bin/Freeplay-fbcp
	sudo /usr/local/bin/Freeplay-fbcp
}

use_std ()
{
	sudo pkill fbcp
	sudo rm -rf /usr/local/bin/Freeplay-fbcp
	sudo cp fbcpOrig /usr/local/bin/Freeplay-fbcp
	sudo /usr/local/bin/Freeplay-fbcp
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
