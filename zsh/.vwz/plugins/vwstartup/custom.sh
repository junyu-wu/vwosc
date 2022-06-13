#!/usr/bin/bash

echo -en "load custom script finished.\n"
echo -en "custom script running...\n"

nohup sudo xkeysnail --watch --quiet /home/vwx/.config/xkeysnail/vwiss-emacs-hhkb.py >> /dev/null 2>&1 &
nohup sudo /usr/local/trojan/trojan /usr/local/trojan/config.json >> /dev/null 2>&1 &

emacs

alias vwks="sudo pkill trojan && sudo pkill xkeysnail"
