#!/usr/bin/env bash

source "$SOL_DIR/install/core.sh"

if [[ $PROFILE != "laptop" ]]; then
	exit 0
fi

[[ $EUID -ne 0 ]] && exec sudo "$0" "$@"

cat >/etc/tlp.conf <<'EOF'
TLP_ENABLE="1"
TLP_WARN_LEVEL="3"

# CPU
CPU_SCALING_GOVERNOR_ON_AC=""
CPU_SCALING_GOVERNOR_ON_BAT=""
CPU_ENERGY_PERF_POLICY_ON_AC=""
CPU_ENERGY_PERF_POLICY_ON_BAT=""
CPU_BOOST_ON_AC=""
CPU_BOOST_ON_BAT=""

# Platform profile
PLATFORM_PROFILE_ON_AC=""
PLATFORM_PROFILE_ON_BAT=""

# Disk
DISK_DEVICES="nvme0n1"
DISK_IDLE_SECS_ON_AC="0"
DISK_IDLE_SECS_ON_BAT="2"

# PCIe
PCIE_ASPM_ON_AC=""
PCIE_ASPM_ON_BAT=""

# Runtime PM
RUNTIME_PM_ON_AC="auto"
RUNTIME_PM_ON_BAT="auto"

# WiFi
WIFI_PWR_ON_AC="off"
WIFI_PWR_ON_BAT="off"

# Battery thresholds
START_CHARGE_THRESH_BAT0="75"
STOP_CHARGE_THRESH_BAT0="80"
EOF

if ! write_tlp_conf >/etc/tlp.conf; then
	print_error "Failed to write tlp.conf -> /etc/tlp.conf"
	print_warning "Skipping tlp.conf"
fi

print_success "Successfully wrote tlp.conf -> /etc/tlp.conf"
