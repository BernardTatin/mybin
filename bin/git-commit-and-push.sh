#!/bin/sh

script=$(basename $0)

dohelp() {
    exit_code=0
    [ 1 -ne 0 ] && exit_code=$1

    cat <<DOHELP
$script [-h|--help] : this text
$script message : git add --all && git commit -m message && git push
DOHELP
    exit $exit_code
}

[ $# -eq 0 ] && dohelp
case $1 in
    -h|--help)
        dohelp
        ;;
esac

git add --all \
    && git commit -m "$@" \
    && git push
       
