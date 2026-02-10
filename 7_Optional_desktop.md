# Optional Remote Desktop (XRDP + XFCE)

This module is **optional** and can be skipped on fully headless servers.

## 1. Install Desktop Components
```bash
sudo apt install -y xorg xrdp xorgxrdp xfce4 xfce4-goodies
```

## 2. Session Setup
```bash
echo "exec xfce4-session" > ~/.xsession
chmod 644 ~/.xsession
```

## 3. Enable XRDP
```bash
sudo systemctl enable --now xrdp xrdp-sesman
```

## 4. Desktop Tweaks
Disable screen lock:
```bash
xfconf-query -c xfce4-session -p /general/LockCommand -r
```

Disable DPMS blanking:
```bash
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -s false
```

## Notes

* Avoid enabling XRDP on boot if RAM usage is a concern.