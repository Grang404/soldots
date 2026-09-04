#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"

[[ -z "$USER_HOME" ]] && {
	print_error "could not resolve USER_HOME"
	exit 1
}

print_msg "Configuring XDG directories and MIME associations..."

mkdir -p "$USER_HOME/.cache" "$USER_HOME/.config" \
	"$USER_HOME/.local/share" "$USER_HOME/.local/state" "$USER_HOME/.local/bin"

chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.cache" "$USER_HOME/.config" "$USER_HOME/.local"

[[ -d /etc/xdg ]] || {
	print_warning "No /etc/xdg, creating..."
	mkdir /etc/xdg
}

cp "$GROOB_DIR/dots/xdg/user-dirs.conf" "$GROOB_DIR/dots/xdg/user-dirs.defaults" /etc/xdg/ || {
	print_error "Failed to copy xdg configs"
	exit 1
}
sudo -u "$SUDO_USER" xdg-user-dirs-update || {
	print_error "xdg-user-dirs-update failed"
	exit 1
}

print_success "XDG configured"
