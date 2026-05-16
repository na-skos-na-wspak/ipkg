#!/usr/bin/env sh

cmd_install() {
	if ! [ -d "$(dirname "$0")/package/$2" ]; then
		printf "No package found"
		exit 1
	fi


	if [[ $1 != '' ]]; then
		printf "Package '$2' at $(dirname "$0")/package/$2/"
	else
		printf "No package specified"
		exit 1
	fi
}

cmd_remove() {
	if [[ $is_local == 'y' ]]; then
		printf "Local remover"
	else
		printf "Remover"
	fi
}

cmd_info() {
	if ! [ -d "$(dirname "$0")/package/$1" ]; then
		printf "No package found"
		exit 1
	fi


	if [[ $1 != '' ]]; then
		grep 'NAME=' $(dirname "$0")/package/$1/info | cut -d= -f2
		printf "\n"
		grep 'DESCRIPTION=' $(dirname "$0")/package/$1/info | cut -d= -f2
		printf "
Depends on: $(grep 'DEPS=' $(dirname "$0")/package/$1/info | cut -d= -f2)
"
	else
		printf "No package specified"
		exit 1
	fi
}

cmd_update() {
	if [[ $is_local == 'y' ]]; then
		printf "Local updater"
	else
		printf "updater"
	fi
}

cmd_upgrade() {
	if [[ $is_local == 'y' ]]; then
		printf "Local upgrader"
	else
		printf "Upgrader"
	fi
}

cmd_bootstrap() {
	if [[ $is_local == 'y' ]]; then
		printf "Local bootstrap"
	else
		printf "Bootstrap"
	fi
}

cmd_help() {
	y='\e[0;33m'
	nc='\e[0m'
	bo='\e[1m'
	if [[ $1 == '' ]]; then
		exec printf "$y$bo\aI$nc$y\achii$nc $bo\aP$nc\aac$bo\ak$nc\aa$bo\ag$nc\ae Manager
A source based package manager and bootstrapper for use on $y\aIchii$nc Linux.\n
usage: ipkg <op> [package(s)]\n
Operations:
    $bo\ainstall$nc   -  Installs a package
    $bo\aremove$nc    -  Removes a package
    $bo\ainfo$nc      -  Prints info about a package
    $bo\aupdate$nc    -  Checks installed packages for updates
    $bo\aupgrade$nc   -  Updates ipkg's repositories
    $bo\abootstrap$nc -  Bootstraps Ichii Linux
    $bo\ahelp$nc      -  Shows this help menu
"
	fi

	if [[ $1 == 'help' ]]; then
		exec man ipkg
	fi
}

if [[ $1 = '' ]]; then
	cmd_help
	exit 1
fi

command_check() {
	cmds_root=(install remove update upgrade bootstrap)
	cmds=(info help)
	
	if [[ ${cmds[*]} =~ $1 ]] ; then
		cmd_$1 $2
		exit 0
	fi

	if [[ ${cmds_root[*]} =~ $1 ]] ; then
		if [[ $(whoami) != 'root' ]]; then
			while [[ $is_local != 'y' ]]; do

				if [[ $is_local == '' ]]; then
					read -rp "You are not root, would you like to go to local mode? [y/N] " is_local

					if [[ $is_local == '' ]]; then
						is_local='n'
					fi

				else read -rp "Baka! I don't understand '$is_local', give a real option! [y/N] " is_local

				if [[ $is_local == '' ]]; then
					is_local='n'
				fi

				fi

				if [[ $is_local == 'n' ]]; then
					exit 1
				fi
			done
		fi
		cmd_$1 "$@"
	else
		cmd_help
		exit 1
	fi

}

command_check "$@"
