#!/bin/bash

# Enable error handling: exit on any error
set -e

# Step 1: Update the system
echo "Updating the system..."
sudo pacman -Syu --noconfirm

# Step 2: Install base-devel, git, and other dependencies
echo "Installing base-devel and git..."
sudo pacman -S --noconfirm base-devel git python python-pip

# Step 3: Install Yay (AUR helper)
echo "Installing Yay..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd ~
rm -rf /tmp/yay

# Step 4: Install Ansible using yay (or pacman if you prefer)
echo "Installing Ansible using yay..."
yay -Sy --noconfirm ansible

# Step 5: Clone dotfiles repository only if it doesn't already exist
DOTFILES_DIR=~/dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/enajork/dotfiles.git ~/dotfiles
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# Step 6: Run the Ansible playbook
echo "Running the Ansible playbook..."
ansible-playbook -i localhost, -e ansible_connection=local ~/playbook.yaml

# Complete!
echo "Script completed."
