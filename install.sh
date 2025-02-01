#!/bin/bash

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

# Step 5: Install any additional dependencies for Ansible playbooks (if required)
# Example: Install `openssh` and `python` for Ansible to work correctly
echo "Installing OpenSSH and Python dependencies..."
sudo pacman -S --noconfirm openssh python

# Step 6: Create a directory for your Ansible playbooks (if not already created)
mkdir -p ~/ansible/playbooks

# Step 7: Example playbook setup (place your actual playbook.yaml here)
echo "Creating example playbook..."
cat <<EOF > ~/ansible/playbooks/playbook.yaml
---
- name: Install and configure packages on Arch Linux
  hosts: localhost
  become: yes
  tasks:
    - name: Install Vim
      pacman:
        name: vim
        state: present
    - name: Install Git
      pacman:
        name: git
        state: present
EOF

# Step 8: Run the Ansible playbook locally using ansible-playbook command
echo "Running the Ansible playbook locally..."
ansible-playbook -i localhost, -e ansible_connection=local ~/ansible/playbooks/playbook.yaml

# Step 9: Finish
echo "Script completed. Yay, Ansible, and playbook execution are complete."
