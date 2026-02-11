# (based on 3_Access_ssh.md)
#!/usr/bin/env bash
set -e

cat > /etc/ssh/sshd_config.d/custom.conf <<EOF
Port $SSH_PORT
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
EOF

sshd -t
systemctl enable --now ssh
systemctl restart ssh

apt install -y fail2ban

cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = $SSH_PORT
EOF

systemctl enable --now fail2ban
