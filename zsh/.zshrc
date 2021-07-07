# zsh configuration
## oh my zsh config
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"
HIST_STAMPS="mm/dd/yyyy"
plugins=(
	z
	git
	extract
	git-open # https://github.com/paulirish/git-open.git
	autojump # apt install autojump https://github.com/wting/autojump
	zsh-autosuggestions # https://github.com/zsh-users/zsh-syntax-highlighting.git
    zsh-syntax-highlighting # https://github.com/zsh-users/zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# customize configuration
## general config
## name and email
export NAME=WuJunyu
export EMAIL=vistar_w@hotmail.com

## language
export LANG=en_US.UTF-8

## time
export LC_TIME=en_US.UTF-8

## prefix
export PREFIX=/usr/local

## man
export MANPATH=$PREFIX/man:$MANPATH

## history
export HISTSIZE=10000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth ## ignoredups ignorespace erasedups
export HISTIGNORE="ls:history"

HIST_WHO="`whoami`"
HIST_HOST="`who -u am i 2>/dev/null | awk '{print $NF}' | sed -e 's/[()]//g'`"

if [ "$HIST_HOST" = "" ]; then
	HIST_HOST=`hostname`
fi

HIST_USER="$HIST_WHO@$HIST_HOST"

export HISTTIMEFORMAT="%F %T $HIST_USER"

## emacs
export EMACS_HOME=$PREFIX/emacs/27.1
export PATH=$PATH:$EMACS_HOME/bin


if hash emacs 2>/dev/null; then
	export EDITOR=emacs
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
	xrdb -merge $HOME/.Xresources
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

## ruby
## rvm
export RVM_HOME=$PREFIX/rvm
export RVM_GEM_HOME=$RVM_HOME/gems
[[  -s "$RVM_HOME/scripts/rvm" ]] && . "$RVM_HOME/scripts/rvm"
export PATH=$PATH:$RVM_HOME/bin

## golang
export GOROOT=$PREFIX/go
export GOPATH=/home/workspace/go
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
# export JAVA_HOME=$PREFIX/java/jdk-16
# export PATH=$PATH:$JAVA_HOME/bin
# _SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
alias java='java "$_SILENT_JAVA_OPTIONS"'

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
export NODE_HOME=$PREFIX/nodejs
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
fi

# pgsql_server
# start/stop/restart pgsql server
function pgsql_server ()
{
	if [ "$1" = "-start" ]
	then
		eval "su pgsql -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data -l $POSTGRESQL_HOME/log/logfile'"
		echo "postgresql server started";
	elif [ "$1" = "-stop" ]
	then
		eval "su pgsql -c '$POSTGRESQL_HOME/bin/pg_ctl stop -D $POSTGRESQL_HOME/data'"
		echo "postgresql server stoped";
	elif [ "$1" = "-restart" ]
	then
		eval "su pgsql -c '$POSTGRESQL_HOME/bin/pg_ctl start -D $POSTGRESQL_HOME/data'"
		echo "postgresql server restart";
	elif [ "$1" = "-status" ]
	then
		eval "su pgsql -c '$POSTGRESQL_HOME/bin/pg_ctl status -D $POSTGRESQL_HOME/data'"
		echo "postgresql server status";
	elif [ "$1" = "-connect" ]
	then
		eval "su pgsql -c '$POSTGRESQL_HOME/bin/psql $2'"
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

## proxy
# slhp
# set local http & https proxy
function slhp()
{
	if [ "$1" = "-a" ]
	then
		path=$2

		if [[ $path =~ ":" ]]
		then
			host=${path%:*}
			post=${path##*:}

			if [[ $host =~ "." ]]
			then
				echo "host is localhost, post is " $post
			else
				host="172.0.0.1"
			fi

			export http_proxy=$host:$post
			export https_proxy=$http_proxy

			echo "set http and https proxy is $host:$post";
		else
			post=${path##*:}

			export http_proxy=127.0.0.1:$post
			export https_proxy=$http_proxy

			echo "set http and https proxy is 127.0.0.1:$2";
		fi
	elif [ "$1" = "-r" ]
	then
		unset http_proxy;
		unset https_proxy;
		echo "unset http and https proxy";
	fi
}

## service
# sctl
# run service
function sctl()
{
	if [ "$1" = "-s" ]
	then
		eval "sudo service $2 start";
		echo "sudo service $2 start";
	elif [ "$1" = "-r" ]
	then
		eval "sudo service $2 restart";
		echo "sudo service $2 restart";
	elif [ "$1" = "-q" ]
	then
		eval "sudo service $2 stop";
		echo "sudo service $2 stop";
	elif [ "$1" = "-t" ]
	then
		eval "sudo service $2 status";
		echo "sudo service $2 status";
	elif [ "$1" = "-h" ]
	then
		echo "sctl <option> [service name]"
		echo "     -s       start service";
		echo "     -r       restart service";
		echo "     -q       stop service";
		echo "     -t       status service";
		echo "     -h       help";
	else
		echo "sctl <option> [service name]"
		echo "     -s       start service";
		echo "     -r       restart service";
		echo "     -q       stop service";
		echo "     -t       status service";
		echo "     -h       help";
	fi
}

## keybinds
# bindkey '^ ' autosuggest-accept

## alias
# sys alias
alias vwr="su - root"
alias shome="source ~/.zshrc"
alias logout="xfce4-session-logout -l"
alias sreboot="sudo reboot"
alias poff="sudo shutdown -h now"

# proxy alias
alias proxy="sudo $TROJAN_HOME/trojan $TROJAN_HOME/config.json"
alias p4="proxychains4"
alias privoxy="sudo service privoxy start"

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

# xterm
alias xtc="xtermcontrol"

# tmux alias
alias tmls="tmux ls"
alias tmad="tmux a -d"
alias tmat="tmux a -t"
alias tmks="tmux kill-session -t"

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

# msf alias
alias msftidy="$MSFHOME/tools/dev/msftidy.rb"

# wine alias
alias wine32="winesetup"
alias wexe32="wine32Exec"
alias wexe32cn="wine32ExecForZH_CN"

alias wechat="wexe32 'im/wx' wechat"
alias dding="wexe32cn 'im/dd' DingTalk"

# calibra
alias calibre="/opt/calibre/calibre"

# axure
alias axure="wexe32cn 'rp' axure"

# enterprise architect
alias ea="wexe32cn 'ea' ea"
