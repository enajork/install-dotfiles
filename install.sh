#!/bin/bash

# Step 1: Update the system
echo "Updating the system..."
sudo pacman -Syu --noconfirm

# Step 2: Install base-devel, git, and other dependencies if not already installed
echo "Checking and installing dependencies..."

# List of packages to check and install
packages=("base-devel" "git" "python" "python-pip")

for package in "${packages[@]}"; do
    if ! pacman -Qs "$package" > /dev/null; then
        echo "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package is already installed."
    fi
done

# Step 3: Install Yay (AUR helper) if not already installed
echo "Checking if Yay is installed..."
if ! command -v yay &> /dev/null; then
    echo "Yay is not installed. Installing Yay..."
    YAY_DIR=/tmp/yay
    if [ ! -d "$YAY_DIR" ]; then
        echo "Cloning yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd ~
    else
        echo "Yay already exists."
    fi
else
    echo "Yay is already installed."
fi

# Step 4: Install Ansible using yay if not already installed
echo "Checking if Ansible is installed..."
if ! pacman -Qs ansible > /dev/null && ! yay -Qs ansible > /dev/null; then
    echo "Installing Ansible using yay..."
    yay -Sy --noconfirm ansible
else
    echo "Ansible is already installed."
fi

# Step 5: Clone dotfiles repository with retry mechanism
DOTFILES_DIR=~/dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    RETRIES=3  # Number of retries
    COUNT=0     # Counter for retries
    while [ $COUNT -lt $RETRIES ]; do
        git clone https://github.com/enajork/dotfiles.git ~/dotfiles && break
        COUNT=$((COUNT + 1))
        echo "Retrying clone ($COUNT/$RETRIES)..."
        sleep 5  # Wait for 5 seconds before retrying
    done
    if [ $COUNT -eq $RETRIES ]; then
        echo "Failed to clone dotfiles repository after $RETRIES attempts."
        exit 1  # Exit the script with an error if all retries fail
    fi
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# Step 6: Run the Ansible playbook
echo "Running the Ansible playbook..."
ansible-playbook -i localhost, -e ansible_connection=local ~/playbook.yaml

# Complete!
echo "Script finished. Check output for errors."
