#!/usr/bin/env dash

#!/bin/sh

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
# gnu:  -BM : values in megabytes
# bsd:  -m  : values in megabytes
number_of_dirs=3
case ${_os} in
    SunOS|NetBSD)
        unit=m
        ;;
    *)
        unit=M
        ;;
esac

get_help_text() {
   cat <<HELP
$script -h|--help: this text
$script [OPTIONS] [dir [dir ...]]: show the 3 biggest directories/files
  dir: optional list of directories, default='*'
OPTIONS:
  -N|--number-of-dirs n: number of directories to show, default=3
  -u|--unit u: unit of measurement, default=M (megabytes)
      can be K or G but see man du (SunOS uses m or k)
HELP
}

continue_loop=1
[ $# -gt 0 ] \
   && \
   while [ $continue_loop -ne 0 ]
   do
     case $1 in
          -h|--help)
            dohelp
            ;;
          -u|--unit)
            shift
            [ $# -eq 0 ] && dohelp $FAILURE "$1 needs a unit"
            unit=$1
            shift
            ;;
          -N|--number-of-dirs)
            shift
            [ $# -eq 0 ] && dohelp $FAILURE "$1 needs e number..."
            number_of_dirs=$1
            shift
            ;;
          *)
            continue_loop=0
            ;;
      esac
    done

case ${_os} in
    SunOS|NetBSD)
        _du="/usr/bin/du -s -${unit}"
        ;;
    *)
        _du="du -s -B${unit}"
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
esac | sort -nr | head -${number_of_dirs}

retcode=$SUCCESS
