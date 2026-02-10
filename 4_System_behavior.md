# System Behavior & Laptop Optimizations
This module controls **how the OS behaves**, especially for a low-RAM laptop server.

## 1. Swapfile (4 GB)
```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

Reduce swappiness:
```bash
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl --system
```

## zram (Compressed RAM)
```bash
sudo apt install -y zram-tools
sudo nano /etc/default/zramswap
```
Set:
```ini
PERCENT=50
```
Restart:
```bash
sudo systemctl restart zramswap
```

## 2. Lid Close – Do Not Suspend
Edit:
```bash
sudo nano /etc/systemd/logind.conf
```
Add:
```ini
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```
Restart Service:
```bash
sudo systemctl restart systemd-logind
```

## 3. Console Auto-login
Edit:
```bash
sudo systemctl edit getty@tty1.service
```
Add:
```ini
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin <username> --noclear %I $TERM
Type=idle
```

```bash
sudo systemctl daemon-reload
```

## 4. Headless Mode
```bash
sudo systemctl set-default multi-user.target
```
Reboot once to confirm.
```bash
reboot
```