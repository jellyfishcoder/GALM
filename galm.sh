#!/usr/bin/env bash

ARDUINO_LIB_FOLDER="~/Documents/Arduino/libraries"

function quiet_cd() {
	cd "$@" >/dev/null || ordie "Error: failed to cd to $*!"
}

function ordie() {
	orer "$@"
	exit 1
}

function orer() {
	# If STDERR is a tty use color, else dont use color
	if [[ -t 2 ]]
	then
		echo -ne "\033[4;31mError\033[0m: " >&2
	else
		echo -n "Error: " >&2
	fi
	# Print the error message
	if [[ $# -eq 0 ]]
	then
		/bin/cat >&2
	else
		echo "$*" >&2
	fi
}

# To list libraries
function list() {
	quiet_cd $ARDUINO_LIB_FOLDER
	ls -d */
}

# To update libraries
function update() {
	if [[ "$@" = "ALL" ]]
	then
		echo "Updating all libraries"
		# CD to lib folder
		quiet_cd "$ARDUINO_LIB_FOLDER"
		
		# For every folder, look for git file and pull if it exists
		for dir in $(ls -d */)
		do
			quiet_cd "$dir" && find .git && git pull && echo "$dir was successfully updated" || echo "Could not update $dir because it is not a git repo, or there was an error pulling."
			quiet_cd "$ARDUINO_LIB_FOLDER"
		done
	else
		echo "Updating $@"
		
		# Update specified library
		quiet_cd "$ARDUINO_LIB_FOLDER"
		quiet_cd "$@"
		find .git || ordie "$@ is not a git repo."
		git pull && echo "$dir was successfully updated" || echo "Could not update $dir because of a pull error"
	fi
}

### End of functions, start of main script

# Total Number of Arguments
GALM_ARG_COUNT="$#"
# First Argument
GALM_COMMAND="$1"
# Get rid of $1 and move other args down
shift

# Command aliases
case "$GALM_COMMAND" in
	instal)		GALM_COMMAND="install";;
	remove)		GALM_COMMAND="uninstall";;
	rm)		GALM_COMMAND="uninstall";;
	ls)		GALM_COMMAND="list";;
esac

if [ "$GALM_ARG_COUNT" > 1 ]
then
	GALM_UPDATE_WHICH="$1"
else
	GALM_UPDATE_WHICH="ALL"
fi

# Run the subcommand from the argument
case "$GALM_COMMAND" in
	list)		list;;
	update)		update "$GALM_UPDATE_WHICH";;
	install)	echo "Install is not yet implemented";;
	uninstall)	echo "Uninstall is not yet implemented";;
esac
