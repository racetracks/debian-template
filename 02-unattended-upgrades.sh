#!/bin/bash

# Update package list
sudo apt update

# Install unattended-upgrades package
sudo apt install unattended-upgrades -y

# Enable the unattended-upgrades service
sudo dpkg-reconfigure -plow unattended-upgrades

# Install KernelCare
sudo wget -qq http://repo.kernelcare.com/3.10.0/3.10.0-862.14.4.el7/kernelcare-latest-$(uname -m).deb -O /tmp/kernelcare-latest.deb
sudo dpkg -i /tmp/kernelcare-latest.deb

# Configure unattended-upgrades to install patches for all packages
sudo tee /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Display the configuration
cat /etc/apt/apt.conf.d/20auto-upgrades

echo "Unattended upgrades and KernelCare installed and configured. Reboot settings modified."

# To apply the changes without rebooting, you may want to restart the unattended-upgrades service
sudo systemctl restart unattended-upgrades
