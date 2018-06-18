#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

update ()
{
    git -C /home/pi/Freeplay/freeplayili9341 pull

    sudo cp fbcpFilled /usr/local/bin
    sudo cp fbcpCropped /usr/local/bin
    sudo cp fbcpZero /usr/local/bin
    sudo cp dispMenu.sh /home/pi/RetroPie/retropiemenu
}
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
    sudo service fbcpCropped start
    dialog --title 'Driver Changed' --msgbox 'Using Cropped experimental driver' 1 30
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
    sudo service fbcpFilled start
    dialog --title 'Driver Changed' --msgbox 'Using Filled experimental driver' 1 30
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
    sudo service fbcpZero start
    dialog --title 'Driver Changed' --msgbox 'Using Zero experimental driver' 1 30
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
    sudo service fbcp start
    dialog --title 'Driver Changed' --msgbox 'Using default driver' 1 30
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 6 \
Default "Default Driver" \
Exp_Cropped "Cropped for the GBA viewport" \
Exp_Filled "Fills the entire display" \
Exp_Zero "Exp Cropped for FP Zero" \
Update "Update binaries and Menu" \
Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
    Default) use_std;;
    Exp_Cropped) use_dev_cropped;;
    Exp_Filled) use_dev_filled;;
    Exp_Zero) use_zero;;
    Update) update;;
    Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
