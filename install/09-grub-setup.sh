#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"

config_grub() {

	print_msg "Configuring GRUB..."

	if ! command -v grub-mkconfig &>/dev/null; then
		print_error "GRUB not installed, skipping GRUB configuration"
		return 0
	fi

	local pstate_param=""
	local vendor
	vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')

	if [[ "$vendor" == "AuthenticAMD" ]]; then
		pstate_param="amd_pstate=active"
	elif [[ "$vendor" == "GenuineIntel" ]]; then
		pstate_param="intel_pstate=active"
	fi

	if [[ -n "$pstate_param" ]]; then
		if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub; then
			sed -i "s/^GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 ${pstate_param}\"/" /etc/default/grub
		else
			echo "GRUB_CMDLINE_LINUX=\"${pstate_param}\"" >>/etc/default/grub
		fi
	fi

	grub-mkconfig -o /boot/grub/grub.cfg
	print_success "GRUB configured successfully"
}

config_grub
