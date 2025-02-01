#!/bin/bash

# Ensure the system is fully up-to-date
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install dependencies required for Ansible
echo "Installing required dependencies..."
sudo pacman -S --noconfirm python python-pip git

# Install Ansible via pacman (official Arch repo)
echo "Installing Ansible..."
sudo pacman -S --noconfirm ansible

# Verify Ansible installation
ansible --version

# Optional: Install any required Python packages from requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies from requirements.txt..."
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
fi

# Define playbook and inventory file paths
PLAYBOOK_PATH="playbook.yaml"
# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i "$PLAYBOOK_PATH"
