#!/bin/sh
# This file must be included by a sh script

script=$(basename $0)
current_user=$USER

SUCCESS=0
FAILURE=1

standardize_dir() {
	(cd $1 && pwd)
}

here=$(standardize_dir $(dirname $0))

show_error() {
	echo "[ERROR] $*" >&2
	echo >&2
}
# onerror exit_code message ...
onerror() {
    exit_code=$1
    shift

    show_error "$*" 1>&2
    exit $exit_code
}


ensureroot() {
	echo "EUID : $EUID, UID : $UID"
	[ $EUID -ne 0 ] && onerror "you must be root"
}

# safe_source file file ...
safe_source() {
    file=
    while [ $# -gt 0 ]
    do
        file=$1
        if [ -f ${file} ]
        then
            . ${file}
        else
            onerror 1 "Cannot source ${file}"
        fi
        shift
    done
}

get_tmp_file() {
    root_name='another-tmp-file'
    [ $# -gt 0 ] && \
        root_name=$1
    mktemp /tmp/${root_name}.XXXXXX
}
