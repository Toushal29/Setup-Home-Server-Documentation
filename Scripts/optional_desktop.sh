# (from 7_Optional_desktop.md)
#!/usr/bin/env bash
set -e

apt install -y xorg xrdp xorgxrdp xfce4 xfce4-goodies

echo "exec xfce4-session" > /home/$USERNAME/.xsession
chown $USERNAME:$USERNAME /home/$USERNAME/.xsession
chmod 644 /home/$USERNAME/.xsession

systemctl disable xrdp xrdp-sesman || true
systemctl stop xrdp xrdp-sesman || true

systemctl enable xrdp.socket
systemctl start xrdp.socket
