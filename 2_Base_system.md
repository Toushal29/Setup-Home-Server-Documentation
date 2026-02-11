# Base System & Core Packages

This module installs the **foundation** required by all other components.

## System Update

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```

## Core Utilities Install
```bash
sudo apt install -y \
  curl wget git unzip zip tar tree \
  vim nano htop btop net-tools \
  lm-sensors ca-certificates gnupg
```

## Core Services & Runtimes Install
```bash
sudo apt install -y \
    nginx \
    samba \
    openssh-server \
    zram-tools \
    python3 python3-pip python3-venv \
    nodejs npm \
    golang-go \
    postgresql postgresql-contrib \
    cockpit cockpit-pcp
```

## Disable PostgreSQL + Nginx by Default
Turn OFF:
```bash
sudo systemctl disable nginx
sudo systemctl disable postgresql
sudo systemctl stop nginx
sudo systemctl stop postgresql
```
Turn ON when needed:
```bash
sudo systemctl start nginx
sudo systemctl start postgresql
```