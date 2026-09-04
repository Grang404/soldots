#!/usr/bin/env bash

RED='\033[0;31m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

print_msg() { echo -e "${BOLD}${BLUE}[*]${NC} $1"; }
print_success() { echo -e "${BOLD}${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${BOLD}${RED}[!]${NC} $1"; }
print_warning() { echo -e "${BOLD}${YELLOW}[!]${NC} $1"; }

if [[ -n "$SUDO_USER" ]]; then
	USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
	export USER_HOME
fi

link() {
	local src="$1" tgt="$2"
	[[ -e "$src" ]] || {
		print_warning "source not found: $src"
		return
	}
	[[ -z "$tgt" ]] && {
		print_warning "empty target, skipping"
		return
	}
	[[ -e "$tgt" ]] && {
		print_warning "Replacing existing: $tgt"
		rm -rf "$tgt"
	}
	ln -sf "$src" "$tgt"
	[[ -n "$SUDO_USER" ]] && chown -h "$SUDO_USER" "$tgt"
	print_msg "Linked $(basename "$src") → $tgt"
}
