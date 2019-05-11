#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/bin/base.inc.sh
safe_source ${here}/bin/standard-traps.inc.sh

# ----------------------------------------------------------------------
get_help_text() {
    cat <<DOHELP
$script [-h|--help] : this text
$script install all files you can find in $(pwd)/bin
  The PREFIX variable is where installed files must be.
  you can run:
PREFIX=/where/files/are $script
DOHELP
}

[ $# -gt 0 ] \
  && case $1 in
          -h|--help)
              dohelp
              ;;
     esac
# ----------------------------------------------------------------------

PREFIX=/usr/local

echo "Installation des scripts indispensables dans ${PREFIX}..."

for f in ${here}/bin/*
do
  echo "Installation de $f ..."
  cp -va $f ${PREFIX}/bin
done

cp -Rva ${here}/pbook ${PREFIX}

retcode=$SUCCESS
