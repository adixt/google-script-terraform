#!/bin/bash

echo "Running startup script for user ${ssh_username}..." | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.bashrc'
sudo -u ${ssh_username} bash -c 'echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> ~/.bashrc'
sudo -u ${ssh_username} bash -c '. $HOME/.nvm/nvm.sh && nvm install --lts' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'echo '${key_json_base64}' | base64 --decode > ~/key.json' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'sudo apt install htop -y' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'source ~/.bashrc; . $HOME/.nvm/nvm.sh; npm install -g @google/clasp' | tee -a /var/log/startup-script.log