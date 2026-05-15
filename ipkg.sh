#!/usr/bin/env sh

check_root() {
	if [[ $(whoami) != 'root' ]]; then
		printf "Please run as root\n"
		exit 1
	fi
}

cmd_install() {
	printf "Installer"
}

cmd_remove() {
	printf "Remover"
}

cmd_update() {
	printf "Updater"
}

cmd_upgrade() {
	printf "Upgrader"
}

cmd_help() {
	y='\e[0;33m'
	nc='\e[0m'
	printf "$y\aIchii$nc Linux Package Manager
A source based package manager for use on $y\aIchii$nc Linux.\n
    install - Installs a package
    remove  - Removes a package
    update  - Checks installed packages for updates
    upgrade - Updates ipkg's repositories
    help    - Shows this help menu
"
}

if [[ $1 = '' ]]; then
	cmd_help
	exit 1
fi

command_check() {
	cmds=(install remove update upgrade help)
	
	if [[ ${cmds[*]} =~ $1 ]] ; then
		cmd_$1
	else
		cmd_help
		exit 1
	fi

}

command_check $1
