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

_os=$(uname)
case ${_os} in
    SunOS)
        CP_OPT=-p
        CP_ROPT=-Rp
set +u
        [ -z "$PREFIX" ] && PREFIX=${HOME}
set -u
        ;;
    *)
        CP_OPT=-va
        CP_ROPT=-Rva
set +u
        [ -z "$PREFIX" ] && PREFIX=/usr/local}
set -u
        ;;
esac


echo "Installation des scripts indispensables dans ${PREFIX}..."

for f in ${here}/bin/*
do
  echo "Installation de $f ..."
  cp ${CP_OPT} $f ${PREFIX}/bin
done

! [ ${_os} = 'SunOS' ] && cp ${CP_ROPT} ${here}/pbook ${PREFIX}

retcode=$SUCCESS
