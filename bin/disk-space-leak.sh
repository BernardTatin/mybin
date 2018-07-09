#!/usr/bin/env bash

# manage node manager from systemd

# set -x
# it is an error to read an uninitialized variable
set -o nounset
# Causes a pipeline to return the exit status of the last command
# in the pipe that returned a non-zero return value.
# set -o pipefail
## where is this script
here=$(dirname $0)
## the name of the script
script=$(basename $0)

args=

case $# in
   0)
      du -sm *
      ;;
   1)
      du -sm $1/*
      ;;
   *)
      du -sm "$@"
      ;;
esac | sort -nr | head -3
