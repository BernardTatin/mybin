#!/bin/sh
# This file must be included by a sh script
# be careful: 'local' variables are not so local!

readonly script=$(basename $0)
readonly current_user=$USER

readonly SUCCESS=0
readonly FAILURE=1

readonly debug=${debug:-0}

# variables
retcode=$FAILURE

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
		retcode=$1
    shift

    show_error "$*" 1>&2
    exit $retcode
}


ensureroot() {
	echo "EUID : $EUID, UID : $UID"
	[ $EUID -ne 0 ] && onerror $FAILURE "you must be root"
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
            onerror $FAILURE "Cannot source ${file}"
        fi
        shift
    done
}

get_tmp_file() {
    root_name='another-tmp-file'
    [ $# -gt 0 ] && \
        root_name=$1
    mktemp /tmp/${root_name}.XXXXXX \
			|| onerror $FAILURE "Cannot create temp file with base '$root_name'"
}

dohelp() {
    case "$#" in
        '0')
            retcode=$SUCCESS
            ;;
        '1')
            retcode=$1
            ;;
        *)
            retcode=$1
            shift
            show_error "$*"
            ;;
    esac
    get_help_text

    exit ${retcode}
}
