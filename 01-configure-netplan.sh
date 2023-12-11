#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install netplan if not already installed
apt update
apt install -y netplan.io systemd

# Disable the existing networking stack
systemctl stop networking
systemctl disable networking
systemctl mask networking

# Detect the primary Ethernet interface dynamically
eth_interface=$(ip -o -4 route show to default | awk '{print $5}')

# Create a Netplan YAML configuration file
cat <<EOL > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $eth_interface:
      dhcp4: true
EOL

# Set restrictive permissions on the Netplan configuration file
chmod 0644 /etc/netplan/01-netcfg.yaml

# Apply the Netplan configuration
netplan apply

echo "Netplan configuration applied successfully for interface: $eth_interface."
