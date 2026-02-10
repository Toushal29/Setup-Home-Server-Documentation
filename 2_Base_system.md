# Base System & Core Packages

This module installs the **foundation** required by all other components.

## System Update

```bash
sudo apt update && sudo apt upgrade -y
```

## Core Utilities Install
```bash
sudo apt install -y \
  curl wget git unzip zip tar tree vim nano \
  htop btop net-tools lm-sensors
```

## Core Services & Runtimes Install
```bash
sudo apt install -y \
    nginx \
    samba \
    openssh-server \
    curl wget git \
    unzip zip tar \
    btop \
    lm-sensors \
    zram-tools \
    python3 python3-pip python3-venv \
    nodejs npm \
    golang-go \
    postgresql postgresql-contrib \
    xorg xrdp xorgxrdp \
    xfce4 xfce4-goodies \
    cockpit cockpit-pcp
```