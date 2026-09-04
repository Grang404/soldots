#!/usr/bin/env bash

[[ -z "$SUDO_USER" ]] && {
	echo "Must be run via sudo, not as root directly... unless 👀"
	exit 1
}

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

SOL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || {
	echo "Failed to resolve dir"
	exit 1
}

EXPECTED_DIR=$USER_HOME/.local/share/soldots

if [[ "$SOL_DIR" != "$EXPECTED_DIR" ]]; then
	echo "Moving repo to $EXPECTED_DIR..."
	mkdir -p "$(dirname "$EXPECTED_DIR")"
	mv "$SOL_DIR" "$EXPECTED_DIR" || {
		echo "Failed to move $SOL_DIR -> $EXPECTED_DIR"
		exit 1
	}
	exec "$EXPECTED_DIR/install.sh" "$@"
fi

export SOL_DIR
export PATH=$SOL_DIR/bin:$PATH
export DOTS="$SOL_DIR/dots"

source "$SOL_DIR/install/core.sh" || {
	echo "Failed to source core.sh"
	exit 1
}

source "$SOL_DIR/install/detect.sh" || {
	print_error "Failed to source detect.sh"
	exit 1
}

PROFILE=${PROFILE:-$(detect_platform)}
GPU=${GPU:-$(detect_gpu)}
export PROFILE GPU

mkdir -p "$USER_HOME/.config/soldots"
echo "export PROFILE=$PROFILE" >"$USER_HOME/.config/soldots/env"
echo "export GPU=$GPU" >>"$USER_HOME/.config/soldots/env"

LOG_FILE=$SOL_DIR/logs/install.log
mkdir -p "$SOL_DIR/logs"

# sudo keepalive
sudo -v
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &
KEEPALIVE_PID=$!
trap 'kill "$KEEPALIVE_PID" 2>/dev/null' EXIT

exec > >(tee -a "$LOG_FILE") 2>&1

ensure_git() {
	print_msg "Checking if this is a git repo..."
	sol_repo="https://github.com/Grang404/soldots.git"
	[[ -d "$SOL_DIR/.git" ]] && return
	print_warning "No git repository detected"
	command -v git &>/dev/null || {
		print_error "git is required"
		exit 1
	}
	local tmp
	tmp="$(mktemp -d)"
	git clone "$sol_repo" "$tmp" || {
		rm -rf "$tmp"
		print_error "Failed to clone $sol_repo into $tmp. Removing $tmp."
		exit 1
	}
	mv "$tmp/.git" "$SOL_DIR/.git"
	rm -rf "$tmp"
	git -C "$SOL_DIR" checkout .
	print_success "Repo initialised"
}

install_cli() {
	print_msg "Installing CLI..."
	local bin_dir=$USER_HOME/.local/bin
	mkdir -p "$bin_dir"

	for script in "$SOL_DIR/bin/"*; do
		[[ -f "$script" ]] || continue
		ln -sfn "$script" "$bin_dir/$(basename "$script")" || {
			print_warning "failed to link $(basename "$script")"
			continue
		}
		print_msg "Linked $(basename "$script")"
	done

	export PATH="$bin_dir:$PATH"
	[[ "$PATH" == *"$bin_dir"* ]] || print_warning "$bin_dir not in PATH"
	print_success "CLI installed"
}

source "$SOL_DIR/install/banner.sh"

main() {
	show_banner
	sleep 2
	ensure_git
	install_cli

	print_msg "Detected: $PROFILE / $GPU"
	print_msg "Running install scripts..."

	shopt -s nullglob
	scripts=("$SOL_DIR"/install/[0-9]*)
	[[ ${#scripts[@]} -eq 0 ]] && {
		print_error "No install scripts found!"
		exit 1
	}

	ran=0
	for script in "${scripts[@]}"; do
		[[ -f "$script" ]] || continue
		name="$(basename "$script")"

		if [[ "$name" == *"power"* && "$PROFILE" != "laptop" ]]; then
			print_msg "Skipping $name (desktop)"
			continue
		fi

		print_msg "Running $name..."
		bash "$script" || {
			print_error "$name failed"
			exit 1
		}
		print_success "$name done"
		((ran++))
	done

	[[ $ran -eq 0 ]] && {
		print_error "Install failed: no scripts were executed (none executable?)"
		exit 1
	}

	shopt -u nullglob

}

main
