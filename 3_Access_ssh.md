# 02 – Remote Access & SSH Baseline
This module ensures you can **safely access the server remotely** without locking yourself out.

---
## SSH Installation Check
```bash
sudo systemctl is-enabled ssh || sudo systemctl enable --now ssh
```

---
## Initial SSH Configuration (SAFE BASELINE)
Edit the SSH daemon configuration:
```bash
sudo nano /etc/ssh/sshd_config
```
Recommended **initial** baseline:
```ini
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
```

**IMPORTANT**
> Keep `PasswordAuthentication yes` at this stage.
> This guarantees you cannot lock yourself out while hardening SSH.

---
## Validate & Restart SSH
```bash
sudo sshd -t
sudo systemctl restart ssh
```
## Verification
```bash
systemctl status ssh
```

---
# SSH HARDENING (DO THIS IN ORDER)
The steps below **must be followed in sequence**.

---
## 1️⃣ Set Up SSH Key Authentication
### On your client machine (PC/Laptop)
```bash
ssh-keygen -t ed25519 -C "homeserver"
```

Copy the key to the server:
```bash
ssh-copy-id <username>@<server-ip>
```

Test login **without logging out** of your current session:
```bash
ssh <username>@<server-ip>
```

You should be logged in **without entering the server password**.

---
## 2️⃣ Move SSH to a Non-Standard Port

Edit SSH config:
```bash
sudo nano /etc/ssh/sshd_config
```

Add or change:
```ini
Port 2222
```

Apply changes:
```bash
sudo sshd -t
sudo systemctl restart ssh
```

Test from a **new terminal**:
```bash
ssh -p 2222 <username>@<server-ip>
```

---
## 3️⃣ 🚨 FINAL STEP – Disable Password Authentication

❗ **DO NOT DO THIS UNTIL:**
* SSH key login works
* New SSH port works

Edit config:
```bash
sudo nano /etc/ssh/sshd_config
```

Set:
```ini
PasswordAuthentication no
```

Apply:
```bash
sudo sshd -t
sudo systemctl restart ssh
```

### 🔒 Result
* Password logins are disabled
* SSH access is key-only

---
## 4️⃣ Fail2Ban – Brute Force Protection

Install Fail2Ban:
```bash
sudo apt install -y fail2ban
```

Create local jail configuration:
```bash
sudo nano /etc/fail2ban/jail.local
```
Add:
```ini
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = 2222
```

Enable and start:
```bash
sudo systemctl enable --now fail2ban
```

Verify:
```bash
fail2ban-client status
fail2ban-client status sshd
```

---
## Final Security State
* Root login disabled
* Password authentication disabled
* SSH keys required
* Non-standard port in use
* Automatic IP banning enabled