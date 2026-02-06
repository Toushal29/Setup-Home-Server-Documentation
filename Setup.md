| Feature                     | Software / Tool              | Notes / Purpose                                          |
|-----------------------------|------------------------------|----------------------------------------------------------|
| OS                          | Ubuntu Server 24.04 LTS      | Headless, stable, 5+ years support                       |
| Web server                  | nginx                        | Reverse proxy, hosting small apps                        |
| LAN File Sharing            | Samba                        | Windows / Linux network shares                           |
| Web File Access             | File Browser                 | Browser-based file manager (best via Tailscale)          |
| SSH                         | OpenSSH                      | Secure command-line access                               |
| Remote Desktop (optional)   | XRDP + Openbox               | Only starts when someone connects via RDP                |
| Monitoring                  | netdata + btop               | Web dashboard + terminal resource monitor                |
| Secure Remote Access (VPN)  | Tailscale (recommended)      | Easiest, secure, zero-config, works behind NAT           |
| Alternative VPN             | WireGuard                    | Manual setup if you prefer no third-party service        |
| Development                 | Python 3, Node.js, Go, PostgreSQL | Local development and learning environment          |
| Utilities                   | curl, wget, git, zip/unzip   | Common tools                                             |
 

## First Boot & Post-Installation Setup
Log in with your username and password.

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install basic utilities + SSH
sudo apt install -y \ curl wget git unzip zip htop btop net-tools lm-sensors vim nano tree openssh-server
```

**See `Monitoring.md` for installing `lm-sensors`**
<hr>

## **SSH hardening**: To access by SSH from other PCs early
```bash
sudo nano /etc/ssh/sshd_config
```
Add:
```text
# Change port if you want extra obscurity (optional)
# Port 2222

PermitRootLogin no
PasswordAuthentication yes          # ← keep yes for now
PubkeyAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
```
**Important:** Do **NOT** set `PasswordAuthentication no` — that would disable password login completely.

Then Validate and Restart:
```bash
# Validate config syntax
sudo sshd -t

# Apply
sudo systemctl restart ssh
```

Check if service is running:
```bash
# Usually already enabled – just confirm
sudo systemctl is-enabled ssh && echo "SSH is enabled" || sudo systemctl enable --now ssh
```
<hr>

## Core & utilities Installation *After First Boot & Post-Install Setup*
```bash
# Update packages lists and installed packages
sudo apt update && sudo apt upgrade -y
```

```bash
# Installed packages that is needed
sudo apt install -y \
    nginx               \
    samba               \
    netdata             \
    btop                \
    curl wget git       \
    unzip zip tar       \
    python3 python3-pip python3-venv \
    nodejs npm          \
    golang-go           \
    postgresql postgresql-contrib \
    xorg xrdp xorgxrdp  \
    openbox xterm obconf tint2
```


## 1. Essential Tweaks for Your Setup
### 1. **Swapfile for 4GB RAM** (4GB swap)
```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Reduce swappiness
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl --system
```

### 2. **Lid close: don't suspend:**
```bash
sudo nano /etc/systemd/logind.conf
```

Uncomment/set:

```ini
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

Then Apply changes + restart service:
```bash
sudo systemctl restart systemd-logind`
```

### 3. **Console auto-login** (no password after power on/boot)
```bash
sudo systemctl edit getty@tty1.service
```

Add / replace with:
```ini
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin <username> --noclear %I $TERM
Type=idle
```

Then apply + reload:
```bash
sudo systemctl daemon-reload
```

### 4. **Set headless mode (CLI only – run once)**
```bash
sudo systemctl set-default multi-user.target
```

## 5. **Monitoring**
Install `lm-sensors` if not already done (important for old laptops since they need sensors services)

Check `Monitoring.md` on how to install `lm-sensors`

- **netdata**: real-time monitoring dashboard || See [Netdata service setup](#netdataService) for service setup.
   - http://localhost:19999 (or access remotely via Tailscale IP:19999)<br>
- **btop**: terminal-based resource monitor
   - Just run `btop` in terminal.


## 2. **Other services**
### 1. **Samba**:
```bash
mkdir -p /home/toushal/files
sudo chown toushal:toushal /home/toushal/files
chmod 770 /home/toushal/files
```

Then edit Samba config:
```bash
sudo nano /etc/samba/smb.conf
```

Then Add at the end:
```text
[files]
   path = /home/toushal/files
   browseable = yes
   writable = yes
   valid users = toushal           # only this user
   create mask = 0660
   directory mask = 0770
   force user = toushal
   force group = toushal
```

Then Set Samba password:
```bash
sudo smbpasswd -a toushal
sudo smbpasswd -e toushal           # enable the account
```

Enable & start (runs 24/7):
```bash
sudo systemctl enable --now smbd nmbd
```

Verify:
```bash
sudo systemctl status smbd nmbd
```

Access: <br>
Windows: `\\homeserver\files` <br>
Linux: `smb://homeserver/files`

### 2 **File Browser**: Configure as systemd service, default http://<server-ip>:8080.
Download and install
```bash
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
```

Create Directory
```bash
sudo mkdir -p /srv/filebrowser/{data,files}
sudo chown -R toushal:toushal /srv/filebrowser
```

Setup admin user + password
```bash
# Replace YOUR_PASSWORD_HERE with your real password (the same one you use for login).
filebrowser users add toushal <YOUR_PASSWORD_HERE> --perm.admin
```

Create a systemd service
```bash
sudo nano /etc/systemd/system/filebrowser.service
```
Add:
```ini
[Unit]
Description=File Browser – authenticated
After=network.target

[Service]
User=toushal
Group=toushal
ExecStart=/usr/local/bin/filebrowser -r /srv/filebrowser/files -d /srv/filebrowser/data/database.db -p 8080 --noauth=false
Restart=always
WorkingDirectory=/home/toushal

[Install]
WantedBy=multi-user.target
```

Then Restart and Enable
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now filebrowser
```

Verify
```bash
sudo systemctl status filebrowser
```

### 3. Tailscale
```bash
# Download and install
curl -fsSL https://tailscale.com/install.sh | sh
```
After Install, authenticate and connect
```bash
# Activate and run tailscale
sudo tailscale up
```

Check Status:
```bash
sudo systemctl status tailscaled
tailscale status
```

<a id="netdataService"></a>

### 4. Netdata
Access: http://<server-ip>:19999  or via Tailscale IP:19999
```bash
sudo systemctl enable --now netdata
```

## 3. For XRDP + Openbox (lightweight remote desktop)
#### 1. Create minimal Openbox session for the user who will connect via RDP
```bash
mkdir -p ~/.config/openbox
echo "exec openbox-session" > ~/.xsession
```

#### 2. Optional: add very lightweight panel
```bash
echo "tint2 &" >> ~/.xsession
```

#### 3. Make the file readable
```bash
chmod 644 ~/.xsession
```

#### **4 . IMPORTANT: Start XRDP (recommended: manual start only)**
```bash
# Option A: Start XRDP manually when you want to allow connections (recommended for lowest resource usage)
sudo systemctl start xrdp xrdp-sesman
```

```bash
# Option B: Let XRDP start automatically on boot (small overhead, more convenient)
sudo systemctl enable xrdp xrdp-sesman
```