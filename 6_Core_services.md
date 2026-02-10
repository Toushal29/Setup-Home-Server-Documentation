# Core Server Services

This module configures the **main functional services** provided by the server.

---

## 1. Samba (LAN File Sharing)
This module configures the **main functional services** provided by the server.<br>
All services run as **native systemd services**
### Permissions
```bash
sudo chmod 755 /home
sudo chmod 770 /home/<username>
sudo chown -R <username>:<username> /home/<username>
```
Configuration:
```bash
sudo nano /etc/samba/smb.conf
```
Add:
```ini
[home]
  path = /home
  browseable = yes
  writable = yes
  valid users = <username>
  read only = no
  create mask = 0770
  directory mask = 0770
  force user = <username>
  force group = <username>
```
Enable Samba:
```bash
sudo smbpasswd -a <username>
sudo smbpasswd -e <username>
sudo systemctl enable --now smbd nmbd
```
Access:
  - Windows: \\<server-name>\home
  - Linux: smb://<server-name>/home
  - macOS: smb://<server-name>/home

## 2. File Browser
File Browser provides web-based access to the user’s home directory.
Install
```bash
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
sudo mkdir -p /srv/filebrowser/data
sudo chown -R <username>:<username> /srv/filebrowser
```
Create Admin User
```bash
filebrowser users add <username> <STRONG_PASSWORD> --perm.admin
```
systemd Service
```bash
sudo nano /etc/systemd/system/filebrowser.service
```
Add:
```ini
[Unit]
Description=File Browser – User Home Directory
After=network.target

[Service]
User=<username>
Group=<username>
ExecStart=/usr/local/bin/filebrowser -r /home/<username> -d /srv/filebrowser/data/database.db -p 8080
Restart=always

[Install]
WantedBy=multi-user.target
```
Enable
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now filebrowser
```
Access
  - Tailscale: http://<tailscale-ip>:8080
  - LAN (if allowed): http://<server-ip>:8080