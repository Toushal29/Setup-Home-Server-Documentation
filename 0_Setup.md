# Execution Order

Follow the modules in this order:
1. `1_OS_installation.md`
2. `2_Base_system.md`
3. `3_Access_ssh.md`
4. `4_System_behavior.md`
5. `5_Networking_remote.md`
6. `6_Core_services.md`
7. `7_Optional_desktop.md`
8. `8_Backups.md`

You may follow the steps manually or automate them later using an install script.

## Using the Installation Script (optional)

```bash
sudo apt update
sudo apt install git -y
git clone https://github.com/Toushal29/Setup-Home-Server-Documentation.git
cd Setup-Home-Server-Documentation
chmod +x install_script.sh
sudo ./install_script.sh
```