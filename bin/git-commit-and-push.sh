#!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh


# ----------------------------------------------------------------------
# variables
retcode=${retcode:-$FAILURE}

# ----------------------------------------------------------------------
trap_exit() {
  echo "trap_exit ${retcode}"
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
# ----------------------------------------------------------------------
get_help_text() {
    cat <<DOHELP
$script [-h|--help] : this text
$script message : git add --all && git commit -m message && git push
DOHELP
}

[ $# -eq 0 ] && dohelp
case $1 in
    -h|--help)
        dohelp
        ;;
esac

git add --all || onerror $FAILURE "git add --all failure"
git commit -m "$@" || onerror $FAILURE "git commit failure"
git push || onerror "git push failure"

retcode=$SUCCESS
