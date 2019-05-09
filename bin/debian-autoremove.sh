#!/bin/sh

cd /etc \
  && apt-get autoremove -y \
  && git-commit-and-push.sh "autoremove"
