#!/usr/bin/env sh

cmd_install() {
	if [[ $is_local == 'y' ]]; then
		printf "Local installer"
	else
		printf "Installer"
	fi
}

cmd_remove() {
	if [[ $is_local == 'y' ]]; then
		printf "Local remover"
	else
		printf "Remover"
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
		exec printf "$y\aIchii$nc Linux Package Manager
A source based package manager and bootstrapper for use on $y\aIchii$nc Linux.\n
    $bo\ainstall$nc   -  Installs a package
    $bo\aremove$nc    -  Removes a package
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
	cmds=(install remove update upgrade bootstrap help)
	
	if [[ $1 == 'help' ]]; then
		cmd_help $2
		exit 0
	fi

	if [[ ${cmds[*]} =~ $1 ]] ; then
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
		cmd_$1
	else
		cmd_help
		exit 1
	fi

}

command_check $1 $2 $is_local
