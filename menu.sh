#!/bin/sh

INPUT=/tmp/menu.sh.$$

function use_dev_cropped()
{
	rm -rf /usr/local/bin/Freeplay-fbcp
	cp fbcpCropped /usr/local/bin/Freeplay-fbcp
}

function use_dev_filled()
{
	rm -rf /usr/local/bin/Freeplay-fbcp
	cp fbcpFilled /usr/local/bin/Freeplay-fbcp
}

function use_std()
{
	rm -rf /usr/local/bin/Freeplay-fbcp
	cp fbcpOrig /usr/local/bin/Freeplay-fbcp
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 4 \
Default "Default Driver" \
Experimental Cropped "Experimental Driver, cropped for the GBA viewport" \
Experimental Filled "Experimental Driver, fills the entire display" \
Exit "Exit without making any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case $menuitem in
	Default) use_std;;
	Experimental Cropped) use_dev_cropped;;
	Experimental Filled) use_dev_filled;;
	Exit) echo "No changes made"; break;;
esac

done

[ -f $INPUT ] && rm $INPUT
