#!/bin/sh

INPUT=/tmp/menu.sh.$$

vi_editor=${EDITOR-vi}

update ()
{
    git -C /home/pi/Freeplay/freeplayili9341 pull

    sudo cp fbcpZero /usr/local/bin
    sudo cp dispMenuZero.sh /home/pi/RetroPie/retropiemenu/dispMenu.sh
}

use_zero ()
{
    sudo sed -i 's|^dtoverlay=waveshare32b|#FP#dtoverlay=waveshare32b|' /boot/config.txt
    
    sudo service fbcp stop
    sudo systemctl stop fbcpZero.service
    sudo killall Freeplay-fbcp
    sudo killall fbcpZero
    
    sleep 1
    
    sudo update-rc.d fbcp.sh disable
    sudo systemctl enable fbcpZero.service
    
    sleep 1
    sudo systemctl start fbcpZero.service
    dialog --title 'Driver Changed' --msgbox 'Using Zero experimental driver after Reboot' 5 30
    sleep 2
    sudo reboot
}

use_std ()
{
    sudo sed -i 's|^#FP#dtoverlay=waveshare32b|dtoverlay=waveshare32b|' /boot/config.txt
    
    sudo service fbcp stop
    sudo systemctl stop fbcpZero.service
    sudo killall fbcpZero
    
    sleep 1
    
    sudo update-rc.d fbcp.sh enable
    sudo systemctl disable fbcpZero.service
    
    sleep 1
    sudo service fbcp start
    dialog --title 'Driver Changed' --msgbox 'Using default driver after reboot' 5 30
    sleep 2
    sudo reboot
}

dialog --clear --title "LCD Driver Selection" \
--menu "Choose which LCD Driver you would like to use" 15 50 4 \
Default "Default Driver" \
Exp_Zero "Exp Cropped for FP Zero" \
Update "Update binaries and Menu" \
Exit "Exit without any changes" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case "$menuitem" in
    Default) use_std;;
    Exp_Zero) use_zero;;
    Update) update;;
    Exit) echo "No changes made"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
