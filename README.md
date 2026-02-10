# Setting-up-a-Home-Server
Setting up a home server using an old laptop

## The Hardware Details
- Intel(R) Core(TM) i3-5005U CPU @ 2.00GHz
  - configuration: cores=2 enabledcores=2 microcode=47 threads=4
- 4 Gib DDR3L @ 1600 MHz (0.6 ns)
- 465 GiB (500GiB)
> ([Hardware Details](#hardwareDetail))

## The OS
Using Ubuntu Server 24.04 LTS as OS for the server. <br>
Ubuntu Server is very stable, widely documented, has 5 years of support, and is extremely lightweight when no desktop is installed.

## Purpose
- host web servers,
- host files sharing (samba),
- host web files sharing (File Browser),
- able to ssh from other PCs (local and non-local),
- able to monitor resources (like using ubuntu web monitoring),
- able to access files from other PCs from the file explorer,
- able to remote desktop connect from other PCs - xrdp + xfce,
- have a development server
- VPN + Remote access that is secure,
- a lightweight, performance monitoring tools having the laptop lid close without turning off
- auto login after power cut, no need to insert password, just press the power button and it auto launch the server
- have ports assign to different things
- have virtual Ram support to ease ram usage, even if its slow for some activity

## Ubuntu Server Notes
- Runs headless by default (no GUI installed)
- Uses systemd.
- Prefer `apt`, use `systemctl` the same way


| Feature                     | Software / Tool                    | Notes / Purpose                                                     |
|-----------------------------|------------------------------------|----------------------------------------------------------------------|
| OS                          | Ubuntu Server 24.04 LTS            | Headless, stable, 5+ years support                                  |
| Web server                  | nginx                              | Reverse proxy, hosting small apps                                   |
| LAN File Sharing            | Samba                              | Windows / Linux network shares                                      |
| Web File Access             | File Browser                       | Browser-based file manager (best via Tailscale)                     |
| SSH                         | OpenSSH                            | Secure command-line access                                          |
| Remote Desktop (optional)   | XRDP + XFCE                        | Desktop starts only when someone connects via RDP                   |
| Monitoring                  | Cockpit + btop                     | Web dashboard + terminal resource monitor                            |
| Secure Remote Access (VPN)  | Tailscale                          | Secure, zero-config, works behind NAT                               |
| Development                 | Python, Node.js, Go, PostgreSQL    | Local development and learning environment                           |
| Memory Optimization         | Swapfile + zram                    | Disk swap + compressed RAM for low-memory systems                   |
| Power Optimization          | Lid ignore                         | Laptop-friendly 24/7 operation                                      |
| Utilities                   | curl, wget, git, zip/unzip         | Common system tools                                                  |


**Goals**:
- Headless by default (CLI only)
- File sharing (Samba + File Browser)
- Web server & development (Nginx, Python, Node.js, Go, PostgreSQL)
- Secure remote access (Tailscale)
- Remote desktop access (XRDP + XFCE)
- Monitoring via Cockpit (web) and btop (terminal)
- Laptop lid can be closed without suspending
- Auto-login after power-on / power loss
- Ports assigned per service
- Optimized memory usage using swapfile + zram (4 GB RAM system)


<hr>
<a id="hardwareDetail"></a>

#### Hardware Detail
```text    
*-cpu
     description: CPU
     product: Intel(R) Core(TM) i3-5005U CPU @ 2.00GHz
     vendor: Intel Corp.
     physical id: 2c
     bus info: cpu@0
     version: 6.61.4
     serial: NULL
     slot: SOCKET 0
     size: 1577MHz
     capacity: 2GHz
     width: 64 bits
     clock: 100MHz
     configuration: cores=2 enabledcores=2 microcode=47 threads=4
     
*-memory
     description: System Memory
     physical id: 2e
     slot: System board or motherboard
     description: SODIMM DDR3 Synchronous 1600 MHz (0.6 ns)
     size: 4GiB
     width: 64 bits
     clock: 1600MHz (0.6ns)
*-disk
     description: ATA Disk
     product: TOSHIBA MQ01ABF0
     vendor: Toshiba
     physical id: 0
     bus info: scsi@0:0.0.0
     logical name: /dev/sda
     version: 1D
     serial: 15ULC3PXT
     size: 465GiB (500GB)
     capabilities: gpt-1.00 partitioned partitioned:gpt
```