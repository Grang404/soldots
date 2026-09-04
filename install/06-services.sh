#!/usr/bin/env bash
source "$SOL_DIR/install/core.sh"

[[ -z "$PROFILE" ]] && {
	print_error "PROFILE is not set"
	exit 1
}

print_msg "Enabling system services..."

system_services=(
	"cronie.service"
	"fstrim.timer"
	"NetworkManager"
)

desktop_services=(
	"lm_sensors.service"
)

laptop_services=(
	"bluetooth.service"
	"tlp.service"
)

services=("${system_services[@]}")
[[ "$PROFILE" == "laptop" ]] && services+=("${laptop_services[@]}")
[[ "$PROFILE" == "desktop" ]] && services+=("${desktop_services[@]}")

for service in "${services[@]}"; do
	if ! systemctl list-unit-files | grep -q "^$service"; then
		print_warning "$service not found, skipping"
		continue
	fi
	systemctl enable --now "$service" || {
		print_warning "Failed to enable $service"
		continue
	}
	print_success "Enabled $service"
done

print_success "Services started"
