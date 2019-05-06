#!/bin/sh
# ce fichier doit être inclu par un script shell

script=$(basename $0)
current_user=$USER

SUCCESS=0
FAILURE=1

show_error() {
	echo "[ERROR] $*" >&2
    echo >&2
}
onerror() {
    show_error "$@"
	echo "try '$script --help'"
	exit ${FAILURE}
}

ensureroot() {
	echo "EUID : $EUID, UID : $UID"
	[ $EUID -ne 0 ] && onerror "you must be root"
}

standardize_dir() {
    (cd $1 && pwd)
}

here=$(standardize_dir $(dirname $0))
