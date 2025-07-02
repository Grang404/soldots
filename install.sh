#!/bin/bash

# TODO: ignore install.sh and README.md
# TODO: Add input for resolution and display drivers maybe?
# TODO: Fix polkit (use hyprpol?)
# TODO: Error handling for service enables

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

LOG_FILE="$SCRIPT_DIR/install_script.log"
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

if [ "$EUID" -ne 0 ]; then
	print_error "Run as sudo"
	exit 1
fi

if [ -z "$SUDO_USER" ]; then
	print_error "SUDO_USER is not set. Run the script using 'sudo -E'."
	exit 1
fi

USER_HOME=$(eval echo ~"$SUDO_USER")

update_system() {
	print_msg "Updating system..."
	pacman -Syu --noconfirm || {
		print_error "Failed to update system"
		exit 1
	}
}

install_packages() {
	print_msg "Installing base packages..."
	pacman -S --needed --noconfirm \
		base base-devel \
		git \
		hyprland \
		hyprlock \
		hyprpaper \
		hyprshot \
		hyprpicker \
		waybar \
		wireplumber \
		wl-clipboard \
		wtype \
		xdg-desktop-portal-hyprland \
		xdg-utils \
		ttf-jetbrains-mono-nerd \
		ttf-nerd-fonts-symbols \
		ttf-nerd-fonts-symbols-mono \
		noto-fonts \
		noto-fonts-emoji \
		zsh \
		wget \
		curl \
		openvpn \
		feh \
		rofi-wayland \
		yazi \
		ffmpeg \
		jq \
		poppler \
		fd \
		fzf \
		zoxide \
		imagemagick \
		btop \
		fastfetch \
		firefox \
		kitty \
		less \
		man-db \
		man-pages \
		npm \
		ntfs-3g \
		p7zip \
		pavucontrol \
		ripgrep \
		rsync \
		tree \
		unzip \
		obs-studio \
		cronie \
		lm_sensors \
		blueman \
		bluez-utils \
		swww \
		vlc || {
		print_error "Failed to install packages"
		exit 1
	}
}
yay_or_paru() {
	# figure out if user has paru or yay, set variable to which, if none default to paru
	YARU=paru
}

install_yaru() {
	print_msg "Installing ${YARU}..."
	if ! command -v "$YARU" &>/dev/null; then
		cd /tmp || exit
		git clone https://aur.archlinux.org/"$YARU".git || {
			print_error "Failed to clone ${YARU}"
			exit 1
		}
		chown -R "$SUDO_USER:$SUDO_USER" "$YARU"
		cd "$YARU" || exit
		sudo -u "$SUDO_USER" makepkg -si --noconfirm || {
			print_error "Failed to install ${YARU}"
			exit 1
		}
		cd ..
		rm -rf "$YARU"
	else
		print_msg "${YARU} is already installed"
	fi
}

install_yaru_packages() {
	print_msg "Installing ${YARU} packages..."
	sudo -u "$SUDO_USER" "$YARU" -S --needed --noconfirm \
		qdirstat \
		nvibrant-bin \
		noisetorch || {
		print_error "Failed to install $YARU packages"
		exit 1
	}
}

backup_config() {
	pass
}
# change this to sym links instead of moving
move_dotfiles() {
	print_msg "Moving config files..."
	CONFIG_DIR="$USER_HOME/.config"

	mkdir -p "$CONFIG_DIR"

	dirs_to_move_to_config=("hypr" "waybar" "kitty" "gtk-2.0" "gtk-3.0" "gtk-4.0" "fastfetch" "rofi")

	for dir in "${dirs_to_move_to_config[@]}"; do
		SOURCE_PATH="$SCRIPT_DIR/$dir"
		if [ -e "$SOURCE_PATH" ]; then
			if [ -d "$SOURCE_PATH" ]; then
				cp -r "$SOURCE_PATH" "$CONFIG_DIR/"
			else
				cp "$SOURCE_PATH" "$CONFIG_DIR/"
			fi
			chown -R "$SUDO_USER:$SUDO_USER" "$CONFIG_DIR/$dir"
			echo "Moved $dir to $CONFIG_DIR"
		else
			print_error "$dir not found in $SCRIPT_DIR, skipping..."
		fi
	done
}

move_fonts() {
	# move fonts/SleepTokenRunes-Regular.*
	pass
}
cleanup() {
	print_msg "Cleaning up temporary files..."
	rm -rf /tmp/"$YARU"
}

main() {
	print_msg "Starting installation..."
	update_system
	install_packages
	install_yaru
	install_yaru_packages
	backup_config
	move_dotfiles # change to syms
	move_fonts
	# add error_handling
	print_success "Installation completed!"
	print_msg "Please reboot your system"
}

main
