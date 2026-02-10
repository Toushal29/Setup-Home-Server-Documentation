# Networking & Remote Connectivity

This module defines **how the server is reached** from LAN and outside networks.
This module defines **how the server is reached** and enforces **network-level security**.
The firewall follows a **default-deny** model:

* Everything is blocked by default
* Only explicitly allowed services are reachable

## 1. Tailscale Installation
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

## 2. Status Checks
```bash
systemctl status tailscaled
tailscale status
```

## 3. Cockpit Monitoring Access
* LAN: http://<server-ip>:9090
* Tailscale: http://<tailscale-ip>:9090

Enable Cockpit:
```bash
sudo systemctl enable --now cockpit.socket
```

---
## 4. Network Trust Model
| Network   | Trust Level  | Notes                      |
| --------- | ------------ | -------------------------- |
| Loopback  | Trusted      | Local system processes     |
| Tailscale | Trusted      | Secure remote admin access |
| LAN       | Semi-trusted | Home network devices       |
| Internet  | Untrusted    | No direct access           |

---
## 5. Service Exposure Policy

| Service     | Port | Allowed From            |
| ----------- | ---- | ----------------------- |
| SSH         | e.g - 2222 | Tailscale only          |
| Samba       | 445  | LAN only                |
| Filebrowser | 8080 | Tailscale only          |
| Cockpit     | 9090 | Tailscale only          |
| HTTP        | 80   | LAN / Public (optional) |
| HTTPS       | 443  | LAN / Public (optional) |

---
## 6. Install nftables
```bash
sudo apt install -y nftables
sudo systemctl enable --now nftables
```

---
## 7. nftables Firewall Ruleset
Edit configuration:
```bash
sudo nano /etc/nftables.conf
```

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    # Loopback
    iif lo accept

    # Established connections
    ct state established,related accept

    # ICMP (ping)
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept

    # SSH (Tailscale only)
    iifname "tailscale0" tcp dport 2222 accept

    # Filebrowser (Tailscale only)
    iifname "tailscale0" tcp dport 8080 accept

    # Cockpit (Tailscale only)
    iifname "tailscale0" tcp dport 9090 accept

    # Samba (LAN only)
    ip saddr 192.168.0.0/16 tcp dport 445 accept

    # Web services
    tcp dport {80, 443} accept
  }

  chain forward {
    policy drop;
  }

  chain output {
    policy accept;
  }
}
```

---
## 8. Apply and Verify
```bash
sudo nft -f /etc/nftables.conf
sudo nft list ruleset
```

---
## 9. Safety Checks (IMPORTANT)
Before closing your SSH session:
```bash
ssh -p 2222 <username>@<tailscale-ip>
```

If SSH works over Tailscale, the firewall is safe.

---
## Resulting Security State

* All inbound traffic blocked by default
* SSH reachable only via Tailscale
* Samba restricted to LAN
* Admin interfaces not exposed publicly
