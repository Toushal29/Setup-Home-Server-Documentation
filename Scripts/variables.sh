#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Run as root (sudo)."
  exit 1
fi

read -p "Enter username: " USERNAME
read -p "Enter hostname: " HOSTNAME
read -p "Enter SSH port (default 2222): " SSH_PORT
SSH_PORT=${SSH_PORT:-2222}

read -s -p "Enter password for Samba + Filebrowser: " SHARED_PASSWORD
echo

export USERNAME HOSTNAME SSH_PORT SHARED_PASSWORD
