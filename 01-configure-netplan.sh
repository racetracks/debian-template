#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install netplan if not already installed
apt update
apt install -y netplan.io systemd openvswitch-switch





# Disable the existing networking stack
systemctl stop networking
systemctl disable networking
systemctl mask networking

# Detect the primary Ethernet interface dynamically


# Create a Netplan YAML configuration file
cat <<EOL > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      dhcp4: true
EOL

# Set restrictive permissions on the Netplan configuration file
chmod 0644 /etc/netplan/01-netcfg.yaml

sudo systemctl enable openvswitch-switch
sudo systemctl start openvswitch-switch


# Apply the Netplan configuration
netplan apply

echo "Netplan configuration applied successfully for interface: $eth_interface."
