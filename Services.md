[Jump to All Commands](#servicesCommands)<br>
[1. SSH Commands](#sshServices)<br>
[2. Tailscale Commands](#tailscaleServices)<br>
[3. Netdata Commands](#netdataServices)<br>
[4. Samba Commands](#sambaServices)<br>
[5. FileBrowser Commands](#filebrowserServices)<br>
[6. Nginx Commands](#nginxServices)<br>
[7. PostgreSQL Commands](#postgreServices)<br>
[8. XRDP Commands](#xrdpServices)<br>

# Managing Services: Start / Stop / Enable / Disable / Reload / Status

This document explains how to control **all services** installed and/or configured on your Ubuntu Server 24.04 home server setup.

Ubuntu uses **systemd** to manage services. The commands below apply to every service listed.

## General systemd Commands

Replace `servicename` with the actual service name (examples: `netdata`, `smbd`, `nginx`, etc.).

| Action                              | Command                                           | Notes                                                                 |
|-------------------------------------|---------------------------------------------------|-----------------------------------------------------------------------|
| Check current status                | `systemctl status servicename`                    | Shows running/enabled state + recent logs                             |
| Start service (until reboot)        | `sudo systemctl start servicename`                |                                                                       |
| Stop service                        | `sudo systemctl stop servicename`                 |                                                                       |
| Enable auto-start on boot           | `sudo systemctl enable servicename`               | Does **not** start it now unless you use `--now`                      |
| Enable + start now                  | `sudo systemctl enable --now servicename`         | Most common way to activate a service permanently                     |
| Disable auto-start on boot          | `sudo systemctl disable servicename`              | Does **not** stop it if currently running                             |
| Disable + stop now                  | `sudo systemctl disable --now servicename`        |                                                                       |
| Restart service                     | `sudo systemctl restart servicename`              | Stop + start – useful after config changes                            |
| Reload configuration (if supported) | `sudo systemctl reload servicename`               | Only some services support reload (nginx, netdata, smbd, etc.)        |
| Check if service is enabled         | `systemctl is-enabled servicename`                | Returns: `enabled`, `disabled`, `static`, etc.                        |
| List all running services           | `systemctl list-units --type=service --state=running` | Quick overview                                             |

**View detailed logs**  
```bash
journalctl -u servicename              # all logs
journalctl -u servicename -e           # last lines (most recent)
journalctl -u servicename -f           # follow live logs
```

<a id="servicesCommands"></a>

## **24/7 Services – Quick Enable All** <a id="enableAllServices"></a>
```bash
sudo systemctl enable --now ssh
sudo systemctl enable --now netdata
sudo systemctl enable --now smbd nmbd
sudo systemctl enable --now filebrowser

# Tailscale is usually enabled via:
sudo tailscale up
# Check: systemctl is-enabled tailscaled
```

## **Service-Specific Commands**
### 1. SSH Commands : (Service: ssh or sshd) <a id="sshServices"></a>
```bash
# Check status
systemctl status ssh
# Start
sudo systemctl start ssh
# Stop (This locks you out if connected remotely)
sudo systemctl stop ssh
# Enable (auto-start):
sudo systemctl enable --now ssh
# Disable (Not Recommended)
sudo systemctl disable --now ssh
# Restart
sudo systemctl restart ssh
```

### 2. Tailscale Commands : (Service: tailscaled) <a id="tailscaleServices"></a>
```bash
# Check status
systemctl status tailscaled
# Start (or sudo tailscale up to connect).
sudo systemctl start tailscaled
# Stop (or sudo tailscale down to disconnect).
sudo systemctl stop tailscaled
# Enable (confirm with systemctl is-enabled tailscaled)
sudo tailscale up
# Disable (Also run sudo tailscale down).
sudo systemctl disable --now tailscaled
# Restart
sudo systemctl restart tailscaled
```

### 3. Samba Commands : (Services: smbd and nmbd) <a id="sambaServices"></a>
```bash
# Check status
systemctl status smbd
systemctl status nmbd
# Start
sudo systemctl start smbd nmbd
# Stop
sudo systemctl stop smbd nmbd
# Enable (Auto-enable)
sudo systemctl enable --now smbd nmbd
# Disable
sudo systemctl disable --now smbd nmbd
# Restart
sudo systemctl restart smbd nmbd
# Reload (for config changes to /etc/samba/smb.conf; nmbd doesn't support reload—use restart)
sudo systemctl reload smbd
```

### 4. File Browser Commands : (Service: filebrowser) <a id="filebrowserServices"></a>
```bash
# Check status
systemctl status filebrowser
# Start
sudo systemctl start filebrowser
# Stop
sudo systemctl stop filebrowser
# Enable (Auto-enable)
sudo systemctl enable --now filebrowser
# Disable
sudo systemctl disable --now filebrowser
# Restart
sudo systemctl restart filebrowser
# Reload (Custom service file at /etc/systemd/system/filebrowser.service. Reload systemd after edits)
sudo systemctl daemon-reload
```

### 5. Nginx Commands <a id="nginxServices"></a>
```bash
# Check status
systemctl status nginx
# Start
sudo systemctl start nginx
# Stop
sudo systemctl stop nginx
# Enable (Auto-enable = Only if hosting 24/7; otherwise avoid)
sudo systemctl enable --now nginx
# Disable
sudo systemctl disable --now nginx
# Restart
sudo systemctl restart nginx
# Reload (Preferred for config changes to /etc/nginx/nginx.conf or sites-enabled files)
sudo systemctl reload nginx
```

### 6. PostgreSQL Commands : (Service: postgresql or postgresql@16-main on Ubuntu 24.04) <a id="postgreServices"></a>
- **Note**: Version-specific (16); use `postgresql` for general commands.
```bash
# Check status
systemctl status postgresql
# Start
sudo systemctl start postgresql
# Stop
sudo systemctl stop postgresql
# Enable (Auto-enable = Only if hosting 24/7; otherwise avoid)
sudo systemctl enable --now postgresql
# Disable
sudo systemctl disable --now postgresql
# Restart
sudo systemctl restart postgresql
# Reload (for some config changes; see docs for details)
sudo systemctl reload postgresql
```

### 7. XRDP Commands : (Services: xrdp and xrdp-sesman) <a id="xrdpServices"></a>
```bash
# Check status
systemctl status xrdp
systemctl status xrdp-sesman
# Start
sudo systemctl start xrdp xrdp-sesman
# Stop
sudo systemctl stop xrdp xrdp-sesman
# Enable (Auto-enable = Avoid; start manually to save RAM.)
sudo systemctl enable --now xrdp xrdp-sesman
# Disable
sudo systemctl disable --now xrdp xrdp-sesman
# Restart
sudo systemctl restart xrdp xrdp-sesman
```