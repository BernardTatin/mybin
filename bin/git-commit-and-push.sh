#!/bin/sh

# #!/usr/bin/env dash

# ----------------------------------------------------------------------
set -e
set -u

# ----------------------------------------------------------------------
. $(dirname $0)/base.inc.sh
safe_source ${here}/standard-traps.inc.sh

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

if [ -z "$(git status --porcelain)" ]
then
  echo "Nothing to commit and push"
else
  git add --all || onerror $FAILURE "git add --all failure"
  git commit -m "$@" || onerror $FAILURE "git commit failure"
  git push || onerror "git push failure"
fi

retcode=$SUCCESS
