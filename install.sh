#!/bin/sh 

PREFIX=/usr/local 
HERE=$(pwd)

echo "Installation des scripts indispensables dans ${PREFIX}..."

for f in ${HERE}/bin/*
do 
  echo "Installation de $f ..."
  cp -v $f ${PREFIX}/bin 
done 

