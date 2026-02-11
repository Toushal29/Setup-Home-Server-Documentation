# (based on 2_Base_system.md)
#!/usr/bin/env bash
set -e

apt update && apt upgrade -y
apt autoremove -y

apt install -y \
  curl wget git unzip zip tar tree \
  vim nano htop btop net-tools \
  lm-sensors ca-certificates gnupg \
  samba openssh-server zram-tools \
  python3 python3-pip python3-venv \
  nodejs npm golang-go \
  postgresql postgresql-contrib \
  nginx cockpit cockpit-pcp nftables

systemctl disable nginx postgresql
systemctl stop nginx postgresql

hostnamectl set-hostname "$HOSTNAME"
