#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Install sudo
apt-get update
apt-get install -y sudo

# Add a user to the sudo group and add to sudoers file (replace 'dc' with the desired username)
useradd -m -s /bin/bash dc
usermod -aG sudo dc

# Disable su by changing the root shell
usermod -s /sbin/nologin root

# Disable root from SSH login
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Restart SSH service to apply changes
service ssh restart

# Add user 'dc' to sudoers file
echo "dc ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "Setup complete. Make sure to test the SSH login with the user account before logging out as root."

## next
# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Exiting."
   exit 1
fi

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

# Apply the changes
sysctl -p

echo "IPv6 has been disabled. Please restart the network for the changes to take effect."

#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install netplan if not already installed
apt update
apt install -y netplan.io

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

# Apply the Netplan configuration
netplan apply

echo "Netplan configuration applied successfully for interface: $eth_interface."

