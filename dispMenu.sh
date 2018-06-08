#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

use_dev_cropped ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop
	sudo service fbcpZero stop

	sudo update-rc.d fbcpCropped.sh enable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh disable
	sudo update-rc.d fbcpZero.sh disable

	sleep 1
	sudo service fbcpCropped start
        sudo sed -i 's|dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|#dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|' /boot/config.txt
	echo "Using Cropped Experimental Driver"
	sleep 5
}

use_dev_filled ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop
	sudo service fbcpZero stop

	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh enable
	sudo update-rc.d fbcp.sh disable
	sudo update-rc.d fbcpZero.sh disable

	sleep 1
	sudo service fbcpFilled start
        sudo sed -i 's|dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|#dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|' /boot/config.txt
	echo "Using Filled Experimental Driver"
	sleep 5
}

use_std ()
{
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop
	sudo service fbcpZero stop

	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh enable
	sudo update-rc.d fbcpZero.sh disable

	sleep 1
	sudo service fbcp start
        sudo sed -i 's|#dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|' /boot/config.txt
	echo "Using Standard Driver"
	sleep 5
}

use_zero ()
{ 
	sudo service fbcp stop
	sudo service fbcpCropped stop
	sudo service fbcpFilled stop
	sudo service fbcpZero stop

	sudo update-rc.d fbcpCropped.sh disable
	sudo update-rc.d fbcpFilled.sh disable
	sudo update-rc.d fbcp.sh disable
	sudo update-rc.d fbcpZero.sh enable

	sleep 1
	sudo service fbcp start
        sudo sed -i 's|dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|#dtoverlay=waveshare32b,speed=80000000,fps=60,rotate=270|' /boot/config.txt
	echo "Using Standard Driver"
	sleep 5
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 5 \
Default "Default Driver" \
Exp_Cropped "Cropped for the GBA viewport" \
Exp_Filled "Fills the entire display" \
Exp_Zero "Exp Cropped for FP Zero" \

Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case $menuitem in
	Default) use_std;;
	Exp_Cropped) use_dev_cropped;;
	Exp_Filled) use_dev_filled;;
        Exp_Zero) use_zero;;
	Exit) echo "No changes made"; break;;
esac

[ -f $INPUT ] && rm $INPUT
