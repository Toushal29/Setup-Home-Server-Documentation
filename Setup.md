[Jump to `Using Installation Script`](#autoInstall)<br>
[Jump to `Manual Setup`](#manualInstall)<br>

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
 

<a id="autoInstall"></a>

# First Boot & Post-Installation Setup
Log in with your username and password.

# Using installation Script:
## 1. Install git if it's not already there (very small package)
```bash
sudo apt update
sudo apt install git -y
```
## 2. Clone your repo (replace with your actual repo URL)
```bash
git clone https://github.com/Toushal29/Setup-Home-Server-Documentation.git
```
## 3. Go into the folder
```bash
cd Setup-Home-Server-Documentation
```
## 4. (Optional but recommended) Make sure the script is executable
```bash
chmod +x install_script.sh
```
## 5. Run it with sudo
```bash
sudo ./install_script.sh
```

<br><hr><br>

<a id="manualInstall"></a>

# Doing Manually Installation
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
chmod 770 /home/<username>
```

Edit Samba configuration:
```bash
sudo nano /etc/samba/smb.conf
```

Add the following at the end of the file:
```ini
[home]
   path = /home/<username>
   browseable = yes
   writable = yes
   valid users = <username>
   create mask = 0660
   directory mask = 0770
   force user = <username>
   force group = <username>
```

Set Samba password for the user:
```bash
sudo smbpasswd -a <username>
sudo smbpasswd -e <username>           # enable the account
```

Enable and start Samba services:
```bash
sudo systemctl enable --now smbd nmbd
sudo systemctl status smbd nmbd        # Check status
```

**Access from other computers:**
- Windows → \\<server-name>\home :: (example: \\homeserver\home)
- Linux (file manager) → smb://<server-name>/home
- macOS → smb://<server-name>/home



### 2 **File Browser**: Configure as systemd service, default http://<server-ip>:8080.
Download and install
```bash
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
```

Create only the data directory (for the database):
```bash
sudo mkdir -p /srv/filebrowser/data
sudo chown -R <username>:<username> /srv/filebrowser
```

Create admin user (choose a strong password <YOUR_STRONG_PASSWORD_HERE>):
```bash
filebrowser users add <username> <YOUR_STRONG_PASSWORD_HERE> --perm.admin
```

Create the systemd service file:
```bash
sudo nano /etc/systemd/system/filebrowser.service
```

Paste exactly this content:
```ini
[Unit]
Description=File Browser – Home Directory Access
After=network.target

[Service]
User=<username>
Group=<username>
ExecStart=/usr/local/bin/filebrowser -r /home/<username> -d /srv/filebrowser/data/database.db -p 8080 --noauth=false
Restart=always
WorkingDirectory=/home/<username>

[Install]
WantedBy=multi-user.target
```

Apply changes and start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now filebrowser
sudo systemctl status filebrowser         # Check Status
```

**Access**:
- Open in browser: http://<server-ip>:8080 or http://<tailscale-ip>:8080
- Login with:
   - Username: <username>
   - Password: the one you set above

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