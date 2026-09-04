#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"

print_msg "Updating system..."
sudo pacman -Syu --noconfirm || {
	print_error "System update failed"
	exit 1
}

print_success "System updated"

if grep -q "^\[multilib\]" /etc/pacman.conf; then
	print_msg "Multilib already enabled, skipping"
else
	print_msg "Enabling multilib..."

	multilib_pattern='\|^#\[multilib\]|,\|^#Include = /etc/pacman.d/mirrorlist| s/^#//'
	sudo sed -i "$multilib_pattern" /etc/pacman.conf || {
		print_error "Failed to write to /etc/pacman.conf"
		exit 1
	}

	sudo pacman -Sy --noconfirm || {
		print_error "Failed to enable multilib"
		exit 1
	}
	print_success "Multilib enabled"
fi
