#
# ranger
#
local RANGER_PID

# Press 'Q' exit ranger goto current directory.
function vwz_ranger! {

	local IFS=$'\t\n'
	local tempfile="$(mktemp -t tmp.XXXXXX)"
	local ranger_cmd=(
		command
		ranger
		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
	)

	${ranger_cmd[@]} "$@"
	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
		cd -- "$(cat "$tempfile")" || return
	fi
	command rm -f -- "$tempfile" 2>/dev/null
}

vwz_ranger() {
	if RANGER_PID=$(tmux list-panes -s -F '#{pane_pid}' -t ranger 2> /dev/null); then
		# Leave the current cwd for ranger to read and cleanup.
		pwd > /tmp/zranger-cwd-$UID
		# Detach the other zranger instance...
		tmux detach-client -s ranger
		# ...and give it some time to read ranger's cwd before it changes.
		sleep 0.05              # May need some tweaking.
		# Tell ranger to read zsh's cwd from /tmp and cd to it.
		kill -SIGUSR1 $RANGER_PID
		# Attach to it.
		TMUX='' tmux attach -t ranger
	else
		TMUX='' tmux new-session -s ranger 'exec ${vwz_ranger_to_cd} --cmd="set preview_images=false"'
	fi

	# A second check needed because the process could have been
	# started or stopped in the meantime.
	if RANGER_PID=$(tmux list-panes -s -F '#{pane_pid}' -t ranger 2> /dev/null); then
		cd -P /proc/$RANGER_PID/cwd
	fi
}

zle -N vwz_ranger
zle -N vwz_ranger!

bindkey -s '\ez' "\eq vwz_ranger!\n"
