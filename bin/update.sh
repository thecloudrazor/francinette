#!/bin/bash

read -p "Are you logged in on one of 42 Istanbul campus computers? (y/n): " answer

if [ "$answer" == "n" ]; then
	if [ "$(uname)" != "Darwin" ]; then
		echo "Admin permissions need to install newer packages"
		sudo apt install libbsd-dev libncurses-dev
	fi
fi

cd "$HOME"/francinette || exit

git fetch origin
git reset --hard origin
git submodule update --init

# activate venv
. venv/bin/activate

echo "Updating Python dependencies..."
# install requirements
if ! pip3 install --disable-pip-version-check -r requirements.txt ; then
	echo "Problem updating francinette. Contact me (thecloudrazor- on slack)"
	exit 1
fi

echo -e "\033[1;37mFrancinette is updated. You can use it again!\033[0m"

printf "\033[33m... but don't forget, \033[1;37mpaco\033[0;33m is not a replacement for your own tests! \033[0m\n"
