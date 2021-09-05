### .zshrc

#*******************************************************************************
#
# zsh configure
# load and init vwzsh for zsh
#
#*******************************************************************************
export VWZ="$HOME/.vwz"
export ZSH=$VWZ

IS_TRANSPARENT=1

source $VWZ/.vwzsh

#*******************************************************************************
#
# customize configuration
# customize configuration
#
#*******************************************************************************
## general config
## name and email
export NAME=WuJunyu
export EMAIL=vistar_w@hotmail.com

## emacs
export EMACS_HOME=$PREFIX/emacs/27.1
export PATH=$PATH:$EMACS_HOME/bin


if hash emacs 2>/dev/null; then
	export VISUAL=$EMACS_HOME/bin/emacs
	export EDITOR=VISUAL=$EMACS_HOME/bin/emacs
fi

if [[ -n $SSH_CONNECTION ]]; then
	if hash emacs 2>/dev/null; then
	export EDITOR=emacs
	fi
fi

## terminal
# echo -e -n "\x1b[\x30 q" # changes to blinking block
# echo -e -n "\x1b[\x31 q" # changes to blinking block also
# echo -e -n "\x1b[\x32 q" # changes to steady block
# echo -e -n "\x1b[\x33 q" # changes to blinking underline
# echo -e -n "\x1b[\x34 q" # changes to steady underline
# echo -e -n "\x1b[\x35 q" # changes to blinking bar
echo -e -n "\x1b[\x36 q" # changes to steady bar

## xterm
export XTERM_HOME=$PREFIX/xterm
export XTERMCONTROL_HOME=$XTERM_HOME/share/xtermcontrol
export PATH=$PATH:$XTERM_HOME/bin:$XTERMCONTROL_HOME/bin

if [ -f "$HOME/.Xresources" ] ; then
	xrdb -merge $HOME/.Xresources >> /dev/null 2>&1
fi

## tmux
export TMUX_HOME=$PREFIX/tmux
export PATH=$PATH:$TMUX_HOME/bin

## ibus
export XMODIFIERS=@im=ibus
# export XIM="ibus"
# export GTK_IM_MODULE="xim"
# export QT_IM_MODULE="xim"
# export ibus-daemon -d -x -r

## languages config
## gcc
export CC=/usr/bin/gcc

## tags
# universal ctags
export UCTAGS_HOME=$PREFIX/uctags
export PATH=$PATH:$UCTAGS_HOME/bin

## wmctrl
export WMCTRL_HOME=$PREFIX/wmctrl
export PATH=$PATH:$WMCTRL_HOME/bin

function wm_windows_list() {

	local wms=$(print -r ${(q)"$(wmctrl -x -l)"})
	local rows=(${(s:\n:)wms})

	for i ({1..$#rows}) {

			local columns=(${=${rows[i]//\\/' '}})
		if [[ "$1" == "" ]] {

			printf "%s: %s\n" $i $columns[3]
		} else {
			   if [[ $1 == "$i" ]] {
					  local selects=$columns[3]
					  local select=(${(s:.:)selects})
					  print $select[1]
				  }
		}
	}

}

function wm_switch_window () {

	print "activate windows:"
	wm_windows_list
	vared -p 'select: ' -c select
	# print $sel
	local selected=$(wm_windows_list $select)

	$(wmctrl -x -a $selected)
}

# bash script
# wm_windows_list()
# {
# 	if hash wmctrl 2>/dev/null; then
# 		WMXLS=$( wmctrl -x -l)
# 		IFS=$'\n'
# 		ROW_INDEX=0

# 		for WMXL in $WMXLS; do
# 			IFS=" "
# 			ROW=${WMXL}
# 			COLUMN_INDEX=0

# 			if [ ! -n "$1" ]
# 			then
# 				for COLUMN in $ROW; do
# 					if [ $COLUMN_INDEX == 2 ]
# 					then
# 						echo "$ROW_INDEX: $COLUMN"
# 					fi
# 					let "COLUMN_INDEX += 1"
# 				done

# 			else
# 				if [ $ROW_INDEX == $1 ]
# 				then
# 					for COLUMN in $ROW; do
# 					if [ $COLUMN_INDEX == 2 ]
# 					then
# 						echo "$COLUMN"
# 					fi
# 					let "COLUMN_INDEX += 1"
# 					done
# 				fi
# 			fi
# 			let "ROW_INDEX += 1"
# 		done
# 	else
# 		echo "wmctrl not found. please install ..."
# 	fi
# }

# wm_switch_window()
# {
# echo "please select:"
# wm_windows_list
# read -p "select?" select
# SELECTED=`wm_windows_list $select`
# IFS=$'.'
# TOGGLE=${SELECTED}

# for NAME in $TOGGLE; do
# 	echo "swtich to: $NAME"
# 	# PNAME=$( ps -ax -o comm | grep -i $NAME | grep -v grep )
# 	# if [ "$PNAME" != "" ] ; then
# 	wmctrl -x -a $NAME
# 	# fi
# 	break
# done
# }

## nasm
export NASM_HOME=$PREFIX/nasm
export PATH=$PATH:$NASM_HOME/bin

## ruby
## rvm
export RVM_HOME=$PREFIX/rvm
export RVM_GEM_HOME=$RVM_HOME/gems
[[  -s "$RVM_HOME/scripts/rvm" ]] && . "$RVM_HOME/scripts/rvm"
export PATH=$PATH:$RVM_HOME/bin

## golang
export GOROOT=$PREFIX/go
export GOPATH=$HOME/workspace/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN
export GO111MODULE=on
export GOPROXY=https://goproxy.io
# export GOPROXY=https://goproxy.cn
# export GOPROXY=mirrors.aliyun.com/goproxy

## python
# anaconda
export CONDA_HOME=$PREFIX/anaconda
export PATH=$PATH:$CONDA_HOME/bin

## java
# export JAVA_HOME=$PREFIX/java/jdk8
# export PATH=$PATH:$JAVA_HOME/bin
# _SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
# unset _JAVA_OPTIONS
# alias java='java "$_SILENT_JAVA_OPTIONS"'

## rust
# export RUST_HOME=$PREFIX/rust
# export CARGO_HOME=$RUST_HOME/cargo
# export RUSTC_HOME=$RUST_HOME/rustc
# export PATH=$PATH:$CARGO_HOME/bin:$RUSTC_HOME/bin
export RUSTUP_CARGO_HOME=$HOME/.cargo

if [ -d $RUSTUP_CARGO_HOME ] ; then
	export PATH=$PATH:$RUSTUP_CARGO_HOME/bin
fi

## lua
export LUA_HOME=$PREFIX/lua
export PATH=$PATH:$LUA_HOME/bin

## maven
export MAVEN_HOME=$PREFIX/maven/3.6.3
export PATH=$PATH:$MAVEN_HOME/bin

## nodejs
export NODE_HOME=$PREFIX/node
export NPM_PATH=$NODE_HOME/npm
export PATH=$PATH:$NODE_HOME/bin

## dotnet
export DOTNET_HOME=$PREFIX/dotnet
export DOTNET_ROOT=$DOTNET_HOME
export PATH=$PATH:$DOTNET_HOME

## mono
export MONO_HOME=$PREFIX/mono
export PATH=$PATH:$MONO_HOME/bin

## omnisharp
# export OMNISHARP_HOME=$PREFIX/omnisharp


## tools config
## nmap
export NMAP_HOME=$PREFIX/nmap
if [ -d $NMAP_HOME ] ; then
    PATH=$PATH:$NMAP_HOME/bin
fi

## postgresql
export POSTGRESQL_HOME=$PREFIX/pgsql
if [ -d "$POSTGRESQL_HOME" ] ; then
    PATH=$PATH:$POSTGRESQL_HOME/bin
	export LD_LIBRARY_PATH=$POSTGRESQL_HOME/lib
	export PGHOST=/tmp
	export POSTGRESQL_USER_NAME=postgres
fi

# pgsql
# start/stop/restart pgsql server
function pgsql ()
{
	if [ "$1" = "-s" ]
	then
		eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data -l $POSTGRESQL_HOME/log/logfile'"
		echo "postgresql server started";
	elif [ "$1" = "-d"]
	then
		eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl stop -D $POSTGRESQL_HOME/data'"
		echo "postgresql server stoped";
	elif [ "$1" = "-r" ]
	then
		eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data'"
		echo "postgresql server restart";
	elif [ "$1" = "-t" ]
	then
		eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl status -D $POSTGRESQL_HOME/data'"
		echo "postgresql server status";
	elif [ "$1" = "-c" ]
	then
		eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/psql $2'"
	fi
}

## nyxt
export NYXT_HOME=$PREFIX/nyxt
export PATH=$PATH:$NYXT_HOME/bin

## metasploit-framework
export MSF_HOME=$PREFIX/msf/metasploit-framework
export MSF_GEM_HOME=$RVM_GEM_HOME/ruby-2.6.5@msf

if [ -d $MSF_HOME ] ; then
    PATH=$PATH:$MSF_HOME
fi

if [ -d $MSF_GEM_HOME ] ; then
	export MSF_BIN=$MSF_GEM_HOME/bin
	PATH=$PATH:$MSF_BIN
fi

## exploitdb & searchsploit
export EXPLOITDB_HOME=/opt/exploit-database

if [ -d $EXPLOITDB_HOME ] ; then
    PATH="$PATH:$EXPLOITDB_HOME/searchsploit"
fi

## maltego
export MALTEGO_HOME=/opt/maltego/

if [ -d $MALTEGO_HOME ] ; then
    PATH="$PATH:$MALTEGO_HOME/bin"
fi

## aircrack-ng
export AIRCRACK_HOME=$PREFIX/aircrack-ng

if [ -d $AIRCRACK_HOME ] ; then
	PATH=$PATH:$AIRCRACK_HOME/bin
fi

## cupp
export CUPP_HOME=/opt/cupp/

if [ -d $CUPP_HOME ] ; then
    alias cupp="python3 $CUPP_HOME/cupp.py"
fi

## cewl
export CEWL_HOME=/opt/CeWL

if [ -d $CEWL_HOME ] ; then
    alias cewl="ruby $CEWL_HOME/cewl.rb"
fi

## tor
export TOR_HOME=$PREFIX/tor

if [ -d $TOR_HOME ] ; then
    export PATH="$PATH:$TOR_HOME/bin"
fi

## recon-ng
export RECONNG_HOME=/opt/recon-ng/

if [ -d $RECONNG_HOME ] ; then
    export PATH="$PATH:$RECONNG_HOME"
fi

## bochs
export BOCHS_HOME=$PREFIX/bochs

if [ -d $BOCHS_HOME ] ; then
	export PATH="$PATH:$BOCHS_HOME/bin"
	export BXSHARE=$BOCHS_HOME/share
fi

## guix
if hash guix 2>/dev/null; then
	export GUIX_PACKAGE_PATH=~/.guix-packages
fi

## wine
export WINE_ENV_HOME=$HOME/.wine

# winesetup
# wine command
function winesetup()
{
	winecommand="WINARCH=win32 WINEPREFIX=$WINE_ENV_HOME/";
	winepram=$*;
	winesh=$winecommand$winepram;

	echo $winesh;
	eval $winesh;
}

# wine32Exec
# run wine 32 app
function wine32Exec()
{
	wineexecpath="Exec=env WINEPREFIX="$WINE_ENV_HOME/$1" wine-stable C:\\\\windows\\\\command\\\\start.exe /Unix $WINE_ENV_HOME/$1/dosdevices/c:/users/Public/Desktop/$2.lnk";
	echo $wineexecpath
	eval $wineexecpath
}

function wine32ExecForZH_CN()
{
	wineexecpath="env LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8 WINEPREFIX="$WINE_ENV_HOME/$1" wine-stable C:\\\\windows\\\\command\\\\start.exe /Unix $WINE_ENV_HOME/$1/dosdevices/c:/users/Public/Desktop/$2.lnk";
	echo $wineexecpath
	eval $wineexecpath
}

## xkeysnail
export XKEYSNAIL_PATH=$HOME/.config/xkeysnail/scripts

## trojan
export TROJAN_HOME=/usr/local/trojan

## mu4e
if [ -d $PREFIX/mu ]; then
	export MU_HOME=$PREFIX/mu
	export PATH=$PATH:$MU_HOME/bin
	export MU_DIR=/home/workspace/mail
fi

## keybinds
# bindkey '^ ' autosuggest-accept

## alias
# sys alias
alias logout="xfce4-session-logout -l"
alias sreboot="sudo reboot"
alias poff="sudo shutdown -h now"

# device
alias fingeroff="xinput disable 17"

# proxy alias
alias proxy="sudo $TROJAN_HOME/trojan $TROJAN_HOME/config.json &"
alias p4="proxychains4"
alias privoxy="sudo service privoxy start"

# display
alias xrdl="xrandr --output eDP-1 --left-of DP-2 --auto"
alias xrdr="xrandr --output eDP-1 --right-of DP-2 --auto"
alias xrds="xrandr --output DP-2 --auto"
alias xrdc="xrandr --output DP-2 --same-as eDP-1"
alias xrdk="xrandr --output DP-2 --off"
alias xrdmp="xrandr --output eDP1 --mode "
alias xrdme="xrandr --output DP-2 --mode "

# emacs alias
alias ed="emacs --daemon"
alias edfg="emacs --fg-daemon"
alias ex="emacs &"
alias et="emacs -nw"
alias ek="emacsclient -e '(kill-emacs)'"
alias ecx='emacsclient -nc "$@" -a ""'
alias ect='emacsclient -t "$@" -a ""'

# kill alias
alias k9="kill -9"
alias pkn="pkill -n"

# ps alias
alias peg="ps -ef|grep"

# apt alias
alias agi="sudo apt install"
alias ags="sudo apt search"
alias agu="sudo apt update"
alias agug="sudo apt upgrade"
alias agud="sudo apt dist-upgrade"
alias agrm="sudo apt autoremove"

alias cdw="cd /home/vwx/workspace/"
alias cdd="cd /home/vwx/Downloads/"

# xterm
alias xtc="xtermcontrol"

# tmux alias
alias tmls="tmux ls"
alias tmad="tmux a -d"
alias tmat="tmux a -t"
alias tmks="tmux kill-session -t"

# wmctrl
alias ws="wm_switch_window"

# git alias
alias gint="git init"
alias gad="git add ."
alias gcmt="git commit -m"
alias gps="git push"
alias gst="git status"
alias grs="git reset"
alias gpl="git pull"

# xkeysanil alias
alias xkey="sudo xkeysnail --quiet $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xkeyl="sudo xkeysnail $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xhkey="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xhkeyl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xikey="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"
alias xikeyl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"

# msf alias
alias msftidy="$MSFHOME/tools/dev/msftidy.rb"

# wine alias
alias wine32="winesetup"
alias wexe32="wine32Exec"
alias wexe32cn="wine32ExecForZH_CN"

alias wechat="wexe32 'im/wx' wechat >> /dev/null 2>&1"
alias wechatcn="wexe32cn 'im/wx' wechat"
alias dding="wexe32cn 'im/dd' DingTalk"

# calibra
alias calibre="/opt/calibre/calibre"

# axure
alias axure="wexe32cn 'rp' axure"

# enterprise architect
alias ea="wexe32cn 'ea' ea"
