#!/bin/bash

# TODO: Add input for resolution and display drivers
# TODO: Fix polkit (use hyprpol?)

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly LOG_FILE
LOG_FILE="$SCRIPT_DIR/install_script.log"
readonly BACKUP_DIR
BACKUP_DIR="$HOME/.config/config.bak"

exec > >(tee -a "$LOG_FILE") 2>&1

print_msg() {
	echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
	echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
	echo -e "${RED}[!]${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}[!]${NC} $1"
}

check_privileges() {
	if [ "$EUID" -ne 0 ]; then
		print_error "Run as sudo"
		exit 1
	fi

	if [ -z "${SUDO_USER:-}" ]; then
		print_error "SUDO_USER is not set. Run the script using 'sudo -E ./install.sh'"
		exit 1
	fi

	readonly USER_HOME
	USER_HOME=$(eval echo ~"$SUDO_USER")
	print_msg "Installing for user: $SUDO_USER (home: $USER_HOME)"
}

# Update system packages
update_system() {
	print_msg "Updating system packages..."
	if ! pacman -Syu --noconfirm; then
		print_error "Failed to update system packages"
		exit 1
	fi
	print_success "System updated successfully"
}

# Install main packages
install_packages() {
	print_msg "Installing base packages..."

	local packages=(
		# Base system
		base base-devel git

		# Hyprland ecosystem
		hyprland hyprlock hyprpaper hyprshot hyprpicker
		waybar wireplumber wl-clipboard wtype
		xdg-desktop-portal-hyprland xdg-utils

		# Fonts
		ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
		ttf-nerd-fonts-symbols-mono noto-fonts noto-fonts-emoji

		# Shell and utilities
		zsh wget curl feh rofi-wayland yazi ffmpeg jq poppler
		fd fzf zoxide imagemagick btop fastfetch less man-db man-pages

		# Applications
		firefox kitty obs-studio vlc

		# System utilities
		npm ntfs-3g p7zip pavucontrol ripgrep rsync tree unzip
		cronie lm_sensors blueman bluez-utils swww openvpn
	)

	if ! pacman -S --needed --noconfirm "${packages[@]}"; then
		print_error "Failed to install packages"
		exit 1
	fi

	print_success "Base packages installed successfully"
}

# Determine AUR helper
detect_aur_helper() {
	if command -v paru &>/dev/null; then
		echo "paru"
	elif command -v yay &>/dev/null; then
		echo "yay"
	else
		echo "paru" # Default to paru if neither exists
	fi
}

# Install AUR helper
install_aur_helper() {
	local aur_helper
	aur_helper=$(detect_aur_helper)

	print_msg "Checking for AUR helper..."

	if command -v "$aur_helper" &>/dev/null; then
		print_msg "$aur_helper is already installed"
		echo "$aur_helper"
		return 0
	fi

	print_msg "Installing $aur_helper..."

	local temp_dir="/tmp/${aur_helper}_install"
	rm -rf "$temp_dir"

	if ! git clone "https://aur.archlinux.org/${aur_helper}.git" "$temp_dir"; then
		print_error "Failed to clone $aur_helper repository"
		exit 1
	fi

	chown -R "$SUDO_USER:$SUDO_USER" "$temp_dir"

	if ! (cd "$temp_dir" && sudo -u "$SUDO_USER" makepkg -si --noconfirm); then
		print_error "Failed to install $aur_helper"
		exit 1
	fi

	rm -rf "$temp_dir"
	print_success "$aur_helper installed successfully"
	echo "$aur_helper"
}

# Install AUR packages
install_aur_packages() {
	local aur_helper="$1"

	print_msg "Installing AUR packages with $aur_helper..."

	local aur_packages=(
		qdirstat
		nvibrant-bin
		noisetorch
	)

	if ! sudo -u "$SUDO_USER" "$aur_helper" -S --needed --noconfirm "${aur_packages[@]}"; then
		print_error "Failed to install AUR packages"
		exit 1
	fi

	print_success "AUR packages installed successfully"
}

# Create backup of existing configs
backup_existing_configs() {
	print_msg "Creating backup of existing configurations..."

	mkdir -p "$BACKUP_DIR"

	local config_dirs=("hypr" "waybar" "kitty" "gtk-2.0" "gtk-3.0" "gtk-4.0" "fastfetch" "rofi")
	local backed_up=false

	for dir in "${config_dirs[@]}"; do
		local target_path="$USER_HOME/.config/$dir"
		if [ -e "$target_path" ]; then
			cp -r "$target_path" "$BACKUP_DIR/"
			chown -R "$SUDO_USER:$SUDO_USER" "$BACKUP_DIR/$dir"
			print_msg "Backed up existing $dir configuration"
			backed_up=true
		fi
	done

	if [ "$backed_up" = true ]; then
		print_success "Configurations backed up to: $BACKUP_DIR"
	else
		print_msg "No existing configurations found to backup"
		rmdir "$BACKUP_DIR" 2>/dev/null || true
	fi
}

# Create symlinks for dotfiles
create_symlinks() {
	print_msg "Creating symlinks for configuration files..."

	local config_dir="$USER_HOME/.config"
	mkdir -p "$config_dir"
	chown "$SUDO_USER:$SUDO_USER" "$config_dir"

	local config_dirs=("hypr" "waybar" "kitty" "gtk-2.0" "gtk-3.0" "gtk-4.0" "fastfetch" "rofi")

	for dir in "${config_dirs[@]}"; do
		local source_path="$SCRIPT_DIR/$dir"
		local target_path="$config_dir/$dir"

		if [ ! -e "$source_path" ]; then
			print_warning "$dir not found in $SCRIPT_DIR, skipping..."
			continue
		fi

		# Remove existing config if it exists
		if [ -e "$target_path" ]; then
			rm -rf "$target_path"
		fi

		# Create symlink
		if sudo -u "$SUDO_USER" ln -sf "$source_path" "$target_path"; then
			print_success "Created symlink: $target_path -> $source_path"
		else
			print_error "Failed to create symlink for $dir"
			exit 1
		fi
	done
}

# Install custom fonts
install_fonts() {
	print_msg "Installing custom fonts..."

	local fonts_dir="$USER_HOME/.local/share/fonts"
	mkdir -p "$fonts_dir"
	chown -R "$SUDO_USER:$SUDO_USER" "$fonts_dir"

	local font_source="$SCRIPT_DIR/fonts"

	if [ -d "$font_source" ]; then
		if find "$font_source" -name "*.ttf" -o -name "*.otf" | head -1 | grep -q .; then
			cp "$font_source"/*.{ttf,otf} "$fonts_dir/" 2>/dev/null || true
			chown -R "$SUDO_USER:$SUDO_USER" "$fonts_dir"

			# Update font cache
			sudo -u "$SUDO_USER" fc-cache -fv &>/dev/null
			print_success "Custom fonts installed and cache updated"
		else
			print_msg "No font files found in $font_source"
		fi
	else
		print_msg "No fonts directory found, skipping font installation"
	fi
}

# Enable system services
enable_services() {
	print_msg "Enabling system services..."

	local services=(
		"bluetooth.service"
		"cronie.service"
	)

	for service in "${services[@]}"; do
		if systemctl enable "$service" 2>/dev/null; then
			print_success "Enabled $service"
		else
			print_warning "Failed to enable $service (may not be critical)"
		fi
	done
}

# Set default shell
set_default_shell() {
	print_msg "Setting zsh as default shell for $SUDO_USER..."

	if chsh -s /usr/bin/zsh "$SUDO_USER"; then
		print_success "Default shell set to zsh"
	else
		print_warning "Failed to set default shell (you can change it manually with 'chsh -s /usr/bin/zsh')"
	fi
}

# Cleanup function
cleanup() {
	print_msg "Cleaning up temporary files..."
	rm -rf /tmp/*_install 2>/dev/null || true
	print_success "Cleanup completed"
}

# Main installation function
main() {
	print_msg "Starting Hyprland dotfiles installation..."
	print_msg "Log file: $LOG_FILE"

	# Setup
	check_privileges

	# System updates and packages
	update_system
	install_packages

	# AUR helper and packages
	local aur_helper
	aur_helper=$(install_aur_helper)
	install_aur_packages "$aur_helper"

	# Configuration
	backup_existing_configs
	create_symlinks
	install_fonts

	# System configuration
	enable_services
	set_default_shell

	# Cleanup
	cleanup

	print_success "🎉 Installation completed successfully!"
	print_msg "Please reboot your system to ensure all changes take effect"
	print_msg "Your original configurations have been backed up to: $BACKUP_DIR"
}

main "$@"
