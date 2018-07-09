#!/usr/bin/env bash

# show the first 3 directories/files which
# occupie the most disk space
# usage:
#

# set -x
# it is an error to read an uninitialized variable
set -o nounset
# Causes a pipeline to return the exit status of the last command
# in the pipe that returned a non-zero return value.
# set -o pipefail
## the name of the script
script=$(basename $0)

# the du command with parameters:
# -s : summarize each elements
# -m : values in megabytes
_du="du -sm"

function dohelp() {
   cat <<HELP
$script --help: this text
$script: as $script *
$script dir dir ...: show the 3 biggest directories/files
HELP
   exit
}

[[ $# -gt 0 ]] \
   && [[ $1 = "--help" ]] \
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
