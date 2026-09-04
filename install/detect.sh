#!/usr/bin/env bash

is_laptop() {
	local chassis
	chassis="$(cat /sys/class/dmi/id/chassis_type 2>/dev/null)"
	[[ "$chassis" =~ ^(8|9|10|14)$ ]] && return 0
	compgen -G "/sys/class/power_supply/BAT*" >/dev/null 2>&1
}

detect_platform() {
	is_laptop && echo "laptop" || echo "desktop"
}

detect_gpu() {
	if command -v lspci >/dev/null 2>&1; then
		local gpu
		gpu="$(lspci | grep -Ei "vga|3d|display")"
		echo "$gpu" | grep -qi nvidia && {
			echo "nvidia"
			return
		}
		echo "$gpu" | grep -qi "amd\|radeon" && {
			echo "amd"
			return
		}
		echo "$gpu" | grep -qi intel && {
			echo "intel"
			return
		}
	fi
	for f in /sys/class/drm/card*/device/vendor; do
		[[ -e "$f" ]] || continue
		case "$(cat "$f")" in
		0x10de)
			echo "nvidia"
			return
			;;
		0x1002)
			echo "amd"
			return
			;;
		0x8086)
			echo "intel"
			return
			;;
		esac
	done
	echo "unknown"
}
