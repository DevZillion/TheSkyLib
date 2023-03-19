#!/bin/bash

clear
echo -e "\e[0m"
rm -rf "dumps/blank_tags/Put the dump of the tags you want to write here" > /dev/null 2>&1
rm -rf "dumps/skylanders/Put the dump of the skylanders you want to write here" > /dev/null 2>&1
rm -rf workplace > /dev/null 2>&1
if ! command -v python &> /dev/null; then
    echo -e "\e[101m ERROR - Python not installed. \e[0m"
    exit
fi

mkdir -p output/Dump2LockedTag > /dev/null 2>&1
function get_sky_dump {
    clear
    cat logo
    echo "File List:"
    ls -1 "dumps/skylanders"
    read -p "> [With extensions] Write the name of your SKYLANDER .dump/.dmp/.sky/.bin file: " skyfile
    get_desired_name
}

function get_blank_dump {
    clear
    cat logo
    echo "File List:"
    ls -1 "dumps/blank_tags"
    read -p "> [With extensions] Write the name of your BLANK TAG .dump/.dmp/.sky/.bin file: " btagfile
    get_sky_dump
}

function get_desired_name {
    clear
    cat logo
    read -p "~~> [Without extensions] Write the name desired for your output .dump file: " outputfilename
    gen_workplace
}

function gen_workplace {
    mkdir -p workplace
    echo "Getting Things Ready, Wait a moment."
    cp -R "libs/tnp3xxx.py" "workplace"
    cp -R "libs/sklykeys.py" "workplace"
    cp -R "libs/UID.py" "workplace"
    cp -R "dumps/skylanders/$skyfile" "workplace"
    cp -R "dumps/blank_tags/$btagfile" "workplace"
    sleep 5
    main_gen
}

function main_gen {
    clear
    cat logo
    python "workplace/UID.py" --blank "workplace/$btagfile" --sky "workplace/$skyfile" --name "$outputfilename"
    echo ""
    rm -rf workplace
    cp "$outputfilename.dump" "output/Dump2LockedTag"
    sleep 4
    rm -f "$outputfilename.dump"
    exit
}

get_blank_dump