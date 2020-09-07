#!/bin/bash

echo "Config Generator for Recovery builder"
if [[ $(ls | grep CONFIG) ]]; then
    echo "Old / Unused config detected."
    read -p "Delete? (Y/N)" delconfig
    if [[ ($delconfig = Y) ]]; then
        rm CONFIG
    else
        echo "Config not deleted."
        echo "If this is done on purpose, it's good"
        echo "If it isn't, it might create chaos in the near future."
    fi
else
    echo "" >> /dev/null
fi

touch CONFIG

read -p "Recovery Tree link :" rtl
read -p "Recovery Tree path :" rtp
echo "git clone $rtl $rtp" >> CONFIG
read -p "Does your recovery tree require a external kernel tree (not prebuilt)? (Y/N)" kte
if [[ ($kte = Y) ]]; then
    read -p "Kernel tree link :" ktl 
    read -p "Kernel tree path :" ktp
    echo "git clone --depth=1 --single-branch $ktl $ktp" >> CONFIG
else
    echo "Ok !"
fi

echo "Configuration done."
echo "You are ready to build !"
