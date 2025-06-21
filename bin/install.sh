
#!/bin/bash

cd "$HOME" || exit

mkdir temp_____

cd temp_____ || exit
rm -rf francinette

# download github
git clone --recursive https://github.com/thecloudrazor/francinette.git

read -p "Are you logged in on one of 42 Istanbul campus computers? (y/n): " answer

if [ "$answer" == "n" ]; then
	if [ "$(uname)" != "Darwin" ]; then
	echo "Admin permissions needed to install C compilers, python, and upgrade current packages"
	case $(lsb_release -is) in
		"Ubuntu")
			sudo apt update
			sudo apt upgrade
			sudo apt install gcc clang libpq-dev libbsd-dev libncurses-dev valgrind -y
			sudo apt install python-dev python3-pip -y
			sudo apt install python3-dev python3-venv python3-wheel -y
			pip3 install wheel
			;;
		"Arch")
			sudo pacman -Syu
			sudo pacman -S gcc clang postgresql libbsd ncurses valgrind --noconfirm
			sudo pacman -S python-pip --noconfirm
			pip3 install wheel
			;;
		"Fedora")
			sudo dnf group install "development-tools" -y
			sudo dnf install gcc clang *libbsd* *valgrind* libyui-ncurses-* gcc-c++ ncurses* pip pipx git wget curl libxkbcommon-devel libxkbcommon-utils libxkbcommon-x11-devel libxkbcommon-x11-utils libxkbfile-devel python3-xkbcommon python3-xkbregistry xkb-switch xkbcomp-devel xkbset *libXi-devel* mesa-libGLU mesa-libGLU-devel xcb-* libXcursor-devel xcb-util-cursor-devel libxcb-devel -y
   			pip3 install wheel
			;;
		"NobaraLinux")
			sudo dnf group install "development-tools" -y
			sudo dnf install gcc clang *libbsd* *valgrind* libyui-ncurses-* gcc-c++ ncurses* pip pipx git wget curl libxkbcommon-devel libxkbcommon-utils libxkbcommon-x11-devel libxkbcommon-x11-utils libxkbfile-devel python3-xkbcommon python3-xkbregistry xkb-switch xkbcomp-devel xkbset *libXi-devel* mesa-libGLU mesa-libGLU-devel xcb-* libXcursor-devel xcb-util-cursor-devel libxcb-devel -y
			pip3 install wheel
			;;
	esac
	fi
else
	echo "OK, welcome. Continuing..."
fi

cp -r francinette "$HOME"

cd "$HOME" || exit
rm -rf temp_____

cd "$HOME"/francinette || exit

# start a venv inside francinette (without pip)
if ! python3 -m venv venv --without-pip ; then
    echo "Please make sure that you can create a python virtual environment"
    echo 'Contact me if you have no idea how to proceed (thecloudrazor- on slack)'
    exit 1
fi

# activate venv
. venv/bin/activate

# manually install pip
if [ "$answer" == "y" ]; then
	echo "Bootstrapping pip manually..."
	curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	if ! python get-pip.py; then
  		echo "Manual pip installation failed. Contact me if you have no idea how to proceed (thecloudrazor- on Slack)"
  		exit 1
	fi
	rm get-pip.py
fi

# install requirements
if ! pip3 install -r requirements.txt ; then
echo 'Problem launching the installer. Contact me (thecloudrazor- on slack)'
exit 1
fi

RC_FILE="$HOME/.zshrc"

if [ "$(uname)" != "Darwin" ]; then
RC_FILE="$HOME/.bashrc"
if [[ -f "$HOME/.zshrc" ]]; then
RC_FILE="$HOME/.zshrc"
fi
fi

echo "try to add alias in file: $RC_FILE"

# set up the alias
if ! grep "francinette=" "$RC_FILE" &> /dev/null; then
echo "francinette alias not present"
printf "\nalias francinette=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

if ! grep "paco=" "$RC_FILE" &> /dev/null; then
echo "Short alias not present. Adding it"
printf "\nalias paco=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

# print help
"$HOME"/francinette/tester.sh --help

# automatically replace current shell with new one.
exec "$SHELL"

printf "\033[33m... and don't forget, \033[1;37mpaco\033[0;33m is not a replacement for your own tests! \033[0m\n"
