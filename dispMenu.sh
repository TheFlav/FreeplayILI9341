#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

use_dev_cropped ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop

	sudo update-rc.d fbcpCropped.sh enable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh disable

	sleep 1
	sudo service fbcpCropped start
	echo "Using Cropped Experimental Driver"
	sleep 5
}

use_dev_filled ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop

	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh enable
	sudo update-rc.d fbcp.sh disable

	sleep 1
	sudo service fbcpFilled start
	echo "Using Filled Experimental Driver"
	sleep 5
}

use_std ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop

	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh enable

	sleep 1
	sudo service fbcp start
	echo "Using Standard Driver"
	sleep 5
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
