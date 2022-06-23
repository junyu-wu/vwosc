### .zshrc

#*******************************************************************************
#
# zsh configure
# load and init vwzsh for zsh
#
#*******************************************************************************
export VWZ="$HOME/.vwz"
export ZSH=$VWZ

IS_TRANSPARENT=0

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
export EMACS_HOME=$PREFIX/emacs/28.1
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

function wm_windows_list()
{
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

function wm_switch_window ()
{
	print "activate windows:"
	wm_windows_list
	select=""
	vared -p 'select: ' -c select
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
## rbenv
export RBENV_HOME=$HOME/.rbenv
export PATH=$PATH:$RBENV_HOME/bin
if [ -d $RBENV_HOME ] ; then
   eval "$(rbenv init - zsh)"
fi
## rvm
export RVM_HOME=$HOME/.rvm
export RVM_GEM_HOME=$RVM_HOME/gems
[[  -s "$RVM_HOME/scripts/rvm" ]] && . "$RVM_HOME/scripts/rvm"
export PATH=$PATH:$RVM_HOME/bin

## golang
export GOROOT=$PREFIX/go
export GOPATH=$HOME/workspace/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN
export GO111MODULE=on
# export GOPROXY=https://goproxy.io
export GOPROXY=https://goproxy.cn
# export GOPROXY=mirrors.aliyun.com/goproxy

## python
# anaconda
export CONDA_HOME=$PREFIX/anaconda/3
export PATH=$PATH:$CONDA_HOME/bin

## java
# export JAVA_HOME=$PREFIX/java/jdk8
# export PATH=$PATH:.
# export CLASSPATH=
_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
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
export PATH=$PATH:$LUA_HOME/lua-5.4.4/src

## maven
export MAVEN_HOME=$PREFIX/maven/3.8.2
export PATH=$PATH:$MAVEN_HOME/bin

## nodejs
export NODE_HOME=$PREFIX/node/v16.15.0
export NPM_PATH=$NODE_HOME/node_global/bin
export PATH=$PATH:$NODE_HOME/bin:$NPM_PATH

## dotnet
export DOTNET_HOME=$PREFIX/dotnet
export DOTNET_ROOT=$DOTNET_HOME
export PATH=$PATH:$DOTNET_HOME

## mono
export MONO_HOME=$PREFIX/mono
export PATH=$PATH:$MONO_HOME/bin

## redis
export REDIS_HOME=$PREFIX/redis/redis-6.2.6
if [ -d $REDIS_HOME ] ; then
	export PATH=$PATH:$REDIS_HOME/bin
fi

## omnisharp
# export OMNISHARP_HOME=$PREFIX/omnisharp

## protobuf
export PROTOBUF_HOME=$PREFIX/protobuf
export PATH=$PATH:$PROTOBUF_HOME/bin


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
	function pgsql_cmd_help ()
	{
		cat <<EOF
pgsql - pgsql command

Usage: pgsql [options]
pgsql -s | -q | -r | -a | -t | -h

		Options:
  		-h,                         Show this help message.
  		-s,                         Start postgresql server.
  		-q,                         Stop postgresql server.
  		-r,                         Restart postgresql server.
  		-t,                         Show postgresql server status.
EOF
		}


	while getopts 'hsqrt' OPT
	do
		case $OPT in
			h) pgsql_cmd_help; return 1;;
			s) eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data -l $POSTGRESQL_HOME/log/logfile'"
			   echo "postgresql server started";;
			q) eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl stop -D $POSTGRESQL_HOME/data'"
			   echo "postgresql server stoped";;
			r) eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data'"
			   echo "postgresql server restart";;
			t) eval "su $POSTGRESQL_USER_NAME -c '$POSTGRESQL_HOME/bin/pg_ctl status -D $POSTGRESQL_HOME/data'"
			   echo "postgresql server status";;
			*) pgsql_cmd_help
			   ; return 1;;
		esac
	done

	unset -f pgsql_cmd_help
}

## nyxt
export NYXT_HOME=$PREFIX/nyxt
export PATH=$PATH:$NYXT_HOME/bin

## metasploit-framework
export MSF_HOME=$PREFIX/msf/metasploit-framework
# export MSF_GEM_HOME=$RVM_GEM_HOME/ruby-2.6.5@msf

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

# wine32exe
# run wine 32 app
function wine32exe()
{
	wineexecpath="Exec=env WINEPREFIX="$WINE_ENV_HOME/$1" wine-stable C:\\\\windows\\\\command\\\\start.exe /Unix $WINE_ENV_HOME/$1/dosdevices/c:/users/Public/Desktop/$2.lnk";
	echo $wineexecpath
	eval $wineexecpath
}

function wine32exe_cn()
{
	wineexecpath="env LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8 WINEPREFIX="$WINE_ENV_HOME/$1" wine-stable C:\\\\windows\\\\command\\\\start.exe /Unix $WINE_ENV_HOME/$1/dosdevices/c:/users/Public/Desktop/$2.lnk";
	echo $wineexecpath
	eval $wineexecpath
}

## xkeysnail
export XKEYSNAIL_PATH=$HOME/.config/xkeysnail

## trojan
export TROJAN_HOME=/usr/local/trojan

## mu4e
if [ -d $PREFIX/mu ]; then
	export MU_HOME=$PREFIX/mu
	export PATH=$PATH:$MU_HOME/bin
	export MU_DIR=/home/workspace/mail
fi

## browser
export CHROME_HOME=/opt/chrome-linux
if [ -d $CHROME_HOME ]; then
	export PATH=$PATH:$CHROME_HOME
fi

## keybinds
# bindkey '^ ' autosuggest-accept

## alias
# proxy alias
alias proxy="sudo $TROJAN_HOME/trojan $TROJAN_HOME/config.json"
alias kproxy="sudo pkill trojan"
alias px="proxychains4"
alias prx="sudo service privoxy start"

# display
alias xrl="xrandr --output eDP-1 --left-of DP-2 --auto"
alias xrr="xrandr --output eDP-1 --right-of DP-2 --auto"
alias xrs="xrandr --output DP-2 --auto"
alias xrc="xrandr --output DP-2 --same-as eDP-1"
alias xrk="xrandr --output DP-2 --off"
alias xrmp="xrandr --output eDP1 --mode "
alias xrme="xrandr --output DP-2 --mode "

# emacs alias
alias ed="emacs --daemon"
alias ex="emacs &"
alias et="emacs -nw"
alias ek="emacsclient -e '(kill-emacs)'"
alias ecx='emacsclient -nc "$@" -a ""'
alias ect='emacsclient -t "$@" -a ""'

# apt alias
alias agi="sudo apt install"
alias age="sudo apt search"
alias agu="sudo apt update"
alias agg="sudo apt upgrade"
alias agd="sudo apt dist-upgrade"
alias agr="sudo apt autoremove"

alias cdw="cd $HOME/workspace/"
alias cdd="cd $HOME/Downloads/"
alias cdv="cd $HOME/workspace/vwosc"

# xterm
alias xtc="xtermcontrol"

# wmctrl
alias ws="wm_switch_window"

# vwstartup
alias i="vwstartup"

# xkeysanil alias
alias xk="sudo xkeysnail --quiet $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xkl="sudo xkeysnail $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xhk="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xhkl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xik="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"
alias xikl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"
alias kxk="sudo pkill xkeysnail"

# msf alias
alias msftidy="ruby '$MSF_HOME/tools/dev/msftidy.rb'"

# wine alias
alias wine32="winesetup"
alias wexe32="wine32exe"
alias wexe32cn="wine32exe_cn"

alias wechat="wexe32 'im' wechat >> /dev/null 2>&1"
alias wechatcn="wexe32cn 'im/wx' wechat"

# postman
alias postman="/opt/Postman/Postman"

# calibra
alias calibre="/opt/calibre/calibre &"

# baidunetdisk
alias bnd="/opt/baidunetdisk/baidunetdisk >> /dev/null 2>&1"
# xi | sed 's/[⎜|↳|⎡|⎣]//g' | sed -n '/ikbc/Ip' | awk '{sub(/^[\t ]*/,"");print}'

# sisco packettracer
alias ciscopt="/opt/pt/packettracer"
