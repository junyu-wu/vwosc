#!/usr/bin/bash

echo -en "load custom script finished.\n"
echo -en "custom script running...\n"


customize_run ()
{
	if [ -n "$(xinput | grep -i hhkb)" ]
	then
		echo -en "run hhkb keyboard maping"
		nohup sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py >> /dev/null 2>&1 &
	elif [ -n "$(xinput | grep -i ikbc)" ]
	then
		echo -en "run ickb keyboard maping"
		nohup sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py >> /dev/null 2>&1 &
	else
		echo -en "run normal keyboard maping"
		nohup sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs.py >> /dev/null 2>&1 &
	fi

	nohup sudo $TROJAN_HOME/trojan $TROJAN_HOME/config.json >> /dev/null 2>&1 &

	emacs &	tmux
}

customize_quit ()
{
	sudo pkill trojan && echo "\nkill trojan finished..."
	sudo pkill xkeysnail && echo "\nkill xkeysnail finished..."

	exit_shell
}

exit_shell ()
{
	local sh_name="$(ps -p $$ --no-headers -o comm=)"

	if [[ $sh_name == "zsh" ]]; then                                                                                         ###
		# zsh or zsh plugins
		###
		printf "%s" "$(tput bold)$(tput setaf 2)exit? [y(yes)|n(no)] ?$(tput civis)"

		if read -sk ok
		then
			echo -n "$(tput cnorm)"
			case $ok in
				y) exit
				   ;;
            n)  ;;
			*) exit ;;
			esac
        else
			timeout_mode
        fi

    elif [[ $sh_name == "bash" || $sh_name == "sh" ]]; then
        ###
	    # bash or sh
	    ###
	    if read -n 1 -t 3 -p "$(tput bold)$(tput setaf 2)exit? [y(yes)|n(no)] ?$(tput civis)" ok
	    then
			case $ok in
				y) exit
				   ;;
            n)  ;;
			*) exit ;;
			esac
       fi
	fi
}
