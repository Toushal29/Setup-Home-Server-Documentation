> [Jump to Post-Install Setup](#post-install) <br>
> [Jump to Essential Tweeks](#essential-tweeks)

# Setup the OS

1. **Boot from USB** <br>
    - Insert USB
    - Boot From USB
2. **Live Environment Setup (Before archinstall)**<br>
    - Setup Keyboard layout if needed
    - Connect internet:
        - Ethernet: Usually auto.
        - WiFi: Use `iwctl`:
            ```bash
            iwctl
            device list  # note wlan0 or similar
            station wlan0 scan
            station wlan0 get-networks
            station wlan0 connect "YourSSID"  # enter password when prompted
            exit
            ping archlinux.org  # test
            ```
    - Update archinstall script for latest: `pacman -Sy archinstall`
3. **Installation with archinstall**<br>
    Run: 
    ```bash
    archinstall
    ```
    - **Language**: English (or preferred).
    - **Keyboard layout**: us (or your country — test typing).
    - **Mirror region**: Mauritius or "Worldwide" (or closest).
    - **Disk configuration**:
        - Select your disk (/dev/sda or /dev/nvme0n1 — check `lsblk` if unsure).
        - Choose "Erase disk" > "Best-effort" (auto-partitions: EFI ~1GB FAT32, root ext4, swap auto-detected/created ~4-8GB).
        - Filesystem: ext4 (simple, reliable).
        - Confirm wipe — no going back!
    - **Profile**: Select **minimal** (installs base + linux + linux-firmware + utils; no desktop).
    - **Additional packages**: Enter space-separated list (these are official repos, install now for ease):
    ```text
    openssh sudo networkmanager nginx postgresql python python-pip nodejs npm go tmux netdata btop curl wget tar unzip zip samba base-devel git xorg-server openbox xterm
    ```
    - **Audio**: None (headless server).
    - **Kernel**: linux (or linux-lts for better stability on old hardware).
    - **Network configuration**: "Copy ISO network configuration" (copies your live Wi-Fi if set up) or configure manually later.
    - **Hostname**: e.g., homeserver or arch-server.
    - **User accounts**:
        - Create user: yourusername (e.g., toushal)
        - Password: set strong one
        - Add to groups: wheel (for sudo)
        - Sudo: Yes (enables sudo for user)

    - **Root password**: Leave blank (disables root login — use sudo instead, safer).
    - **Bootloader**: systemd-boot (recommended for UEFI laptops) or GRUB.

<br>
<hr>

<a id="post-install"></a>

## First Boot & Post-Install Setup
1. Boot into new system — login as youruser (password you set).
2. Update system:
    ```bash
    sudo pacman -Syu
    ```
3. Install AUR helper (yay) for filebrowser/xrdp:
    ```bash
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    ```
4. Install AUR packages:
    ```bash
    yay -S filebrowser xrdp xorgxrdp tailscale
    ```
5. Enable core services (start now & boot):
    ```bash
    sudo systemctl enable --now NetworkManager sshd netdata smb nmb tailscale
    sudo systemctl enable xrdp xrdp-sesman  # for XRDP later
    ```
    - NetworkManager:
        - Handles Wi-Fi/Ethernet.
        - Connect Wi-Fi: `nmcli device wifi connect "SSID" password "pass"`
    - Tailscale: For secure remote access (run `sudo tailscale up` later, login via browser).
6. Reboot: `sudo reboot` (to apply).

<br>
<hr>

<a id="essential-tweeks"></a>

## Essential Tweaks for Your Setup
1. **Swapfile for 4GB RAM** (4GB swap)
    ```bash
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
    echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
    sudo sysctl --system
    ```
2. **Lid close: don't suspend:**
    ```bash
    sudo nano /etc/systemd/logind.conf
    ```

    Uncomment/set:
    ```text
    HandleLidSwitch=ignore
    HandleLidSwitchDocked=ignore
    ```
    Then: `sudo systemctl restart systemd-logind`
3. **Console auto-login** (no password after power on/boot):
    ```bash
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sudo nano /etc/systemd/system/getty@tty1.service.d/autologin.conf
    ```
    Add:
    ```text
    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin <yourusername> --noclear %I $TERM
    ```
4. **Headless by default (no GUI boot) + toggle**
    ```bash
    sudo systemctl set-default multi-user.target  # headless CLI
    ```
    ***NOTE***
    - To enable GUI temporarily:
        ```bash
        sudo systemctl set-default graphical.target
        ```
        or
        ```bash
        sudo systemctl isolate graphical.target
        ```
        without reboot
    - Revert: back to multi-user.target.
5. **XRDP + Openbox** (remote desktop when GUI enabled):
    - Already installed/enabled.
    - Create `~/.xinitrc`: `echo "exec openbox-session" > ~/.xinitrc`
    - Connect via RDP client to IP:3389 (only when graphical.target active).
6. **Monitoring**
    - netdata: http://localhost:19999 (or remote via Tailscale).
        - Check `Monitoring.md` since some old laptop need sensors services
    - btop: run `btop` in terminal.
7. **Other services**
    - Samba: Edit `/etc/samba/smb.conf` for shares, add user `sudo smbpasswd -a <yourusername>`
    - File Browser: Configure as systemd service (see AUR page), default http://IP:8080.
    - Nginx: Config virtual hosts for dev apps / File Browser proxy.
    - PostgreSQL: 
        ```bash
        sudo -u postgres initdb --locale en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
        ```
        then start/enable.
    - Tailscale/DuckDNS:
        ```bash
        sudo tailscale up
        ```
        (auth), or set DuckDNS cron for plain WireGuard.
    - SSH: Edit `/etc/ssh/sshd_config` (Port 22 or change), allow in nftables if needed.