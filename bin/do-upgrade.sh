#!/usr/bin/env dash

os=$(uname)
case ${os} in
    Linux)
        pkg_command=apt-get
        ;;
    NetBSD)
        pkg_command=pkgin
        ;;
    *)
        echo "Unknown OS (${os})"
        exit 1
        ;;
esac
cd /etc \
    && echo "Updating..." \
  && ${pkg_command} update \
    && echo "Upgrading..." \
  && ${pkg_command} upgrade -y \
  && [ -d .git ] \
  && git-commit-and-push.sh "update/upgrade"

