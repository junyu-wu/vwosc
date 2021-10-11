#

###
#
###

ZSH_SOURCE=${(%):-%x}

VWRCM_ROOT="$(builtin cd "$(dirname "${BASH_SOURCE:-$ZSH_SOURCE}")" && builtin pwd)"
VWRCM_LIB="$VWRCM_ROOT/lib"
VWRCM_CMD="vwrcm"
VWRCM_USER_DIR="$HOME/.vwrcm"
VWRCM_LOCAL_ROOT_DIR=$VWRCM_USER_DIR

export VWRCM_ROOT
export VWRCM_LOCAL_ROOT_DIR
export VWRCM_COM

vwrcm ()
{
	source "$VWRCM_LIB/lib.sh"

	trap vwrcm_exit EXIT KILL QUIT
	local user_home=$(vwrcm_read_config custom user_home)
	local cmd=$(vwrcm_read_config config cmd)
	local sub_dir=$(vwrcm_read_config config sub_dir)

	VWRCM_USER_DIR=${user_home:="$HOME/.vwrcm"}
	VWRCM_CMD=${cmd:="vwrcm"}
	VWRCM_LOCAL_ROOT_DIR=$(vwrcm_get_root_dir)
	OPTIND=1

	if  ! [ hash $VWRCM_CMD 2>/dev/null ]
	then
		eval "alias $VWRCM_CMD=vwrcm"
	fi

	vwrcm_make_root_dir
	vwrcm_make_linked_info

	local arg

	while getopts 'hlc' OPT
	do
		case $OPT in
			h|H) vwrcm_help; return 1;;
			l) arg="do_list";;
			c) arg="do_check";;
			*) vwrcm_help; return 1;;
		esac
	done

	local SUBCMD=${arg:="$1"}
	shift $((OPTIND-1)) # 删除所有opt参数

	case $SUBCMD in
		add|list|check|restore|cofing)
			local sub_cmd="vwrcm_$SUBCMD"
			shift 1
			source "$VWRCM_LIB/cmd.sh"
			${sub_cmd} "$@" || echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] call $sub_cmd failed.\n"
			vwrcm_cmd_exit;;
		do_list)
			local sub_cmd="vwrcm_list"
			source "$VWRCM_LIB/cmd.sh"
			${sub_cmd} "$@" || echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] call $sub_cmd failed.\n"
			vwrcm_cmd_exit;;
		do_check)
			local sub_cmd="vwrcm_check"
			source "$VWRCM_LIB/cmd.sh"
			${sub_cmd} "$@" || echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] call $sub_cmd failed.\n"
			vwrcm_cmd_exit;;
		init) return 0;;
		*) echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
		   echo "command $(tput bold)$1$(tput sgr0) not found."
		   vwrcm_help
		   return 1;;
	esac
}

vwrcm init
