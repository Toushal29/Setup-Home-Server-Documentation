# Optional Remote Desktop (XRDP + XFCE)

This module is OPTIONAL.
If you want a fully headless server, skip this entire file.

This setup:
- Installs a lightweight XFCE desktop
- Uses XRDP for remote access
- Starts XRDP only when a client connects
- Stops XRDP immediately after the last user disconnects
- Minimizes RAM usage on a 4GB system


## 1. Install Desktop Components
```bash
sudo apt install -y xorg xrdp xorgxrdp xfce4 xfce4-goodies
```

## 2. XFCE Session Setup
```bash
echo "exec xfce4-session" > ~/.xsession
chmod 644 ~/.xsession
```

## 3. Enable XRDP Socket Activation (Auto-Start on Connection)
Disable normal service mode:
```bash
sudo systemctl disable xrdp
sudo systemctl disable xrdp-sesman
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman
```

Enable socket activation:
```bash
sudo systemctl enable xrdp.socket
sudo systemctl start xrdp.socket
```

Verify:
```bash
systemctl status xrdp.socket
```

XRDP will now:
- Stay inactive when idle
- Automatically start when an RDP connection is attempted

## 4. Instant Auto-Stop When User Disconnects
Create auto-stop script:
```bash
sudo nano /usr/local/bin/xrdp-autostop.sh
```

Add/Paste:
```bash
#!/usr/bin/env bash
# Count active login sessions
ACTIVE=$(loginctl list-sessions --no-legend | awk '{print $1}' | wc -l)

if [ "$ACTIVE" -eq 0 ]; then
    systemctl stop xrdp
    systemctl stop xrdp-sesman
fi
```

Make executable:
```bash
sudo chmod +x /usr/local/bin/xrdp-autostop.sh
```

## 5. Hook Into PAM Session Close
Edit XRDP PAM config:
```bash
sudo nano /etc/pam.d/xrdp-sesman
```
Add this line at the very bottom:
```Text
session optional pam_exec.so /usr/local/bin/xrdp-autostop.sh
```
Save and exit.


## 4. Desktop Optimizations (Recommended)
Disable screen lock:
```bash
xfconf-query -c xfce4-session -p /general/LockCommand -r
```

Disable DPMS blanking:
```bash
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -s false
```