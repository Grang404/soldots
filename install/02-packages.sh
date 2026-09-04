#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"
source "$SOL_DIR/install/detect.sh"

PROFILE=${PROFILE:-$(detect_platform)}
PKG_DIR=$SOL_DIR/install/packages

install_group() {
	local group=$1
	local file=$PKG_DIR/$group.pkgs

	[[ -f "$file" ]] || {
		print_warning "Missing: $file, skipping"
		return
	}

	mapfile -t pkgs < <(
		grep -v '^\s*#' "$file" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
	)

	[[ ${#pkgs[@]} -eq 0 ]] && {
		print_warning "$group has no packages, skipping"
		return
	}

	print_msg "Installing $group packages..."

	sudo pacman -S --needed --noconfirm "${pkgs[@]}" ||
		{
			print_error "Failed to install $group!"
			exit 1
		}

	print_success "All $group packages have been installed..."
}

groups=(core apps fonts utils)
[[ "$PROFILE" == "laptop" && -f "$PKG_DIR/laptop.pkgs" ]] && groups+=(laptop)

for group in "${groups[@]}"; do
	install_group "$group"
done

user_pkgs="$SOL_DIR/install/packages/user.pkgs"
if [[ -f "$user_pkgs" ]]; then
	print_msg "Installing user packages..."

	mapfile -t pkgs < <(
		grep -v '^\s*#' "$user_pkgs" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
	)

	[[ ${#pkgs[@]} -eq 0 ]] && {
		print_warning "user.pkgs has no packages, skipping"
		return
	}
	sudo pacman -S --needed --noconfirm "${pkgs[@]}" || {
		print_error "Failed to install $user_pkgs"
		exit 1
	}
	print_success "User packages done"
fi
