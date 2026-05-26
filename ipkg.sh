#!/usr/bin/env sh

cmd_install() {
	if ! [ -d "$(dirname "$0")/package/$2" ]; then
		printf "No package found"
		exit 1
	fi


	if [[ $1 != '' ]]; then
		printf "Package '$2' at $(dirname "$0")/package/$2/\n"
		while [[ $selection != 'y' ]]; do

				if [[ $selection == '' ]]; then
					read -rp "Proceed with installation? [y/N] " selection

					if [[ $selection == '' ]]; then
						selection='n'
					fi

				else read -rp "Baka! I don't understand '$selection', give a real option! [y/N] " selection

				if [[ $selection == '' ]]; then
					selection='n'
				fi

				fi

				if [[ $selection == 'n' ]]; then
					exit 1
				fi
			done
			$(dirname "$0")/package/$2/make configure $is_local
			$(dirname "$0")/package/$2/make build
	else
		printf "No package specified\n"
		exit 1
	fi
}

cmd_remove() {
	if ! [ -d "$(dirname "$0")/package/$2" ]; then
		printf "No package found"
		exit 1
	fi

	if [[ $(grep $2 $(dirname "$0")/package/installed) == '' ]]; then
		printf "Package $2 is not installed\n"
		exit 1
	fi

	if [[ $1 != '' ]]; then
		printf "Package '$2' at $(dirname "$0")/package/$2/\n"
		while [[ $selection != 'y' ]]; do

				if [[ $selection == '' ]]; then
					read -rp "Proceed with uninstall? [y/N] " selection

					if [[ $selection == '' ]]; then
						selection='n'
					fi

				else read -rp "Baka! I don't understand '$selection', give a real option! [y/N] " selection

				if [[ $selection == '' ]]; then
					selection='n'
				fi

				fi

				if [[ $selection == 'n' ]]; then
					exit 1
				fi
			done
			$(dirname "$0")/package/$2/make uninstall
	else
		printf "No package specified\n"
		exit 1
	fi
}

cmd_info() {
	if ! [ -d "$(dirname "$0")/package/$1" ]; then
		printf "No package found\n"
		exit 1
	fi


	if [[ $1 != '' ]]; then
		grep 'NAME=' $(dirname "$0")/package/$1/info | cut -d= -f2
		printf "\n"
		grep 'DESCRIPTION=' $(dirname "$0")/package/$1/info | cut -d= -f2
		printf "\nDepends on: $(grep 'DEPS=' $(dirname "$0")/package/$1/info | cut -d= -f2)\n"
	else
		printf "No package specified\n"
		exit 1
	fi
}

cmd_search() {
	if [[ $1 != '' ]]; then
		packages_found=$(find $(dirname "$0")/package -name *$1* | cut -d/ -f3)
		if [[ $packages_found == '' ]]; then
			printf "No packages found\n"
			exit 1
		fi
		printf "$packages_found\n"
	else
		printf "No package specified\n"
		exit 1
	fi
}

cmd_update() {
	if [[ $is_local == 'y' ]]; then
		printf "Local updater\n"
	else
		printf "updater\n"
	fi
}

cmd_upgrade() {
	if [[ $is_local == 'y' ]]; then
		printf "Local upgrader\n"
	else
		printf "Upgrader\n"
	fi
}

cmd_bootstrap() {
	if [[ $is_local == 'y' ]]; then
		printf "Local bootstrap\n"
	else
		printf "Bootstrap\n"
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
    $bo\aserach$nc    -  Searches the repository for a package
    $bo\aupdate$nc    -  Checks installed packages for updates
    $bo\aupgrade$nc   -  Updates ipkg's repositories
    $bo\abootstrap$nc -  Bootstraps Ichii Linux
    $bo\ahelp$nc      -  Shows this help menu\n"
	fi

	if [[ $1 == 'install' ]]; then
		exec printf "Installs a package.
usage: ipkg install [package(s)]\n"
	fi

	if [[ $1 == 'remove' ]]; then
		exec printf "Removes a package.
usage: ipkg remove [package(s)]\n"
	fi

	if [[ $1 == 'info' ]]; then
		exec printf "Gives info about a package.
usage: ipkg info [package]
(Ignores any other package after the first)\n"
	fi

	if [[ $1 == 'search' ]]; then
		exec printf "Searches the repository for a package.
usage: ipkg search [package]
(Ignores any other package after the first)\n"
	fi


	if [[ $1 == 'update' ]]; then
		exec printf "Updates a package.
usage: ipkg update [package(s)]
To update all packages: ipkg update all\n"
	fi

	if [[ $1 == 'upgrade' ]]; then
		exec printf "Upgrades the repository.
usage: ipkg upgrade
(This takes no args)\n"
	fi

	if [[ $1 == 'bootstrap' ]]; then
		exec printf "WIP!\n"
	fi

	if [[ $1 == 'help' ]]; then
		exec man ipkg
	fi

	printf "What?\n"
}

if [[ $1 = '' ]]; then
	cmd_help
	exit 1
fi

command_check() {
	cmds_root=(install remove update upgrade bootstrap)
	cmds=(info search help)
	
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
