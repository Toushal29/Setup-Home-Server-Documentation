# Install + Setup DuckDNS

1. **Sign Up and Get Your Token**
    - Go to https://www.duckdns.org/ in a browser.
    - Log in (use Google, Reddit, GitHub, Twitter/X, or Persona).
    - Create a subdomain (e.g., `toushal-home` → becomes `toushal-home.duckdns.org`).
    - Copy your token

2. **Install DuckDNS Updater (Recommended: AUR `duckdns` package)**<br>
    - This package runs a systemd timer/service to update your IP every ~5-15 minutes automatically.
        ```bash
        yay -S duckdns
        ```
    (If you haven't set up `yay` yet, follow the earlier steps.)

3. **Configure DuckDNS**
    - The `duckdns` AUR package creates config files in `/etc/duckdns/`
    1. Create/edit config for your domain:
        ```bash
        sudo nano /etc/duckdns/<your-subdomain>.conf
        ```
        - Replace `your-subdomain` with yours (e.g., `toushal-home.conf`)
        - Content (minimal example)
        ```text
        token=<token>
        domain=toushal-home
        ipv6=no   # Set to yes if you have IPv6 and want it
        ```
        - `token=` your DuckDNS token
        - `domain=` your subdomain (without .duckdns.org)
        - Save & exit.

    2. Make it readable only by root (security):
        ```bash
        sudo chmod 600 /etc/duckdns/*.conf
        ```

4. **Enable and Start the Updater**
    - The package provides a systemd timer that runs every 5-15 minutes.
        ```bash
        sudo systemctl enable --now duckdns.timer
        ```
    - This starts `duckdns.service` periodically.
    - Check status:
        ```text
        systemctl status duckdns.timer
        journalctl -u duckdns.service -e   # last logs
        ```

    - Test manually:
        ```bash
        sudo /usr/bin/duckdns-update toushal-home   # replace with your domain
        ```
        - It should output "OK" if successful.

5. **Router Port Forwarding (Only if Exposing Services Directly)**
    - Log into your router (usually 192.168.1.1 or similar, admin credentials).
    - Go to Port Forwarding / Virtual Servers / NAT.
    - Forward external ports to your laptop's local IP (find with ip addr show — e.g., 192.168.1.100).
    - Examples (start small):
        - External 443 → Internal 443 (for Nginx HTTPS)
        - External 80 → Internal 80 (HTTP → redirect to HTTPS)
        - For plain WireGuard: External 51820/UDP → Internal 51820/UDP
    - **Do NOT** forward 22, 3389, 445 unless you know exactly what you're doing (use Tailscale instead).

6. **Combine with Your Services**
    - Nginx reverse proxy (safest public exposure):
    - Point DuckDNS to your public IP.
    - In Nginx config (`/etc/nginx/sites-available/<your-site>`), listen on 80/443.
    - Use certbot for free HTTPS:
        ```bash
        sudo pacman -S certbot certbot-nginx
        sudo certbot --nginx -d toushal-home.duckdns.org
        ```
        - Follow prompts → auto-configures HTTPS.

    - **File Browser / Web apps**: Proxy via Nginx (e.g., `location /files { proxy_pass http://localhost:8080; }`).
    - **Tailscale fallback**: Even with DuckDNS, keep Tailscale for secure access (no ports open).
        - Run 
            ```bash
            sudo tailscale up
            ```
            and share the machine via Tailscale admin console.
    - **Plain WireGuard** (if not using Tailscale):
        - Install `wireguard-tools`
        - Generate keys, config WG interface on UDP 51820.
        - Forward 51820/UDP on router.
        - Clients connect to `toushal-home.duckdns.org:51820`


7. **Verify Everything**
    - From phone on mobile data: Visit `https://toushal-home.duckdns.org (after HTTPS setup)`
    - Check IP update: https://www.duckdns.org/update?domains=toushal-home&token=your-token&ip= (should say "OK").
    - Logs: `journalctl -u duckdns.service -f` to watch real-time.