#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh
safe_source ${here}/standard-traps.inc.sh
# ----------------------------------------------------------------------
get_help_text() {
    cat <<DOHELP
$script [-h|--help]: this text
$script command-line: run command line in background without attached terminal.
DOHELP
}

case $# in
  0)
    dohelp
    ;;
  1)
    case $1 in
           -h|--help)
               dohelp
               ;;
      esac
      ;;
esac

echo "Run $* in background..."
nohup "$@" >/dev/null 2>/dev/null &
