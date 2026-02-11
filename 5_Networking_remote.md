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
**NOTE**: Port are changed afterwards
| Service     | Port  | Allowed From        |
|-------------|-------|---------------------|
| SSH         | 2222  | LAN + Tailscale     |
| Samba       | 445   | LAN + Tailscale     |
| Filebrowser | 8080  | LAN + Tailscale     |
| Cockpit     | 9090  | LAN + Tailscale     |


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
table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    # Loopback
    iif lo accept

    # Established / Related
    ct state established,related accept

    # ICMP (ping)
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept

    # ------------------------
    # LAN access (adjust subnet!)
    # ------------------------
    ip saddr 192.168.1.0/24 tcp dport {2222, 8080, 9090, 445} accept

    # ------------------------
    # Tailscale access
    # ------------------------
    iifname "tailscale0" tcp dport {2222, 8080, 9090, 445} accept

  }

  chain forward {
    policy drop;
  }

  chain output {
    policy accept;
  }
}
```

## 8. Apply and Verify
```bash
sudo nft -f /etc/nftables.conf
sudo systemctl restart nftables
sudo nft list ruleset
```

---
## 9. Safety Checks (IMPORTANT)
Before closing your SSH session:
```bash
ssh -p <port> <username>@<tailscale-ip>
```

If SSH works over Tailscale, the firewall is safe.

---
## Resulting Security State
* SSH reachable via LAN and Tailscale
* Samba reachable via LAN and Tailscale
* Admin interfaces not exposed to public Internet