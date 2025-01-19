#!/bin/bash


apt-get update
apt install ansible -y
apt upgrade -y
apt dist-upgrade

# Execute the Ansible playbook for initial configuration
ansible-playbook 01-initial-config_no_docker.yml

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Ansible playbook execution failed."
    exit 1
fi

echo "All scripts executed successfully."
