#!/bin/bash

# Function to print logs
log() {
  echo "[INFO] $1"
}

# Ensure the system is up-to-date
log "Updating system..."
sudo pacman -Syu --noconfirm

# Install required dependencies (python, pip, git, and others needed by Ansible)
log "Installing dependencies..."
sudo pacman -S --noconfirm python python-pip git

# Install Ansible via pacman (official Arch repo)
log "Installing Ansible..."
sudo pacman -S --noconfirm ansible

# Verify Ansible installation
log "Verifying Ansible installation..."
ansible --version

# Optional: Install any required Python packages from requirements.txt
if [ -f "requirements.txt" ]; then
    log "Installing Python dependencies from requirements.txt..."
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
fi

# Define playbook and inventory file paths
PLAYBOOK_PATH="$1"
INVENTORY_PATH="$2"

# Check if the playbook and inventory file paths were provided
if [ -z "$PLAYBOOK_PATH" ] || [ -z "$INVENTORY_PATH" ]; then
    log "ERROR: Playbook path or inventory path not provided!"
    echo "Usage: $0 <path_to_playbook.yml> <path_to_inventory>"
    exit 1
fi

# Check if the playbook file exists
if [ ! -f "$PLAYBOOK_PATH" ]; then
    log "ERROR: Playbook file not found at $PLAYBOOK_PATH"
    exit 1
fi

# Check if the inventory file exists
if [ ! -f "$INVENTORY_PATH" ]; then
    log "ERROR: Inventory file not found at $INVENTORY_PATH"
    exit 1
fi

# Run the Ansible playbook
log "Running Ansible playbook..."
ansible-playbook -i "$INVENTORY_PATH" "$PLAYBOOK_PATH"

# Check the exit status of the playbook run
if [ $? -eq 0 ]; then
    log "Ansible playbook ran successfully!"
else
    log "Ansible playbook failed!"
    exit 1
fi
