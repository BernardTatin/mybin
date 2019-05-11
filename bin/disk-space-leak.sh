#!/usr/bin/env dash

# show the first 3 directories/files which
# occupie the most disk space
# usage:
#

# ----------------------------------------------------------------------
set -e
set -u

. $(dirname $0)/base.inc.sh
safe_source ${here}/standard-traps.inc.sh

# the du command with parameters:
# -s : summarize each elements
# -m : values in megabytes
_du="du -sm"

get_help_text() {
   cat <<HELP
$script -h|--help: this text
$script: as $script *
$script dir dir ...: show the 3 biggest directories/files
HELP
}

[ $# -gt 0 ] \
   && case $1 in
        -h|--help)
          dohelp
          ;;
        *)
          ;;
      esac

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
