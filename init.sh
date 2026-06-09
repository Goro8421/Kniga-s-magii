#!/usr/bin/env bash

# Usage: init.sh
#
# Clones the Grimoire repo and creates a `grim` command.

set -euo pipefail

repo="git@github.com:ngscheurich/grimoire.git"
dest="${XDG_DATA_HOME:-$HOME/.local/share}/grimoire"
link="$HOME/.local/bin/grim"

# Clone repo
if [ -d "$dest" ]; then
	echo "👻 Nothing happens..."
else
	git clone "$repo" "$dest"
fi

# Create symlink
if [ -f "$link" ]; then rm "$link"; fi
eval "ln -s $dest/bin/grim $link"
