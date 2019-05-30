#!/usr/bin/env bash

INPUT=/tmp/dialogInstall.sh.$$

dialog --clear --title "Freeplay Advanced Driver Install" \
	--menu "Select your Freeplay model:" 0 0 0 \
	CM3 "Tested and fairly stable" \
	Zero "Not recommended, poor emulator compatibility" \
	Exit "Exit without installation" 2> "${INPUT}"

MENUITEM=$(<"${INPUT}")

case "$MENUITEM" in
	CM3) ./setupCM3.sh;;
	Zero) ./setupZero.sh;;
	Exit) echo "No driver installed"; break;;
esac

[ -f "$INPUT" ] && rm "$INPUT"
