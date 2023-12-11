#!/bin/bash

# Set the target directory
deploy_directory="/opt/core/deploy"

# Change to the deployment directory
cd "$deploy_directory" || { echo "Error: Unable to change to $deploy_directory. Exiting."; exit 1; }

# Perform git clone
git clone "https://github.com/racetracks/debian-deploy.git" || { echo "Error: Unable to clone the repository. Exiting."; exit 1; }

echo "Git clone successful."
