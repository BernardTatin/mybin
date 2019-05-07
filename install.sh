#!/bin/sh

PREFIX=/usr/local
here=$(pwd)

echo "Installation des scripts indispensables dans ${PREFIX}..."

for f in ${here}/bin/*
do
  echo "Installation de $f ..."
  cp -v $f ${PREFIX}/bin
done

cp -Rva ${here}/pbook ${PREFIX}
