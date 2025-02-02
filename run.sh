#!/bin/bash

curl -sL https://raw.githubusercontent.com/enajork/install-dotfiles/main/install.sh -o install.sh && \
curl -sL https://raw.githubusercontent.com/enajork/install-dotfiles/main/playbook.yaml -o playbook.yaml
chmod +x install.sh
./install.sh
rm -f install.sh playbook.yaml
echo "Installation exited and cleanup done."
