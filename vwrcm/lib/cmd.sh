#

###
#
###

vwrcm_add ()
{
	vwrcm_add_help ()
	{
		cat <<EOF
$VWRCM_CMD $CUR_CMD - dotfiles manager

Usage: $VWRCM_CMD [options] [<args>]
  $VWRCM_CMD add -f (<file> [$DOT_DIR/path/to/the/file])

Options:
  -h, --help                  Show this help message.
  -f <file>,                  Add file.
  -d <directory>,             Add directory.
  -i <file|direcotry>,        Add file or directory.
EOF
	}

	vwrcm_add_file ()
	{
		local dotrc=$1
		local dotpath=$(vwrcm_get_absolute_file_dir $dotrc)
		local rcmpath="$VWRCM_LOCAL_ROOT_DIR$dotpath"
		local rcmrc="$rcmpath/${dotrc##*/}"
		local linkpath=$dotpath
		local linkrc=$dotrc

		vwrcm_make_dir $rcmpath
		mv -i $dotrc $rcmpath
		ln -si $rcmrc $linkrc

		echo "F | $rcmrc | $linkrc" >> "$(vwrcm_get_linked_info_name)"
	}

	vwrcm_add_dir ()
	{
		local dotdir=$1
		local rcmdir="$VWRCM_LOCAL_ROOT_DIR$(vwrcm_get_absolute_dir $dotdir)"
		local rcmdirname=$(dirname "$VWRCM_LOCAL_ROOT_DIR$(vwrcm_get_absolute_dir $dotdir)")
		local linkdir=$dotdir

		vwrcm_make_dir $rcmdirname
		mv -i $dotdir $rcmdirname
		ln -si $rcmdir $linkdir

		echo "D | $rcmdir | $linkdir" >> "$(vwrcm_get_linked_info_name)"
	}

	CUR_CMD="${0##*_}"
	OPTIND=1

	local originrc origindir

	while getopts 'f:d:i:h' OPT
	do
		case $OPT in
			h) vwrcm_add_help; return 1;;
			f) originrc=$(vwrcm_get_absolute_path "$OPTARG")
			   vwrcm_check_is_file $originrc || return 1
			   vwrcm_add_file $originrc;;
			d) origindir=$(vwrcm_get_absolute_dir "$OPTARG")
			   vwrcm_check_is_dir $origindir || return 1
			   vwrcm_add_dir $origindir;;
			i) if [ -f $OPTARG ]
			   then
				   vwrcm_add_file $(vwrcm_get_absolute_path "$OPTARG")
			   elif [ -d $origindir ]
			   then
				   vwrcm_add_dir $(vwrcm_get_absolute_dir "$OPTARG")
			   else
				   return 1
			   fi;;
			*) vwrcm_add_help; return 1;;
		esac
	done

	unset -f vwrcm_add_help vwrcm_add_file vwrcm_add_dir
}

vwrcm_list ()
{
	local total=0
	echo $(vwrcm_prmpt 7 "$VWRCM_CMD list")

	while read line
	do
		if [[ $line =~ '\|' ]]
		then
			let total++
			echo $total:$line
		fi
	done < $(vwrcm_get_linked_info_name)

	echo $(vwrcm_prmpt_warning "total: $total")
}

vwrcm_restore ()
{
	vwrcm_restore_help ()
	{
		cat <<EOF
$VWRCM_CMD $CUR_CMD - dotfiles manager

Usage: $VWRCM_CMD [options] [<args>]
  $VWRCM_CMD add -f (<file> [$DOT_DIR/path/to/the/file])

Options:
  -h                      Show this help message.
  -i <file|diretory>      Restore file or diretory.
  -a                      Restore all.
EOF
	}

	vwrcm_restore_do ()
	{
		local result=$1
		local keyword dottype dotrc linkrc origindir linkread

		echo $result |
			while read -r line
			do
				dottype=$(echo $(echo $line | awk -F['|'] '{print $1}'))
				dotrc=$(echo $(echo $line | awk -F['|'] '{print $2}'))
				linkrc=$(echo $(echo $line | awk -F['|'] '{print $3}'))
				origindir=${dotrc#"$(vwrcm_get_root_dir)"}
				linkread=$(readlink $linkrc)

				if [[ -e $dotrc && -L $linkrc && $linkread == $dotrc ]]
				then
					if [ $dottype == "F" ]
					then
						rm -f $linkrc
						mv -i $dotrc $origindir
						vwrcm_delete_rc $line
						echo $dotrc -- $origindir
					elif [ $dottype == "D" ]
					then
						rm -rf $linkrc
						mv -i $dotrc $origindir
						vwrcm_delete_rc $line
						echo $dotrc -- $origindir
					fi
				fi
			done # <<<"$result"
	}

	CUR_CMD="${0##*_}"
	OPTIND=1

	while getopts 'i:ah' OPT
	do
		case $OPT in
			h) vwrcm_restore_help
			   return 0;;
			i) keyword=$(vwrcm_get_absolute_path $OPTARG)
			   vwrcm_restore_do "$(vwrcm_find_rc $keyword)";;
			a) vwrcm_restore_do "$(vwrcm_find_rc)";;
			*) vwrcm_restore_help
			   return 1;;
		esac
	done
}

vwrcm_check ()
{
	echo $(vwrcm_prmpt 7 "$VWRCM_CMD check result")

	local total=0
	local success=0
	local fail=0

	while read line
	do
		if [[ $line =~ '\|' ]]
		then
			let total++
			local dotrctype=$(echo $line | awk -F['|'] '{print $1}')
			local dotrc=$(echo $(echo $line | awk -F['|'] '{print $2}'))
			local linkrc=$(echo $(echo $line | awk -F['|'] '{print $3}'))
			local linkread=$(readlink $linkrc)

			if [[ -f $dotrc || -d $dotrc || -L linkrc && $linkread == $dotrc ]]
			then
				let success++
				echo "$(vwrcm_prmpt_success ✔) $(vwrcm_prmpt_warning $dotrctype)$total:$dotrc $(vwrcm_prmpt 6 '->') $linkrc"
			else
				let fail++
				echo "$(vwrcm_prmpt_error ✘) $(vwrcm_prmpt_warning $dotrctype)$total:$dotrc $(vwrcm_prmpt 1 '-x') $linkrc"
			fi
		fi
	done < $(vwrcm_get_linked_info_name)

	echo "total:$(vwrcm_prmpt_warning $total) success:$(vwrcm_prmpt_success $success) fail:$(vwrcm_prmpt_error $fail)"
}

vwrcm_cmd_exit ()
{
	unset -f vwrcm_add vwrcm_list vwrcm_restore vwrcm_check vwrcm_cmd_exit
}
