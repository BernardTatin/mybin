#!/bin/sh

# ----------------------------------------------------------------------
set -e
set -u
# set -x
# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh
safe_source ${here}/standard-traps.inc.sh
# ----------------------------------------------------------------------
while true
do
  OLDIFS="${IFS}"
  memfree=$(egrep "^MemFree" /proc/meminfo | tr -s ' ' | cut -d ' ' -f2)
  IFS=" \n"
  read cpul1 cpul2 cpul3 str < /proc/loadavg
  IFS="$OLDIFS"
  now="$(date '+%Y%m%d-%H%M%S')"
  printf "%s | %7s | %7s | %7s | %9s\n" ${now} ${cpul1} ${cpul2} ${cpul3} ${memfree}
  # | hexdump -C
  sleep 1
done
