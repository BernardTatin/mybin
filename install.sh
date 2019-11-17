#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/bin/base.inc.sh
safe_source ${here}/bin/standard-traps.inc.sh ${here}/install.inc.sh

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

init_install

! [ -d "$PREFIX" ] \
	&& onerror $FAILURE "$PREFIX n'est pas un répertoire ou n'existe pas"
mkdir -p $PREFIX/bin
echo "Installation des scripts indispensables dans ${PREFIX}..."

for f in ${here}/bin/*
do
  echo "Installation de $f ..."
  chmod +x $f
  cp ${CP_OPT} $f ${PREFIX}/bin
done

! [ ${with_pbook} -eq 0 ] && cp ${CP_ROPT} ${here}/pbook ${PREFIX}

retcode=$SUCCESS
