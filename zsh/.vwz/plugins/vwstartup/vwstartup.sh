#

###

VWSTARTUP_ROOT="$(builtin cd "$(dirname "${BASH_SOURCE:-${(%):-%x}}")" && builtin pwd)"
export VWSTARTUP_ROOT
source $VWSTARTUP_ROOT/vwstartup_terminal.sh
