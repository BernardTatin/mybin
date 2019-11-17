#!/bin/sh

# tools for install.sh and uninstall.sh

init_install() {
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
            [ -z "$PREFIX" ] && PREFIX=/usr/local
            set -u
            ;;
    esac
    case ${_os} in
        SunOS|NetBSD)
            with_pbook=0
            ;;
        *)
            with_pbook=1
            ;;
    esac
}
