#

###

VWRUNCOM_ROOT="$(builtin cd "$(dirname "${BASH_SOURCE:-${(%):-%x}}")" && builtin pwd)"
export VWRUNCOM_ROOT
source $VWRUNCOM_ROOT/vwruncom_ctl.sh

### alias
alias rc="vwruncom"
alias rcq="customize_quit"
