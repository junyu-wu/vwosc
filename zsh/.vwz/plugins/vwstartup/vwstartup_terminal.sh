#!/usr/bin/bash

check_permission ()
{
	local current_user=$(whoami)
	local current_id=$(id -u)

	if [ "$current_user" != "root" ]; then
		if [ current_id != 0 ]; then
			echo "user permission check failed, permission denied."
			return 1
		else
			echo "permission"
		fi
	fi

	return 0
}

normal_mode ()
{
	echo -e "\n$(tput setaf 3)startup normal mode."

	return 0
}

custom_mode ()
{
	echo -e "\n$(tput setaf 3)startup custom mode."

	echo "custom path :" $VWSTARTUP_ROOT/custom.sh
	source $VWSTARTUP_ROOT/custom.sh

	return 0
}

timeout_mode ()
{
	echo -en "\n$(tput bold)$(tput setaf 1)time out. "

	normal_mode

	return 0
}

vwstartup ()
{
	local sh_name="$(ps -p $$ --no-headers -o comm=)"

	if [[ $sh_name == "zsh" ]]; then                                                                                         ###
		# zsh or zsh plugins
		###
		printf "%s" "$(tput bold)$(tput setaf 2)select startup mode [n(normal)|c(custom)|*(normal)] ?$(tput civis)"

		if read -sk tag
		then
			echo -n "$(tput cnorm)"
			case $tag in
				n) normal_mode ;;
                c) custom_mode ;;
			    *) normal_mode ;;
            esac
        else
			timeout_mode
        fi

    elif [[ $sh_name == "bash" || $sh_name == "sh" ]]; then
        ###
	    # bash or sh
	    ###
        # if ! check_permission ; then
		#     return 1
	    # fi

	    if read -n 1 -t 3 -p "$(tput bold)$(tput setaf 2)select startup mode [n(normal)|c(custom)|*(normal)] ?$(tput civis)" tag
	    then
		    case $tag in
			    n) normal_mode ;;
                c) custom_mode ;;
			    *) normal_mode ;;
            esac
	   else
	    	timeout_mode
       fi
    fi

	return 0
}
