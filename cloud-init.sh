#!/bin/bash

echo "Running startup script for user ${ssh_username}..." | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.bashrc'
sudo -u ${ssh_username} bash -c 'echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> ~/.bashrc'
sudo -u ${ssh_username} bash -c '. $HOME/.nvm/nvm.sh && nvm install --lts' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'echo '${key_json_base64}' | base64 --decode > ~/key.json' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'sudo apt install htop -y' | tee -a /var/log/startup-script.log
sudo -u ${ssh_username} bash -c 'source ~/.bashrc; . $HOME/.nvm/nvm.sh; npm install -g @google/clasp' | tee -a /var/log/startup-script.log

# Create a folder
sudo -u ${ssh_username} bash -c 'mkdir $HOME/actions-runner' | tee -a /var/log/startup-script.log
# Download the latest runner package
sudo -u ${ssh_username} bash -c 'curl -o $HOME/actions-runner/actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz' | tee -a /var/log/startup-script.log
# Optional: Validate the hash
sudo -u ${ssh_username} bash -c 'echo "29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278  $HOME/actions-runner/actions-runner-linux-x64-2.311.0.tar.gz" | shasum -a 256 -c' | tee -a /var/log/startup-script.log
# Extract the installer
sudo -u ${ssh_username} bash -c 'tar xzf $HOME/actions-runner/actions-runner-linux-x64-2.311.0.tar.gz -C $HOME/actions-runner/' | tee -a /var/log/startup-script.log
# Create the runner and start the configuration experience
sudo -u ${ssh_username} bash -c '$HOME/actions-runner/config.sh --unattended --replace  --url https://github.com/adixt/google-script-terraform --token <REPLACE_WITH_REAL_TOKEN_HERE>' | tee -a /var/log/startup-script.log
# Last step, run it!
sudo -u ${ssh_username} bash -c '$HOME/actions-runner/run.sh' | tee -a /var/log/startup-script.log