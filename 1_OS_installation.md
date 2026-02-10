# Ubuntu Server Home Server Installation Guide

> Current date reference: February 2026  
> Target: Ubuntu Server 24.04.3 LTS

This guide walks you through installing and configuring a lightweight home server on an old laptop (Intel Core i3, 4 GB RAM, 500 GB disk) using **Ubuntu Server**.

## 1. Preparation
1. Download Ubuntu Server ISO
2. Create bootable USB
3. Boot from USB  
   - Enter BIOS/UEFI (usually F2, Del, F10, Esc)
   - Set USB as first boot device
   - Disable Secure Boot if necessary
   - Save & exit → boot into Ubuntu installer

## 2. Ubuntu Server Installation (Guided Installer)

1. Select language → **English** (or preferred)
2. Keyboard layout → choose yours (test typing)
3. **Network connections**  
   - Ethernet: usually auto  
   - Wi-Fi: select network and enter password
4. **Proxy** → leave blank (unless you use one)
5. **Mirror** → choose the closest one or default
6. **Storage configuration**  
   - Choose **Use an entire disk**  
   - Select your 500 GB disk  
   - **Set up this disk as an LVM group?** → **Yes** (recommended)  
   - **Encrypt the LVM group?** → **No** (unless you want full-disk encryption)  
   - Confirm → it creates EFI (~1 GB), root (ext4), and small swap
7. **Profile setup**  
   - Your name: (can be anything)  
   - Server name: `server` (or whatever you like)  
   - Username: `username` (or your preferred username)  
   - Password: choose a strong password
8. **Install OpenSSH server** → **CHECK THIS BOX** (very important!)
9. **Featured Server Snaps** → **leave all unchecked**
10. Confirm and install
11. Reboot and remove USB