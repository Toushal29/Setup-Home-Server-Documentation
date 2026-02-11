# (from 8_Backups.md)
#!/usr/bin/env bash
set -e

apt install -y rclone

echo "Run 'rclone config' manually to configure cloud."

cat > /home/$USERNAME/backup.sh <<EOF
#!/usr/bin/env bash
rclone sync /home/$USERNAME gdrive_crypt:home \
  --progress \
  --log-file=/var/log/rclone.log \
  --log-level INFO
EOF

chmod +x /home/$USERNAME/backup.sh
