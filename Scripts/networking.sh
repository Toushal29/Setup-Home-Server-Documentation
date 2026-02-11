# (from 5_Networking_remote.md)
#!/usr/bin/env bash
set -e

apt install -y nftables

cat > /etc/nftables.conf <<EOF
table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    iif lo accept
    ct state established,related accept
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept

    ip saddr 192.168.1.0/24 tcp dport {$SSH_PORT, 8080, 9090, 445} accept
    iifname "tailscale0" tcp dport {$SSH_PORT, 8080, 9090, 445} accept
  }

  chain forward { policy drop; }
  chain output { policy accept; }
}
EOF

systemctl enable --now nftables

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

tailscale up
