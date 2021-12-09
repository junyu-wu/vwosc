#! /usr/bin/env bash

set  -o errexit

[  GLOBAL::CONF  ]

{
readonly ROOT_UID=0
readonly GRUB_THEME_NAME="VWISS_GRUB::THEMES"
readonly MAX_DELAY=20

tui_root_login=

THEME_DIR="/usr/share/grub/themes"
REO_DIR="$(cd $(dirname $0) && pwd)"
}

THEME_VARIANTS=('vwiss')
ICON_VARIANTS=('color' 'white' 'whitesur')
SCREEN_VARIANTS=('1080p' '2k' '4k' 'ultrawide' 'ultrawide2k')

#COLORS
CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # waring color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"                                # bold warning color

# echo like ... with flag type and display message colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;    # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;    # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;    # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;    # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

# Check command availability
function has_command() {
  command -v $1 > /dev/null
}

usage() {
  printf "%s\n" "Usage: ${0##*/} [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-b, --boot" "install grub theme into /boot/grub/themes"
  printf "  %-25s%s\n" "-t, --theme" "theme variant(s) [tela|vimix|stylish|whitesur] (default is tela)"
  printf "  %-25s%s\n" "-i, --icon" "icon variant(s) [color|white|whitesur] (default is color)"
  printf "  %-25s%s\n" "-s, --screen" "screen display variant(s) [1080p|2k|4k|ultrawide|ultrawide2k] (default is 1080p)"
  printf "  %-25s%s\n" "-r, --remove" "Remove theme (must add theme name option)"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

updating_grub() {
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command zypper; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
  elif has_command dnf; then
    if [[ -f /boot/efi/EFI/fedora/grub.cfg ]]; then
      prompt -i "Find config file on /boot/efi/EFI/fedora/grub.cfg ...\n"
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
    if [[ -f /boot/grub2/grub.cfg ]]; then
      prompt -i "Find config file on /boot/grub2/grub.cfg ...\n"
      grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
  fi

  # Success message
  prompt -s "\n * All done!"
}

# Use dialog install
config() {
	if [[ -x /usr/bin/dialog ]]; then
		if [[ "$UID" -ne "$ROOT_UID"  ]]; then
			#Check if password is cached (if cache timestamp not expired yet)
			sudo -n true 2> /dev/null && echo

			if [[ $? == 0 ]]; then
				#No need to ask for password
				sudo $0
			else
				#Ask for password
				tui_root_login=$(dialog --backtitle ${GRUB_THEME_NAME} \
										--title  "ROOT LOGIN" \
										--insecure \
										--passwordbox  "require root permission" 8 50 \
										--output-fd 1 )

				sudo -S echo <<< $tui_root_login 2> /dev/null && echo

				if [[ $? == 0 ]]; then
					#Correct password, use with sudo's stdin
					sudo -S "$0" <<< $tui_root_login
				else
					#block for 3 seconds before allowing another attempt
					sleep 3
					clear
					prompt -e "\n [ Error! ] -> Incorrect password!\n"
					exit 1
				fi
			fi
		fi

		tui=$(dialog --backtitle ${GRUB_THEME_NAME} \
					 --radiolist "Choose your Grub theme background picture : " 15 40 5 \
					 1 "vwiss theme" on --output-fd 1 )
		case "$tui" in
			1) theme="vwiss"      ;;
			*) operation_canceled ;;
		esac

		tui=$(dialog --backtitle ${GRUB_THEME_NAME} \
					 --radiolist "Choose icon style : " 15 40 5 \
					 1 "white" off \
					 2 "color" on \
					 3 "whitesur" off --output-fd 1 )
		case "$tui" in
			1) icon="white"       ;;
			2) icon="color"       ;;
			3) icon="whitesur"    ;;
			*) operation_canceled ;;
		esac

		tui=$(dialog --backtitle ${GRUB_THEME_NAME} \
					 --radiolist "Choose your Display Resolution : " 15 40 5 \
					 1 "1080p (1920x1080)" on  \
					 2 "2k (2560x1440)" off \
					 3 "4k (3840x2160)" off --output-fd 1 )
		case "$tui" in
			1) screen="1080p"       ;;
			2) screen="2k"          ;;
			3) screen="4k"          ;;
			*) operation_canceled   ;;
		esac

	else
		if has_command zypper; then
			sudo zypper in dialog
		elif has_command apt-get; then
			sudo apt-get install dialog
		elif has_command dnf; then
			sudo dnf install -y dialog
		elif has_command yum; then
			sudo yum install dialog
		elif has_command pacman; then
			sudo pacman -S --noconfirm dialog
		fi

		config
	fi
}

grub_init() {
	local theme=${1}
	local icon=${2}
	local screen=${3}

	# Check for root access and proceed if it is present
	if [[ "$UID" -eq "$ROOT_UID" ]]; then
		clear

		# Create themes directory if it didn't exist
		prompt -s "\n Checking for the existence of themes directory..."

		[[ -d "${THEME_DIR}/${theme}" ]] && rm -rf "${THEME_DIR}/${theme}"
		mkdir -p "${THEME_DIR}/${theme}"

		# Copy theme
		prompt -s "Installing ${theme} ${icon} ${screen} theme..."

		# Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
		cp -a --no-preserve=ownership "${REO_DIR}/common/"{*.png,*.pf2} "${THEME_DIR}/${theme}"
		cp -a --no-preserve=ownership "${REO_DIR}/config/theme-${screen}.txt" "${THEME_DIR}/${theme}/theme.txt"
		cp -a --no-preserve=ownership "${REO_DIR}/backgrounds/${screen}/background-${theme}.png" "${THEME_DIR}/${theme}/background.png"

		cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-${icon}/icons-${screen}" "${THEME_DIR}/${theme}/icons"
		cp -a --no-preserve=ownership "${REO_DIR}/assets/assets-select/select-${screen}/"*.png "${THEME_DIR}/${theme}"
		cp -a --no-preserve=ownership "${REO_DIR}/assets/info-${screen}.png" "${THEME_DIR}/${theme}/info.png"

		# Set theme
		prompt -s "\n Setting ${theme} as default..."

		# Backup grub config
		cp -an /etc/default/grub /etc/default/grub.bak

		# Fedora workaround to fix the missing unicode.pf2 file (tested on fedora 34): https://bugzilla.redhat.com/show_bug.cgi?id=1739762
		# This occurs when we add a theme on grub2 with Fedora.
		if has_command dnf; then
			if [[ -f "/boot/grub2/fonts/unicode.pf2" ]]; then
				if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
					#Replace GRUB_FONT
					sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/grub2/fonts/unicode.pf2|" /etc/default/grub
				else
					#Append GRUB_FONT
					echo "GRUB_FONT=/boot/grub2/fonts/unicode.pf2" >> /etc/default/grub
				fi
			elif [[ -f "/boot/efi/EFI/fedora/fonts/unicode.pf2" ]]; then
				if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
					#Replace GRUB_FONT
					sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2|" /etc/default/grub
				else
					#Append GRUB_FONT
					echo "GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2" >> /etc/default/grub
				fi
			fi
		fi

		if grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null; then
			#Replace GRUB_THEME
			sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"|" /etc/default/grub
		else
			#Append GRUB_THEME
			echo "GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"" >> /etc/default/grub
		fi

		# Make sure the right resolution for grub is set
		if [[ ${screen} == '1080p' ]]; then
			gfxmode="GRUB_GFXMODE=1920x1080,auto"
		elif [[ ${screen} == '4k' ]]; then
			gfxmode="GRUB_GFXMODE=3840x2160,auto"
		elif [[ ${screen} == '2k' ]]; then
			gfxmode="GRUB_GFXMODE=2560x1440,auto"
		fi

		if grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null; then
			#Replace GRUB_GFXMODE
			sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub
		else
			#Append GRUB_GFXMODE
			echo "${gfxmode}" >> /etc/default/grub
		fi

		if grep "GRUB_TERMINAL=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
			#Replace GRUB_TERMINAL
			sed -i "s|.*GRUB_TERMINAL=.*|#GRUB_TERMINAL=console|" /etc/default/grub
		fi

		if grep "GRUB_TERMINAL_OUTPUT=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL_OUTPUT=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
			#Replace GRUB_TERMINAL_OUTPUT
			sed -i "s|.*GRUB_TERMINAL_OUTPUT=.*|#GRUB_TERMINAL_OUTPUT=console|" /etc/default/grub
		fi

		# For Kali linux
		if [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then
			cp -an /etc/default/grub.d/kali-themes.cfg /etc/default/grub.d/kali-themes.cfg.bak
			sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub.d/kali-themes.cfg
			sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${theme}/theme.txt\"|" /etc/default/grub.d/kali-themes.cfg
		fi

		# Update grub config
		prompt -s "\n Updating grub config...\n"

		updating_grub

		prompt -w "\n * At the next restart of your computer you will see your new Grub theme: '$theme' "
	else
		#Check if password is cached (if cache timestamp not expired yet)
		sudo -n true 2> /dev/null && echo

		if [[ $? == 0 ]]; then
			#No need to ask for password
			sudo "$0" -t ${theme} -i ${icon} -s ${screen}
		else
			#Ask for password
			if [[ -n ${tui_root_login} ]] ; then
				if [[ -n "${theme}" && -n "${screen}" ]]; then
					sudo -S $0 -t ${theme} -i ${icon} -s ${screen} <<< ${tui_root_login}
				fi
			else
				prompt -e "\n [ Error! ] -> Run me as root! "
				read -p " [ Trusted ] Specify the root password : " -t ${MAX_DELAY} -s

				sudo -S echo <<< $REPLY 2> /dev/null && echo

				if [[ $? == 0 ]]; then
					#Correct password, use with sudo's stdin
					sudo -S "$0" -t ${theme} -i ${icon} -s ${screen} <<< ${REPLY}
				else
					#block for 3 seconds before allowing another attempt
					sleep 3
					prompt -e "\n [ Error! ] -> Incorrect password!\n"
					exit 1
				fi
			fi
		fi
	fi
}

install() {
	config
	grub_init "${theme}" "${icon}" "${screen}"
}

install

exit 1
