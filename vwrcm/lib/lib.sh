#

###
#
###

vwrcm_help ()
{
	cat <<EOF
$VWRCM_CMD - dotfiles manager

Usage: $VWRCM_CMD [options] <commands> [<args>]
  $VWRCM_CMD add (<file> [$DOT_DIR/path/to/the/file]) | <symboliclinks>...
  $VWRCM_CMD clear

Commands:
  list    Show the list which files will be managed by $DOT_COMMAND.
  check   Check the files are correctly linked to the right places.
  add     Move the file to the dotfiles directory and make its symbolic link to that place.
  restore Restore dotfiles to origin path.

Options:
  -h      Show this help message.
  -c      Check linked file or directory.
  -l      Show linked file or directory list.
EOF
}

vwrcm_hash_uname ()
{
	echo "$(uname -a | tr -d '\\n' | md5sum | cut -d ' ' -f1)"
}

vwrcm_prmpt ()
{
	echo "$(tput bold)$(tput setaf $1)$2$(tput sgr0)"
}

vwrcm_prmpt_error ()
{
	echo "$(vwrcm_prmpt 1 $1)"
}

vwrcm_prmpt_success ()
{
	echo "$(vwrcm_prmpt 2 $1)"
}

vwrcm_prmpt_warning ()
{
	echo "$(vwrcm_prmpt 3 $1)"
}

vwrcm_get_absolute_dir ()
{
	echo "$(builtin cd $1 && builtin pwd)"
}

vwrcm_get_absolute_file_dir ()
{
	echo "$(builtin cd "$(dirname "$1")" && builtin pwd)"
}

vwrcm_get_absolute_path ()
{
	echo "$(vwrcm_get_absolute_file_dir $1)"/"$(basename "$1")"
}

vwrcm_make_dir ()
{
	if [ ! -d $1 ]
	then
		mkdir -p "$1"
		echo "[vwrcm] make $1 directory."
	fi
}

vwrcm_get_root_dir ()
{
	echo "$VWRCM_USER_DIR/$(vwrcm_hash_uname)"
}

vwrcm_make_root_dir ()
{
	local user_root_dir=$(vwrcm_get_root_dir)
	if [ ! -d $user_root_dir ]
	then
		mkdir -p "$user_root_dir"
	fi
}

vwrcm_get_linked_info_name ()
{
	echo "$VWRCM_USER_DIR/$(vwrcm_hash_uname)/$(vwrcm_hash_uname).vwrcm"
}

vwrcm_make_linked_info ()
{
	local user_root_linked_info="$(vwrcm_get_linked_info_name)"
	if [ ! -f $user_root_linked_info ]
	then
		touch $user_root_linked_info
		echo "vwrcm linked info\n[linked list]" >> $user_root_linked_info
	fi
}

vwrcm_check_is_file ()
{
	if [[ -f $1 && ! -L $1 ]]
	then
		return 0
	else
		echo -n "[$(vwrcm_prmpt_error error)] "
		echo "file $(tput bold)$1$(tput sgr0) not found."
		return 1
	fi
}

vwrcm_check_is_dir ()
{
	if [ -d $1 ]
	then
		return 0
	else
		echo -n "[$(vwrcm_prmpt_error error)] "
		echo "directory $(tput bold)$1$(tput sgr0) not found."
		return 1
	fi
}

vwrcm_check_is_link ()
{
	if [ -L $1 ]
	then
		return 0
	else
		echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
		echo "file $(tput bold)$1$(tput sgr0) is not link."
		return 1
	fi
}

vwrcm_find_rc ()
{
	local keyword=$(echo ${1:-" "} | sed "s|\/|####|g")
	local rclist=$(cat $(vwrcm_get_linked_info_name) | sed '1,2d')
	local result=$(echo $rclist | sed "s|\/|####|g" | sed -n "/$keyword/p" | sed "s|####|\/|g")

	echo $result
}

vwrcm_delete_rc ()
{
	local keyword=$(echo $1 | sed "s|\/|####|g")
	local rclistfile=$(vwrcm_get_linked_info_name)
	local rcresult=$(cat $(vwrcm_get_linked_info_name))

	sed -i -e "s|\/|####|g" -e "/$keyword/d" -e "s|####|\/|g" $rclistfile
}

vwrcm_read_config ()
{
	INIFILE=$VWRCM_ROOT/config
	SECTION=$1
	ITEM=$2

	readvalue=$(awk -F ' ' '$1!~/#/ {print $0}' $INIFILE | awk -F '=' '/\['$SECTION'\]/$1~/'$ITEM'/{print $2;exit}')
	echo ${readvalue}
}

vwrcm_exit ()
{
	unset -f vwrcm_help vwrcm_hash_uname
	unset -f vwrcm_prmpt vwrcm_prmpt_error vwrcm_prmpt_success vwrcm_prmpt_warning
	unset -f vwrcm_get_absolute_dir vwrcm_get_absolute_file_dir vwrcm_get_absolute_path
	unset -f vwrcm_make_dir vwrcm_get_root_dir vwrcm_make_root_dir
	unset -f vwrcm_get_linked_info_name vwrcm_make_linked_info
	unset -f vwrcm_check_is_file vwrcm_check_is_dir vwrcm_check_is_link
	unset -f vwrcm_find_rc vwrcm_delete_rc

	unset -f vwrcm_read_config vwrcm_exit
}
