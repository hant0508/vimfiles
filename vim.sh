#!/bin/bash

read -p "Configure vim? (y/n): " -r
if [[ $REPLY =~ ^[NnНн]$ ]]
then
	exit
fi

echo "Copying files..."
cp -r .vim ~/
cp -r .vimrc ~/
cp -r .fonts ~/
mkdir ~/.vim/undo
echo "Installing fonts..."
fc-cache -f
echo "Done!"
vim 1.cpp
read -p "Remove this folder? (y/n): " -r
if [[ $REPLY =~ ^[YyДд]$ ]]
then
	rm -rf `pwd`
fi
