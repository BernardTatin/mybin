#!/bin/sh 

PREFIX=/usr/local 

echo "Désinstallation des scripts indispensables..."

for f in ./bin/* 
do 
  echo "Désinstallation de $(basename $f)"
  rm -fv ${PREFIX}/bin/$(basename $f)
done 


