#!/usr/bin/env dash

cd /etc \
  && apt-get update\
  && apt-get upgrade -y \
  && git-commit-and-push.sh "update/upgrade"
