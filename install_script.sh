#!/usr/bin/env bash
# Ubuntu Server 24.04 – Automated Home Server Setup (Idempotent)
# User: toushal
# Hostname: toushal_server

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# LOGGING
# ─────────────────────────────────────────────────────────────
LOGFILE="/var/log/home-server-install.log"
exec > >(tee -a "$LOGFILE") 2>&1

# ─────────────────────────────────────────────────────────────
# VARIABLES
# ─────────────────────────────────────────────────────────────
USERNAME="toushal"
HOSTNAME="toushal_server"

# ─────────────────────────────────────────────────────────────
# PASSWORD PROMPTS
# ─────────────────────────────────────────────────────────────
read -s -p "Enter Samba password for user '$USERNAME': " SAMBA_PASSWORD
echo
read -s -p "Enter File Browser password for user '$USERNAME': " FILEBROWSER_PASSWORD
echo

# ─────────────────────────────────────────────────────────────
# HOSTNAME
# ─────────────────────────────────────────────────────────────
if [ "$(hostname)" != "$HOSTNAME" ]; then
  hostnamectl set-hostname "$HOSTNAME"
fi

# ─────────────────────────────────────────────────────────────
# APT MIRROR FIX (WORLDWIDE)
# ─────────────────────────────────────────────────────────────
sed -i \
  -e 's|http://[^ ]*archive.ubuntu.com/ubuntu|http://archive.ubuntu.com/ubuntu|g' \
  -e 's|http://[^ ]*security.ubuntu.com/ubuntu|http://security.ubuntu.com/ubuntu|g' \
  /etc/apt/sources.list

apt clean
apt update && apt upgrade -y

# ─────────────────────────────────────────────────────────────
# BASE PACKAGES
# ─────────────────────────────────────────────────────────────
apt install -y \
  curl wget git unzip zip tar tree \
  htop btop net-tools vim nano \
  openssh-server lm-sensors \
  samba netdata nginx \
  python3 python3-pip python3-venv \
  nodejs npm golang-go \
  postgresql postgresql-contrib \
  xorg xrdp xorgxrdp openbox xterm obconf tint2

# ─────────────────────────────────────────────────────────────
# SSH HARDENING
# ─────────────────────────────────────────────────────────────
cat << EOF > /etc/ssh/sshd_config.d/hardening.conf
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
EOF

sshd -t
systemctl enable --now ssh

# ─────────────────────────────────────────────────────────────
# SENSORS (ONE-TIME)
# ─────────────────────────────────────────────────────────────
if [ ! -f /etc/sensors3.conf ]; then
  sensors-detect --auto
fi

# ─────────────────────────────────────────────────────────────
# SWAPFILE (4GB)
# ─────────────────────────────────────────────────────────────
if [ ! -f /swapfile ]; then
  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo 'vm.swappiness=10' > /etc/sysctl.d/99-swappiness.conf
  sysctl --system
fi

# ─────────────────────────────────────────────────────────────
# LID CLOSE BEHAVIOR
# ─────────────────────────────────────────────────────────────
sed -i 's/#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
systemctl restart systemd-logind

# ─────────────────────────────────────────────────────────────
# CONSOLE AUTO-LOGIN
# ─────────────────────────────────────────────────────────────
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat << EOF > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I \$TERM
Type=idle
EOF
systemctl daemon-reload

# ─────────────────────────────────────────────────────────────
# HEADLESS MODE
# ─────────────────────────────────────────────────────────────
systemctl set-default multi-user.target

# ─────────────────────────────────────────────────────────────
# SAMBA CONFIG (IDEMPOTENT)
# ─────────────────────────────────────────────────────────────
chmod 770 /home/$USERNAME

if ! grep -q "^\[home\]" /etc/samba/smb.conf; then
cat << EOF >> /etc/samba/smb.conf

[home]
   path = /home/$USERNAME
   browseable = yes
   writable = yes
   valid users = $USERNAME
   create mask = 0660
   directory mask = 0770
   force user = $USERNAME
   force group = $USERNAME
EOF
fi

if ! pdbedit -L | grep -q "^$USERNAME:"; then
  echo -e "$SAMBA_PASSWORD\n$SAMBA_PASSWORD" | smbpasswd -a -s "$USERNAME"
  smbpasswd -e "$USERNAME"
fi

systemctl enable --now smbd nmbd

# ─────────────────────────────────────────────────────────────
# FILEBROWSER
# ─────────────────────────────────────────────────────────────
if ! command -v filebrowser >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
fi

mkdir -p /srv/filebrowser/data
chown -R $USERNAME:$USERNAME /srv/filebrowser

DB="/srv/filebrowser/data/database.db"

# Initialize config ONCE
if [ ! -f "$DB" ]; then
  filebrowser config init -d "$DB"
fi

# Create admin user ONCE
if ! filebrowser users list -d "$DB" 2>/dev/null | grep -q "^$USERNAME"; then
  filebrowser users add "$USERNAME" "$FILEBROWSER_PASSWORD" --perm.admin -d "$DB"
fi

cat << EOF > /etc/systemd/system/filebrowser.service
[Unit]
Description=File Browser
After=network.target

[Service]
User=$USERNAME
Group=$USERNAME
ExecStart=/usr/local/bin/filebrowser \
  -r /home/$USERNAME \
  -d $DB \
  -p 8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now filebrowser

# ─────────────────────────────────────────────────────────────
# TAILSCALE (ONE-TIME AUTH)
# ─────────────────────────────────────────────────────────────
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if ! tailscale status >/dev/null 2>&1; then
  tailscale up
fi

systemctl enable --now tailscaled

# ─────────────────────────────────────────────────────────────
# NETDATA
# ─────────────────────────────────────────────────────────────
systemctl enable --now netdata

# ─────────────────────────────────────────────────────────────
# XRDP CONFIG (NOT AUTO-STARTED)
# ─────────────────────────────────────────────────────────────
mkdir -p /home/$USERNAME/.config/openbox
cat << EOF > /home/$USERNAME/.xsession
exec openbox-session
tint2 &
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.xsession
chmod 644 /home/$USERNAME/.xsession

# ─────────────────────────────────────────────────────────────
# DONE
# ─────────────────────────────────────────────────────────────
echo "✔ Installation complete"
echo "✔ Log file: $LOGFILE"
echo "✔ Reboot recommended: sudo reboot"
