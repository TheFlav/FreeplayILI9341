#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

use_dev_cropped ()
{
    if ! systemctl is-active --quiet fbcp
    then
        sudo sed -i 's|dtoverlay=waveshare32b|#dtoverlay=waveshare32b|' /boot/config.txt
    fi
    
    sudo service fbcp stop
    sudo service fbcpCropped stop
    sudo service fbcpFilled stop
    sudo service fbcpZero stop
    
    sleep 1
    
    sudo update-rc.d fbcpCropped.sh enable
    sudo update-rc.d fbcpFilled.sh disable
    sudo update-rc.d fbcp.sh disable
    sudo update-rc.d fbcpZero.sh disable
    
    sleep 1
    dialog --title 'Driver Changed' --msgbox 'Using Cropped experimental driver\nSystem must reboot\nTurn on again after system is off' 5 30
    sleep 5
    sudo reboot
}

use_dev_filled ()
{
    if ! systemctl is-active --quiet fbcp
    then
        sudo sed -i 's|dtoverlay=waveshare32b|#dtoverlay=waveshare32b|' /boot/config.txt
    fi
    
    sudo service fbcp stop
    sudo service fbcpCropped stop
    sudo service fbcpFilled stop
    sudo service fbcpZero stop
    
    sleep 1
    
    sudo update-rc.d fbcpCropped.sh disable
    sudo update-rc.d fbcpFilled.sh enable
    sudo update-rc.d fbcp.sh disable
    sudo update-rc.d fbcpZero.sh disable
    
    sleep 1
    dialog --title 'Driver Changed' --msgbox 'Using Filled experimental driver\nSystem must reboot\nTurn on again after system is off' 5 30
    sleep 5
    sudo reboot
}

use_zero ()
{ 
    if ! systemctl is-active --quiet fbcp
    then
        sudo sed -i 's|dtoverlay=waveshare32b|#dtoverlay=waveshare32b|' /boot/config.txt
    fi
    
    sudo service fbcp stop
    sudo service fbcpCropped stop
    sudo service fbcpFilled stop
    sudo service fbcpZero stop
    
    sleep 1
    
    sudo update-rc.d fbcpCropped.sh disable
    sudo update-rc.d fbcpFilled.sh disable
    sudo update-rc.d fbcp.sh disable
    sudo update-rc.d fbcpZero.sh enable
    
    sleep 1
    dialog --title 'Driver Changed' --msgbox 'Using Zero experimental driver\nSystem must reboot\nTurn on again after system is off' 5 30
    sleep 5
    sudo reboot
}

use_std ()
{
    if systemctl is-active --quiet fbcpZero -eq 0 -o systemctl is-active --quiet fbcpCropped -eq 0 -o systemctl is-active --quiet fbcpFilled -eq 0
    then
        sudo sed -i 's|#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt
    fi
    
    sudo service fbcp stop
    sudo service fbcpCropped stop
    sudo service fbcpFilled stop
    sudo service fbcpZero stop
    
    sleep 1
    
    sudo update-rc.d fbcpCropped.sh disable
    sudo update-rc.d fbcpFilled.sh disable
    sudo update-rc.d fbcp.sh enable
    sudo update-rc.d fbcpZero.sh disable
    
    sleep 1
    dialog --title 'Driver Changed' --msgbox 'Using default driver\nSystem must reboot\nTurn on again after system is off' 5 30
    sleep 5
    sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 5 \
Default "Default Driver" \
Exp_Cropped "Cropped for the GBA viewport" \
Exp_Filled "Fills the entire display" \
Exp_Zero "Exp Cropped for FP Zero" \

Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
    Default) use_std;;
    Exp_Cropped) use_dev_cropped;;
    Exp_Filled) use_dev_filled;;
    Exp_Zero) use_zero;;
    Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
