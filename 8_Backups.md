# Encrypted Backups (rclone + Cloud)

This module sets up **encrypted, automated off-site backups**.

## 1. Install rclone

```bash
sudo apt install -y rclone
```

## 2. Configure Cloud Remote

```bash
rclone config
```

* Create a new remote (example: `gdrive`)
* Choose your cloud provider (Google Drive recommended)
* Authenticate via browser

## 3. Create Encrypted Remote

```bash
rclone config
```

* New remote: `gdrive_crypt`
* Type: `crypt`
* Remote path: `gdrive:/homeserver`
* Encrypt file names: yes
* Encrypt directory names: yes

## 4. Backup Script

```bash
nano ~/backup.sh
```

```bash
#!/usr/bin/env bash
rclone sync /home/<username> gdrive_crypt:home \
  --progress \
  --log-file=/var/log/rclone.log \
  --log-level INFO
```

```bash
chmod +x ~/backup.sh
```

## 5. Schedule Nightly Backup

```bash
crontab -e
```

```cron
0 2 * * * /home/<username>/backup.sh
```

## 6. Restore Example

```bash
rclone sync gdrive_crypt:home /home/<username>
```

## Notes

* Backups are encrypted end-to-end.
* Test restore at least once after setup.