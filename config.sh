#!/bin/bash

if [[ $(ls | grep CONFIG) ]]; then
    rm -rf CONFIG
else
    echo "" >> /dev/null
fi

touch CONFIG

echo "git clone $2 $3" >> CONFIG
    
