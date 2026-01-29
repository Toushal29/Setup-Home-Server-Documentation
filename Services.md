# Managing Services: Start/Stop/Enable/Disable on Demand
Arch uses systemd, so control is simple and consistent:

- **Check status** of a service:
    - `systemctl status servicename` (e.g., `systemctl status nginx / postgresql`)
- **Start** it now (runs until reboot or you stop it):
    ```bash
    sudo systemctl start nginx
    ```
- **Stop** it now:
    ```bash
    sudo systemctl stop nginx
    ```
- **Enable** auto-start on boot:
    ```bash
    sudo systemctl enable nginx
    ```
- **Disable** auto-start (but doesn't stop if currently running):
    ```bash
    sudo systemctl disable nginx
    ```
- **Restart** (stop + start):
    ```bash
    sudo systemctl restart postgresql
    ```
- **Reload** config without stopping (useful for Nginx):
    ```bash
    sudo systemctl reload nginx
    ```

<br>
<hr>
<br>