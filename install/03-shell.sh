#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"

PLUGINS_DIR="$SOL_DIR/dots/zsh/plugins"
THEMES_DIR="$SOL_DIR/dots/zsh/themes"

mkdir -p "$PLUGINS_DIR" "$THEMES_DIR"

clone_if_missing() {
	local url=$1
	local dest=$2
	local name
	name=$(basename "$dest")

	if [[ -d "$dest" ]]; then
		print_msg "$name already exists, skipping"
		return
	fi

	git clone --depth=1 "$url" "$dest" || print_warning "Failed to clone: $url"
	print_success "$name installed"
}

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"

chsh -s /usr/bin/zsh "$SUDO_USER"
print_success "zsh configured"
