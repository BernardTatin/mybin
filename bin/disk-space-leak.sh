#!/usr/bin/env dash

# show the first 3 directories/files which
# occupie the most disk space
# usage:
#

# ----------------------------------------------------------------------
set -e
set -u

. $(dirname $0)/base.inc.sh

# variables
retcode=${retcode:-$FAILURE}

# ----------------------------------------------------------------------
trap_exit() {
  # echo "trap_exit ${retcode}"
  exit ${retcode}
}
trap_error() {
  retcode=${FAILURE}
  echo "trap_error ${retcode}"
}
trap_force_quit() {
  retcode=${FAILURE}
  echo "trap_force_quit ${retcode}"
}
# ----------------------------------------------------------------------
# trap trap_force_quit *
trap trap_force_quit TERM TSTP INT QUIT
trap trap_error HUP ILL ABRT FPE SEGV PIPE
trap trap_exit EXIT

# the du command with parameters:
# -s : summarize each elements
# -m : values in megabytes
_du="du -sm"

get_help_text() {
   cat <<HELP
$script --help: this text
$script: as $script *
$script dir dir ...: show the 3 biggest directories/files
HELP
}

[ $# -gt 0 ] \
   && [ $1 = "--help" ] \
   && dohelp

case $# in
   0)
      ${_du} ./*
      ;;
   1)
      ${_du} $1/*
      ;;
   *)
      ${_du} "$@"
      ;;
esac | sort -nr | head -3

retcode=$SUCCESS
