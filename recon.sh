#!/usr/bin/env bash

echo "
                                _     
 _ __ ___  ___ ___  _ __    ___| |__  
| '__/ _ \/ __/ _ \| '_ \  / __| '_ \ 
| | |  __/ (_| (_) | | | |_\__ \ | | |
|_|  \___|\___\___/|_| |_(_)___/_| |_|"

if [ -z "$1" ]
then
    printf "\nUsage: ./recon.sh [option] <IP>\n"
    exit 1
fi

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap..."
if ! nmap $1 $2 | tail -n +5 | head -n -3 >> results &>/dev/null
then
    echo "Installing Nmap..."
    sudo apt-get install -y nmap && nmap $1 $2 | tail -n +5 | head -n -3 >> results
fi

while read line
do
    if [[ $line == *open* ]] && [[ $line == *http* ]]
    then
    echo "Running WhatWeb..."
    if ! whatweb $2 -v > temp &>/dev/null
    then
        echo "Installing WhatWeb..."
        sudo apt-get install -y whatweb && whatweb $2 -v > temp
    fi
done < results

if [ -e temp ]
then
    printf "\n----- WEB -----\n\n" >> results
    cat temp >> results
    rm temp
fi

cat results