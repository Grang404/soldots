#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"
source "$SOL_DIR/install/detect.sh"

print_msg "Installing GPU drivers ($GPU)..."

install_gpu_pkgs() {
	sudo pacman -S --needed --noconfirm "$@" || {
		print_error "GPU driver failed to install"
		exit 1
	}
}

case "$GPU" in
amd) install_gpu_pkgs vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa ;;
nvidia) install_gpu_pkgs nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings linux-zen-headers ;;
intel) install_gpu_pkgs mesa lib32-mesa vulkan-intel lib32-vulkan-intel ;;
*)
	print_warning "Unknown GPU, defaulting to mesa"
	install_gpu_pkgs mesa lib32-mesa
	;;
esac

print_success "GPU drivers installed"
