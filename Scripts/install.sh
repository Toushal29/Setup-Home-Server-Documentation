#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./variables.sh
source ./base.sh
source ./ssh.sh
source ./system_behavior.sh
source ./networking.sh
source ./services.sh

read -p "Install optional desktop? (y/N): " DESKTOP
if [[ "$DESKTOP" == "y" ]]; then
  source ./optional_desktop.sh
fi

read -p "Setup backups? (y/N): " BACKUPS
if [[ "$BACKUPS" == "y" ]]; then
  source ./backups.sh
fi

echo "Installation complete."
echo "Reboot recommended."
