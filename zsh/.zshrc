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
# customize
# customize configuration
#
#*******************************************************************************

##################
#                #
# general config #
#                #
##################
## name and email
export NAME=WuJunyu
export EMAIL=vistar_w@hotmail.com

################
#              #
# input config #
#              #
################
## ibus
export XMODIFIERS=@im=ibus
# export XIM="ibus"
# export GTK_IM_MODULE="xim"
# export QT_IM_MODULE="xim"
# export ibus-daemon -d -x -r

###################
#                 #
# set environment #
#                 #
###################
## gcc
export CC=/usr/bin/gcc

## default editor
if hash emacs 2>/dev/null; then
	export VISUAL=$EMACS_HOME/bin/emacs
	export EDITOR=VISUAL=$EMACS_HOME/bin/emacs

	if [[ -n $SSH_CONNECTION ]]; then
		export EDITOR=$EMACS_HOME/bin/emacs
	fi
fi

# declare -a env_envs
# typeset -a env_envs
env_envs=(emacs:$PREFIX/emacs/28.1:bin \
			  xterm:$PREFIX/xterm/xterm-372:bin \
			  xtermcontrol:$XTERM_HOME/share/xtermcontrol \
			  uctags:$PREFIX/uctags:bin \
			  wmctrl:$PREFIX/wmctrl:bin \
			  nasm:$PREFIX/nasm:bin \
			  rbenv:$HOME/.rbenv:bin \
			  conda:$PREFIX/anaconda/3:bin \
			  rustup:$HOME/.cargo:bin \
			  lua:$PREFIX/lua:src \
			  maven:$PREFIX/maven/3.8.2:bin \
			  node:$PREFIX/node/v16.15.0:bin \
			  npm:$NODE_HOME/node_global:bin \
			  postgresql:$PREFIX/pgsql:bin \
			  msf:$PREFIX/msf/metasploit-framework \
			  tor:$PREFIX/tor:bin \
			  bochs:$PREFIX/bochs:bin \
			  protobuf:$PREFIX/protobuf:bin \
			  apktool:$PREFIX/apktool \
			  chrome:/opt/chrome-linux \
			  trojan:$PREFIX/trojan)

vwz_set_env_path "${env_envs[@]}"

## wine
export WINE_HOME=$HOME/.wine

## xkeysnail
export XKEYSNAIL_PATH=$HOME/.config/xkeysnail

######################
#                    #
# application config #
#                    #
######################
## xterm
if [ -f "$HOME/.Xresources" ] ; then
	xrdb -merge $HOME/.Xresources >> /dev/null 2>&1
fi

## mu4e
# if [ -d $PREFIX/mu ]; then
# 	export MU_HOME=$PREFIX/mu
# 	export PATH=$PATH:$MU_HOME/bin
# 	export MU_DIR=/home/workspace/mail
# fi

##################
#                #
# develop config #
#                #
##################
## ruby
## rbenv
if [ -d $RBENV_HOME ] ; then
   eval "$(rbenv init - zsh)"
fi

## golang
export GOROOT=$PREFIX/go
export GOPATH=$HOME/workspace/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN
export GO111MODULE=on
export GOPROXY=https://goproxy.cn # https://goproxy.io

## java
# export JAVA_HOME=$PREFIX/java/jdk8
# export PATH=$PATH:.
# export CLASSPATH=
_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
# alias java='java "$_SILENT_JAVA_OPTIONS"'

## rust
# export CARGO_HOME=$RUST_HOME/cargo
# export RUSTC_HOME=$RUST_HOME/rustc
# export RUSTUP_CARGO_HOME=$HOME/.cargo

## postgresql
if [ -d "$POSTGRESQL_HOME" ] ; then
	export LD_LIBRARY_PATH=$POSTGRESQL_HOME/lib
	export PGHOST=/tmp
	export POSTGRESQL_USER_NAME=postgres
fi

## bochs
if [ -d $BOCHS_HOME ] ; then
	export BXSHARE=$BOCHS_HOME/share
fi

################
#              #
# alias config #
#              #
################
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

# xkeysanil alias
alias xk="sudo xkeysnail --quiet $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xkl="sudo xkeysnail $XKEYSNAIL_PATH/vwiss-emacs.py"
alias xhk="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xhkl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-hhkb.py"
alias xik="sudo xkeysnail --watch --quiet $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"
alias xikl="sudo xkeysnail --watch $XKEYSNAIL_PATH/vwiss-emacs-ikbc.py"
alias kxk="sudo pkill xkeysnail"

# wine alias
alias wine32="vwz_winesetup"
alias wexe32="vwz_wine32exe"
alias wechat="wexe32 'im' wechat >> /dev/null 2>&1"

# calibra
alias calibre="/opt/calibre/calibre &"
