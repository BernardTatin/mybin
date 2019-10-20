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
$script uninstall all files you can find in $(pwd)/bin
  The PREFIX variable is where installed files are.
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
        set +u
        [ -z "$PREFIX" ] && PREFIX=${HOME}
        set -u
        ;;
    *)
        set +u
        [ -z "$PREFIX" ] && PREFIX=/usr/local}
        set -u
        ;;
esac

echo "Désinstallation des scripts indispensables..."

for f in ./bin/*
do
  echo "Désinstallation de $(basename $f)"
  rm -fv ${PREFIX}/bin/$(basename $f)
done

echo "Désinstallation de pbook"
rm -Rfv ${PREFIX}/pbook

retcode=$SUCCESS
