#!/bin/bash


apt-get update
apt install ansible -y
apt upgrade -y
apt dist-upgrade -y


# Execute the bootstrap script
sh 00-bootstrap.sh

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Execution of 00-bootstrap.sh failed."
    exit 1
fi

# Execute the Ansible playbook for initial configuration
ansible-playbook 01-initial-config.yml

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Ansible playbook execution failed."
    exit 1
fi

# Execute the script to install Docker
sh 02-install-docker.sh

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Execution of 02-install-docker.sh failed."
    exit 1
fi

# Execute the script to install Docker containers
sh 03-install-docker-containers.sh

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Execution of 03-install-docker-containers.sh failed."
    exit 1
fi

echo "All scripts executed successfully."
