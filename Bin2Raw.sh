#!/bin/bash

clear
python --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "ERROR - Python not installed."
  xdg-open "https://www.python.org/downloads/" &> /dev/null
  read -p "Press [Enter] key to continue..."
  exit 1
fi

rm -rf "dumps/blank_tags/Put the dump of the tags you want to write here" &> /dev/null
rm -rf "dumps/skylanders/Put the dump of the skylanders you want to write here" &> /dev/null
mkdir -p "output/Bin2Raw"

echo "Skylanders Bin2Raw"
read -p "~~> Write the name you want for your .raw file: " name

if [ -z "$name" ]; then
  echo "ERROR - The name can't be empty."
  read -p "Press [Enter] key to continue..."
  exit 1
fi

clear
echo "Skylanders Key Calculator"
echo "File List:"
ls "dumps/skylanders"

read -p "~~> [With extensions] Write the name of your SKYLANDER file: " file

clear
python libs/sklykeys.py -f "dumps/skylanders/$file" > "output/Bin2Raw/$name.raw.dump"
echo
echo "Skylander file: $file"
python libs/sklykeys.py -f "dumps/skylanders/$file"
echo
read -p "Press [Enter] key to continue..."
