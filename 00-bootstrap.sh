#!/bin/bash

# Update APT cache
apt update

# Install Ansible
apt install -y ansible sudo

#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Install sudo



# Add a user to the sudo group (replace 'dc' with the desired username)
usermod -aG sudo dc

# Disable su
passwd -l root

# Disable root from SSH login
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Restart SSH service to apply changes
service ssh restart

echo "Setup complete. Make sure to test the SSH login with the user account before logging out as root."

