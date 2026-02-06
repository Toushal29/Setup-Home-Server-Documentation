#!/bin/bash

# Installation script for Ubuntu Server 24.04 Home Server Setup
# Based on provided documents: Installation.md, Setup.md, Services.md, Monitoring.md, README.md
# Run this script as the user 'toushal' with sudo privileges (e.g., sudo bash install_script.sh)
# Assumes Ubuntu Server is already installed as per Installation.md.
# Username: toushal
# Server name (hostname): toushal_server
# Services to run 24/7: ssh, netdata, smbd + nmbd, filebrowser, tailscale (tailscaled)
# Passwords: Will prompt for sensitive ones (Samba password, File Browser password).
# System password (for sudo) is assumed to be handled by running with sudo.
# Sample password provided: abcdPassword (but you'll input real ones).

# Exit on error
set -e

# Set variables
USERNAME="toushal"
HOSTNAME="toushal_server"

# Prompt for passwords (stored in variables for replication where needed)
read -s -p "Enter Samba password for user '$USERNAME' (will be used for smbpasswd): " SAMBA_PASSWORD
echo ""
read -s -p "Enter File Browser password for user '$USERNAME' (will be used for filebrowser users add): " FILEBROWSER_PASSWORD
echo ""

# Set hostname if not already set
if [ "$(hostname)" != "$HOSTNAME" ]; then
    sudo hostnamectl set-hostname "$HOSTNAME"
    echo "Hostname set to $HOSTNAME"
fi

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install basic utilities + SSH (from Setup.md)
sudo apt install -y curl wget git unzip zip htop btop net-tools lm-sensors vim nano tree openssh-server

# 3. SSH hardening (from Setup.md)
sudo bash -c 'cat << EOF > /etc/ssh/sshd_config.d/hardening.conf
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
EOF'
sudo sshd -t || { echo "SSH config validation failed"; exit 1; }
sudo systemctl restart ssh
sudo systemctl enable --now ssh
echo "SSH is enabled and hardened."

# 4. Install lm-sensors for temperatures (from Monitoring.md)
sudo sensors-detect --auto
sensors  # Verify (non-interactive, just for output)

# 5. Core & utilities Installation (from Setup.md)
sudo apt install -y \
    nginx \
    samba \
    netdata \
    btop \
    curl wget git \
    unzip zip tar \
    python3 python3-pip python3-venv \
    nodejs npm \
    golang-go \
    postgresql postgresql-contrib \
    xorg xrdp xorgxrdp \
    openbox xterm obconf tint2

# 6. Essential Tweaks (from Setup.md)
# 6.1 Swapfile (4GB)
if [ ! -f /swapfile ]; then
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
    sudo sysctl --system
    echo "4GB swapfile created and configured."
fi

# 6.2 Lid close: don't suspend
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/g' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind
echo "Lid close configured to ignore."

# 6.3 Console auto-login
sudo systemctl edit getty@tty1.service --drop-in=autologin
sudo bash -c 'cat << EOF > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin '"$USERNAME"' --noclear %I \$TERM
Type=idle
EOF'
sudo systemctl daemon-reload
echo "Console auto-login configured for user '$USERNAME'."

# 6.4 Set headless mode (CLI only)
sudo systemctl set-default multi-user.target
echo "Headless mode set."

# 7. Configure Samba (from Setup.md)
sudo chmod 770 /home/"$USERNAME"
sudo bash -c 'cat << EOF >> /etc/samba/smb.conf

[home]
   path = /home/'"$USERNAME"'
   browseable = yes
   writable = yes
   valid users = '"$USERNAME"'
   create mask = 0660
   directory mask = 0770
   force user = '"$USERNAME"'
   force group = '"$USERNAME"'
EOF'
# Set Samba password (using variable)
echo -e "$SAMBA_PASSWORD\n$SAMBA_PASSWORD" | sudo smbpasswd -a -s "$USERNAME"
sudo smbpasswd -e "$USERNAME"
sudo systemctl enable --now smbd nmbd
sudo systemctl status smbd nmbd
echo "Samba configured and enabled 24/7."

# 8. Install and Configure File Browser (from Setup.md)
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
sudo mkdir -p /srv/filebrowser/data
sudo chown -R "$USERNAME":"$USERNAME" /srv/filebrowser
# Create admin user (using variable) - non-interactive
filebrowser users add "$USERNAME" "$FILEBROWSER_PASSWORD" --perm.admin
# Create systemd service
sudo bash -c 'cat << EOF > /etc/systemd/system/filebrowser.service
[Unit]
Description=File Browser – Home Directory Access
After=network.target

[Service]
User='"$USERNAME"'
Group='"$USERNAME"'
ExecStart=/usr/local/bin/filebrowser -r /home/'"$USERNAME"' -d /srv/filebrowser/data/database.db -p 8080 --noauth=false
Restart=always
WorkingDirectory=/home/'"$USERNAME"'

[Install]
WantedBy=multi-user.target
EOF'
sudo systemctl daemon-reload
sudo systemctl enable --now filebrowser
sudo systemctl status filebrowser
echo "File Browser configured and enabled 24/7."

# 9. Install Tailscale (from Setup.md)
curl -fsSL https://tailscale.com/install.sh | sh
# Authenticate and connect (this may require manual interaction for login - open the link in a browser)
sudo tailscale up
sudo systemctl enable --now tailscaled
tailscale status
echo "Tailscale installed and enabled 24/7."

# 10. Configure Netdata (from Setup.md)
sudo systemctl enable --now netdata
sudo systemctl status netdata
echo "Netdata enabled 24/7."

# 11. XRDP Configuration (from Setup.md) - NOT enabled 24/7, manual start
mkdir -p ~/.config/openbox
echo "exec openbox-session" > ~/.xsession
echo "tint2 &" >> ~/.xsession
chmod 644 ~/.xsession
echo "XRDP configured but NOT auto-enabled (start manually with: sudo systemctl start xrdp xrdp-sesman)"

# 12. Quick Enable All 24/7 Services (from Services.md) - Already done above, but verify
sudo systemctl enable --now ssh
sudo systemctl enable --now netdata
sudo systemctl enable --now smbd nmbd
sudo systemctl enable --now filebrowser
sudo tailscale up  # Ensure up
sudo systemctl enable --now tailscaled

echo "Installation complete. Services running 24/7: ssh, netdata, smbd, nmbd, filebrowser, tailscaled."
echo "Reboot recommended: sudo reboot"