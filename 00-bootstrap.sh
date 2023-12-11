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
