#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo '' &>/dev/null;
elif [[ "$OSTYPE" == "darwin"* ]]; then
	SUBL="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl";
elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo '' &>/dev/null;
elif [[ "$OSTYPE" == "win32" ]]; then
    echo '' &>/dev/null;
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo '' &>/dev/null;
else
    echo '' &>/dev/null;
fi;

cd "$(dirname "${BASH_SOURCE}")";
git pull origin master;

function doItCygwin() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" \
		--exclude ".osx" --exclude "Brewfile" --exclude "Caskfile" -avh --no-perms . ~;
	source ~/.bash_profile;
	echo "ca_directory = /usr/ssl/certs # Cygwin CA Certs directory is non standard" >> ~/.wgetrc;
}

function doItMac() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" \
		--exclude ".minttyrc" -avh --no-perms . ~;
	source ~/.bash_profile;
}

function doIt() {
	# OS specific
	if [[ "$OSTYPE" == "darwin"* ]]; then
		doItMac;
	elif [[ "$OSTYPE" == "cygwin" ]]; then
		doItCygwin;
	else
		rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
			--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
		source ~/.bash_profile;
	fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
