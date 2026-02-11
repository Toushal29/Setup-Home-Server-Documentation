# (from 6_Core_services.md)
#!/usr/bin/env bash
set -e

chmod 770 /home/$USERNAME

if ! grep -q "^\[home\]" /etc/samba/smb.conf; then
cat >> /etc/samba/smb.conf <<EOF

[home]
  path = /home/$USERNAME
  browseable = yes
  writable = yes
  valid users = $USERNAME
  read only = no
  create mask = 0770
  directory mask = 0770
  force user = $USERNAME
  force group = $USERNAME
EOF
fi

echo -e "$SHARED_PASSWORD\n$SHARED_PASSWORD" | smbpasswd -a -s "$USERNAME"
smbpasswd -e "$USERNAME"

systemctl enable --now smbd nmbd

if ! command -v filebrowser >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
fi

mkdir -p /srv/filebrowser/data
chown -R $USERNAME:$USERNAME /srv/filebrowser

DB="/srv/filebrowser/data/database.db"

filebrowser config init -d "$DB" || true
filebrowser users add "$USERNAME" "$SHARED_PASSWORD" --perm.admin -d "$DB" || true

cat > /etc/systemd/system/filebrowser.service <<EOF
[Unit]
Description=File Browser
After=network.target

[Service]
User=$USERNAME
Group=$USERNAME
ExecStart=/usr/local/bin/filebrowser -r /home/$USERNAME -d $DB -p 8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now filebrowser
