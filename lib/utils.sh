#!/usr/bin/env bash

# Common utility functions.
#
# Source in other scripts like so:
#	# shellcheck disable=SC1091
#   source "${XDG_DATA_HOME:-$HOME/.local/share}/grimoire/lib/utils.sh"

set -euo pipefail

# Text styles
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
white="\033[37m"
bold="\033[1m"
underline="\033[4m"
reversed="\033[7m"
reset="\033[0m"

ensure() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo -e "${bold}${magenta}fatal${reset} ${bold}$1${reset} not available"
		exit 1
	fi
}

log() {
	if command -v gum >/dev/null 2>&1; then
		level="$1"
		shift
		gum log --structured -l "$level" "$@"
	else
		local level="$1"
		shift
		echo -ne "[${bold}${blue}$level]${reset}" "$@"
	fi
}

raise() {
	log fatal "$@"
	exit 1
}

raise_flag() {
	# Strip leading dashes
	# shellcheck disable=sc2001
	flag="$(echo "$1" | sed 's/^-*//g')"
	log fatal "unknown flag" flag "$flag"
	exit 1
}
