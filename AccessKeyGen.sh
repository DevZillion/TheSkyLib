#!/bin/bash

function MainName {
    clear
    python --version >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        CheckPython
        exit 1
    fi
    mkdir -p output/KeyAGen
    echo "~~> Write the name you want for your .keys file:"
    read name
    if [ -z "$name" ]; then
        CheckName
        MainName
    else
        MainUID
    fi
}

function MainUID {
    clear
    echo "~~> Write your tag's UID:"
    read uid
    if [ -z "$uid" ] || [ ${#uid} -lt 8 ]; then
        CheckUID
        MainUID
    else
        MainGetKeys
    fi
}

function MainGetKeys {
    echo ""
    python libs/sklykeys.py -u $uid > output/KeyAGen/${name}.${uid}.keys
    clear
    echo ""
    python libs/sklykeys.py -u $uid
    echo ""
    read -p "Press any key to continue..." -n1 -s
}

function CheckName {
    echo ""
    echo "ERROR - The name can't be empty."
    read -p "Press any key to continue..." -n1 -s
}

function CheckUID {
    echo ""
    echo "ERROR - Your UID can't be less than 8 Characters"
    read -p "Press any key to continue..." -n1 -s
}

function CheckPython {
    tput setaf 1
    echo "\e[101m ERROR - Python not installed. \e[0m"
    tput sgr0
    xdg-open "https://www.python.org/downloads/"
    read -p "Press any key to continue..." -n1 -s
}

MainName
