#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"
source "$SOL_DIR/install/detect.sh"

[[ -z "$USER_HOME" ]] && {
	print_error "could not resolve USER_HOME"
	exit 1
}

CONFIG="$USER_HOME/.config"

[[ -d "$DOTS" ]] || {
	print_error "Dotfiles directory not found: $DOTS"
	exit 1
}

# config dirs
shopt -s nullglob
for dir in "$DOTS"/*; do
	[[ -d "$dir" ]] || continue
	[[ "$(basename "$dir")" = "hypr" ]] && continue
	link "$dir" "$CONFIG/$(basename "$dir")"
done

# hypr
mkdir -p "$CONFIG/hypr"

for f in "$DOTS/hypr"/*.conf; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
for f in "$DOTS/hypr"/*.lua; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
shopt -u nullglob

# home dotfiles
for dot in zshrc zprofile zshenv; do
	link "$DOTS/$dot" "$USER_HOME/.$dot"
done

# mimelist
link "$DOTS/mimeapps.list" "$CONFIG/mimeapps.list"

mkdir -p "$USER_HOME/Pictures"
[[ -n "$SUDO_USER" ]] && chown "$SUDO_USER" "$USER_HOME/Pictures"
link "$SOL_DIR/wallpapers" "$USER_HOME/Pictures/wallpapers"

print_success "Dotfiles linked"
