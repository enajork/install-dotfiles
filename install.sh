#!/bin/bash

# Function to check if the script is being run as root
check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
  fi
}

# Function to install dependencies for Ansible
install_dependencies() {
  echo "Installing required dependencies..."
  
  # Update package index
  apt update -y
  
  # Install prerequisites
  apt install -y software-properties-common

  # Add Ansible PPA (Ubuntu/Debian-based distros)
  apt-add-repository ppa:ansible/ansible -y

  # Update the package list after adding the new PPA
  apt update -y

  # Install Ansible
  apt install -y ansible

  # Install python and pip (needed for Ansible)
  apt install -y python3 python3-pip

  # Install additional dependencies for Ansible
  pip3 install --upgrade pip
  pip3 install ansible
}

# Function to run the playbook
run_playbook() {
  PLAYBOOK_FILE="playbook.yaml"

  # Check if the playbook file exists
  if [ ! -f "$PLAYBOOK_FILE" ]; then
    echo "Playbook file '$PLAYBOOK_FILE' not found!"
    exit 1
  fi

  # Run the playbook using ansible-playbook command
  echo "Running the playbook '$PLAYBOOK_FILE'..."
  ansible-playbook "$PLAYBOOK_FILE"
}

# Main script execution
check_root
install_dependencies
run_playbook
