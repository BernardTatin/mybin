#!/bin/sh 

PREFIX=/usr/local 
HERE=$(pwd)

echo "Installation des scripts indispensables..."

for f in ${HERE}/bin/*
do 
  echo "Installation de $f"
  ln -s $f ${PREFIX}/bin 
done 

