# Setting-up-a-Home-Server
Setting up a home server using an old laptop

## The Hardware Details
- Intel(R) Core(TM) i3-5005U CPU @ 2.00GHz
  - configuration: cores=2 enabledcores=2 microcode=47 threads=4
- 4Gb DDR3L @ 1600 MHz (0.6 ns)
- 465GiB (500GB)
> ([Full Hardware Details](#toushalhomeserver))

## The OS
Using Arch Linux (v	2026.01.01) as OS for the server. <br>
Arch is lightweight and does not consume too much resources.

## Purpose
- host web servers,
- host files sharing (samba) via other PCs (Windows/MacOS/Linux),
- host web files sharing (File Browser),
- able to ssh from other PCs (local and non-local),
- able to monitor resources (like using ubuntu web monitoring) -- lightweight, performance monitoring tools,
- able to remote desktop connect from other PCs - xrdp,
- have an on/off gui that is light weight - switching/ turning on/off gui to cli easily so that i can allocate resources when not using gui
- have a development server,
- VPN + Remote access that is secure,
- ads blocking with either pi-hole or adguard home,

## Arch Linux Specific Upgrade
- Use systemd services properly
- Enable zram (huge help with 4 GB RAM)
- Avoid heavy desktops → run headless

## The Hardware Details
- description: Portable Computer
- product: Inspiron 3543 (0654)
- vendor: Dell Inc.
- version: A08
- serial: 5CCVC32
- width: 64 bits
- capabilities: smbios-2.8 dmi-2.8 smp vsyscall32
- configuration: boot=normal chassis=portable sku=0654 uuid=<----->

<hr>
<a id="toushalhomeserver"></a>

#### toushalhomeserver          
    *-core
         description: Motherboard
         product: 0RN98T
         vendor: Dell Inc.
         physical id: 0
         version: A00
         serial: .5CCVC32.CN7620653P008E.
       *-firmware
            description: BIOS
            vendor: Dell Inc.
            physical id: 0
            version: A08
            date: 05/13/2016
            size: 64KiB
            capacity: 8MiB
            capabilities: pci pnp upgrade shadowing cdboot bootselect edd int13floppy1200 int13floppy720 int13floppy2880 int5printscreen int9keyboard int14serial int17printer int10video acpi usb zipboot smartbattery biosbootspecification uefi
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
            capabilities: lm fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb pti ssbd ibrs ibpb stibp tpr_shadow flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx smap intel_pt xsaveopt dtherm arat pln pts vnmi md_clear flush_l1d ibpb_exit_to_user cpufreq
            configuration: cores=2 enabledcores=2 microcode=47 threads=4
          *-cache:0
               description: L1 cache
               physical id: 29
               slot: L1 Cache
               size: 32KiB
               capacity: 32KiB
               capabilities: synchronous internal write-back instruction
               configuration: level=1
          *-cache:1
               description: L2 cache
               physical id: 2a
               slot: L2 Cache
               size: 256KiB
               capacity: 256KiB
               capabilities: synchronous internal write-back unified
               configuration: level=2
          *-cache:2
               description: L3 cache
               physical id: 2b
               slot: L3 Cache
               size: 3MiB
               capacity: 3MiB
               capabilities: synchronous internal write-back unified
               configuration: level=3
       *-cache
            description: L1 cache
            physical id: 28
            slot: L1 Cache
            size: 32KiB
            capacity: 32KiB
            capabilities: synchronous internal write-back data
            configuration: level=1
       *-memory
            description: System Memory
            physical id: 2e
            slot: System board or motherboard
            size: 4GiB
          *-bank
               description: SODIMM DDR3 Synchronous 1600 MHz (0.6 ns)
               product: M471B5173QH0-YK0
               vendor: Samsung
               physical id: 0
               serial: 19EAAD1F
               slot: DIMM_A
               size: 4GiB
               width: 64 bits
               clock: 1600MHz (0.6ns)
       *-pci
            description: Host bridge
            product: Broadwell-U Host Bridge -OPI
            vendor: Intel Corporation
            physical id: 100
            bus info: pci@0000:00:00.0
            version: 09
            width: 32 bits
            clock: 33MHz
            configuration: driver=bdw_uncore
            resources: irq:0
          *-display
               description: VGA compatible controller
               product: HD Graphics 5500
               vendor: Intel Corporation
               physical id: 2
               bus info: pci@0000:00:02.0
               logical name: /dev/fb0
               version: 09
               width: 64 bits
               clock: 33MHz
               capabilities: msi pm vga_controller bus_master cap_list rom fb
               configuration: depth=32 driver=i915 latency=0 resolution=1366,768
               resources: irq:61 memory:a9000000-a9ffffff memory:b0000000-bfffffff ioport:4000(size=64) memory:c0000-dffff
          *-multimedia:0
               description: Audio device
               product: Broadwell-U Audio Controller
               vendor: Intel Corporation
               physical id: 3
               bus info: pci@0000:00:03.0
               logical name: card1
               logical name: /dev/snd/controlC1
               logical name: /dev/snd/hwC1D0
               logical name: /dev/snd/pcmC1D3p
               logical name: /dev/snd/pcmC1D7p
               logical name: /dev/snd/pcmC1D8p
               version: 09
               width: 64 bits
               clock: 33MHz
               capabilities: pm msi pciexpress bus_master cap_list
               configuration: driver=snd_hda_intel latency=0
               resources: irq:62 memory:aa214000-aa217fff
             *-input:0
                  product: HDA Intel HDMI HDMI/DP,pcm=3
                  physical id: 0
                  logical name: input21
                  logical name: /dev/input/event16
             *-input:1
                  product: HDA Intel HDMI HDMI/DP,pcm=7
                  physical id: 1
                  logical name: input22
                  logical name: /dev/input/event17
             *-input:2
                  product: HDA Intel HDMI HDMI/DP,pcm=8
                  physical id: 2
                  logical name: input23
                  logical name: /dev/input/event18
          *-usb:0
               description: USB controller
               product: Wildcat Point-LP USB xHCI Controller
               vendor: Intel Corporation
               physical id: 14
               bus info: pci@0000:00:14.0
               version: 03
               width: 64 bits
               clock: 33MHz
               capabilities: pm msi xhci bus_master cap_list
               configuration: driver=xhci_hcd latency=0
               resources: irq:47 memory:aa200000-aa20ffff
             *-usbhost:0
                  product: xHCI Host Controller
                  vendor: Linux 6.8.0-90-generic xhci-hcd
                  physical id: 0
                  bus info: usb@2
                  logical name: usb2
                  version: 6.08
                  capabilities: usb-2.00
                  configuration: driver=hub slots=11 speed=480Mbit/s
             *-usbhost:1
                  product: xHCI Host Controller
                  vendor: Linux 6.8.0-90-generic xhci-hcd
                  physical id: 1
                  bus info: usb@3
                  logical name: usb3
                  version: 6.08
                  capabilities: usb-3.00
                  configuration: driver=hub slots=4 speed=5000Mbit/s
          *-communication
               description: Communication controller
               product: Wildcat Point-LP MEI Controller #1
               vendor: Intel Corporation
               physical id: 16
               bus info: pci@0000:00:16.0
               version: 03
               width: 64 bits
               clock: 33MHz
               capabilities: pm msi bus_master cap_list
               configuration: driver=mei_me latency=0
               resources: irq:59 memory:aa21c000-aa21c01f
          *-multimedia:1
               description: Audio device
               product: Wildcat Point-LP High Definition Audio Controller
               vendor: Intel Corporation
               physical id: 1b
               bus info: pci@0000:00:1b.0
               logical name: card0
               logical name: /dev/snd/controlC0
               logical name: /dev/snd/hwC0D0
               logical name: /dev/snd/pcmC0D0c
               logical name: /dev/snd/pcmC0D0p
               version: 03
               width: 64 bits
               clock: 33MHz
               capabilities: pm msi bus_master cap_list
               configuration: driver=snd_hda_intel latency=32
               resources: irq:60 memory:aa210000-aa213fff
             *-input
                  product: HDA Intel PCH Headphone Mic
                  physical id: 0
                  logical name: input19
                  logical name: /dev/input/event14
          *-pci:0
               description: PCI bridge
               product: Wildcat Point-LP PCI Express Root Port #1
               vendor: Intel Corporation
               physical id: 1c
               bus info: pci@0000:00:1c.0
               version: e3
               width: 32 bits
               clock: 33MHz
               capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
               configuration: driver=pcieport
               resources: irq:42 ioport:2000(size=4096) memory:a8100000-a82fffff ioport:a8300000(size=2097152)
          *-pci:1
               description: PCI bridge
               product: Wildcat Point-LP PCI Express Root Port #3
               vendor: Intel Corporation
               physical id: 1c.2
               bus info: pci@0000:00:1c.2
               version: e3
               width: 32 bits
               clock: 33MHz
               capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
               configuration: driver=pcieport
               resources: irq:43 memory:aa100000-aa1fffff
             *-network
                  description: Network controller
                  product: BCM43142 802.11b/g/n
                  vendor: Broadcom Inc. and subsidiaries
                  physical id: 0
                  bus info: pci@0000:06:00.0
                  version: 01
                  width: 64 bits
                  clock: 33MHz
                  capabilities: pm msi pciexpress bus_master cap_list
                  configuration: driver=bcma-pci-bridge latency=0
                  resources: irq:18 memory:aa100000-aa107fff
          *-pci:2
               description: PCI bridge
               product: Wildcat Point-LP PCI Express Root Port #4
               vendor: Intel Corporation
               physical id: 1c.3
               bus info: pci@0000:00:1c.3
               version: e3
               width: 32 bits
               clock: 33MHz
               capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
               configuration: driver=pcieport
               resources: irq:44 ioport:3000(size=4096) memory:aa000000-aa0fffff ioport:c0000000(size=1048576)
             *-network
                  description: Ethernet interface
                  product: RTL810xE PCI Express Fast Ethernet controller
                  vendor: Realtek Semiconductor Co., Ltd.
                  physical id: 0
                  bus info: pci@0000:07:00.0
                  logical name: enp7s0
                  version: 07
                  serial: 20:47:47:04:05:c8
                  size: 100Mbit/s
                  capacity: 100Mbit/s
                  width: 64 bits
                  clock: 33MHz
                  capabilities: pm msi pciexpress msix vpd bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd autonegotiation
                  configuration: autonegotiation=on broadcast=yes driver=r8169 driverversion=6.8.0-90-generic duplex=full firmware=rtl8106e-1_0.0.1 06/29/12 ip=192.168.100.78 latency=0 link=yes multicast=yes port=twisted pair speed=100Mbit/s
                  resources: irq:19 ioport:3000(size=256) memory:aa000000-aa000fff memory:c0000000-c0003fff
          *-pci:3
               description: PCI bridge
               product: Wildcat Point-LP PCI Express Root Port #5
               vendor: Intel Corporation
               physical id: 1c.4
               bus info: pci@0000:00:1c.4
               version: e3
               width: 32 bits
               clock: 33MHz
               capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
               configuration: driver=pcieport
               resources: irq:45
          *-usb:1
               description: USB controller
               product: Wildcat Point-LP USB EHCI Controller
               vendor: Intel Corporation
               physical id: 1d
               bus info: pci@0000:00:1d.0
               version: 03
               width: 32 bits
               clock: 33MHz
               capabilities: pm debug ehci bus_master cap_list
               configuration: driver=ehci-pci latency=0
               resources: irq:23 memory:aa21a000-aa21a3ff
             *-usbhost
                  product: EHCI Host Controller
                  vendor: Linux 6.8.0-90-generic ehci_hcd
                  physical id: 1
                  bus info: usb@1
                  logical name: usb1
                  version: 6.08
                  capabilities: usb-2.00
                  configuration: driver=hub slots=2 speed=480Mbit/s
                *-usb
                     description: USB hub
                     product: Integrated Hub
                     vendor: Intel Corp.
                     physical id: 1
                     bus info: usb@1:1
                     version: 0.03
                     capabilities: usb-2.00
                     configuration: driver=hub slots=8 speed=480Mbit/s
                   *-usb:0
                        description: Keyboard
                        product: Compx 2.4G Wireless Receiver
                        vendor: Compx
                        physical id: 3
                        bus info: usb@1:1.3
                        logical name: input10
                        logical name: /dev/input/event7
                        logical name: input11
                        logical name: /dev/input/event8
                        logical name: input12
                        logical name: /dev/input/event9
                        logical name: input13
                        logical name: /dev/input/event10
                        logical name: /dev/input/mouse0
                        logical name: input8
                        logical name: /dev/input/event5
                        logical name: input8::capslock
                        logical name: input8::numlock
                        logical name: input8::scrolllock
                        logical name: input9
                        logical name: /dev/input/event6
                        version: 30.00
                        capabilities: usb-2.00 usb
                        configuration: driver=usbhid maxpower=98mA speed=12Mbit/s
                   *-usb:1
                        description: Video
                        product: Integrated_Webcam_HD
                        vendor: CN0VFVY972487533BAWAA00
                        physical id: 5
                        bus info: usb@1:1.5
                        version: 32.62
                        capabilities: usb-2.00
                        configuration: driver=uvcvideo maxpower=500mA speed=480Mbit/s
                   *-usb:2
                        description: Generic USB device
                        product: BCM43142A0
                        vendor: Broadcom Corp
                        physical id: 6
                        bus info: usb@1:1.6
                        version: 1.12
                        serial: ACD1B8CD6F28
                        capabilities: usb-2.00
                        configuration: driver=btusb speed=12Mbit/s
                   *-usb:3
                        description: MMC Host
                        product: USB2.0-CRW
                        vendor: Generic
                        physical id: 8
                        bus info: usb@1:1.8
                        logical name: mmc0
                        version: 39.60
                        serial: 20100201396000000
                        capabilities: usb-2.00
                        configuration: driver=rtsx_usb maxpower=500mA speed=480Mbit/s
          *-isa
               description: ISA bridge
               product: Wildcat Point-LP LPC Controller
               vendor: Intel Corporation
               physical id: 1f
               bus info: pci@0000:00:1f.0
               version: 03
               width: 32 bits
               clock: 33MHz
               capabilities: isa bus_master cap_list
               configuration: driver=lpc_ich latency=0
               resources: irq:0
             *-pnp00:00
                  product: PnP device PNP0c02
                  physical id: 0
                  capabilities: pnp
                  configuration: driver=system
             *-pnp00:01
                  product: PnP device PNP0b00
                  physical id: 1
                  capabilities: pnp
                  configuration: driver=rtc_cmos
             *-pnp00:02
                  product: PnP device INT3f0d
                  vendor: Interphase Corporation
                  physical id: 2
                  capabilities: pnp
                  configuration: driver=system
             *-pnp00:03
                  product: PnP device PNP0c02
                  physical id: 3
                  capabilities: pnp
                  configuration: driver=system
             *-pnp00:04
                  product: PnP device DLL065a
                  vendor: Dell Inc
                  physical id: 4
                  capabilities: pnp
                  configuration: driver=i8042 aux
             *-pnp00:05
                  product: PnP device PNP0303
                  physical id: 5
                  capabilities: pnp
                  configuration: driver=i8042 kbd
             *-pnp00:06
                  product: PnP device PNP0c02
                  physical id: 6
                  capabilities: pnp
                  configuration: driver=system
             *-pnp00:07
                  product: PnP device PNP0c02
                  physical id: 7
                  capabilities: pnp
                  configuration: driver=system
          *-sata
               description: SATA controller
               product: Wildcat Point-LP SATA Controller [AHCI Mode]
               vendor: Intel Corporation
               physical id: 1f.2
               bus info: pci@0000:00:1f.2
               logical name: scsi0
               logical name: scsi1
               version: 03
               width: 32 bits
               clock: 66MHz
               capabilities: sata msi pm ahci_1.0 bus_master cap_list emulated
               configuration: driver=ahci latency=0
               resources: irq:46 ioport:40b0(size=8) ioport:40a0(size=4) ioport:4090(size=8) ioport:4080(size=4) ioport:4060(size=32) memory:aa219000-aa2197ff
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
                  configuration: ansiversion=5 guid=d432403a-b671-4eeb-9b26-2d5fb7639b13 logicalsectorsize=512 sectorsize=4096
                *-volume:0 UNCLAIMED
                     description: Windows FAT volume
                     vendor: mkfs.fat
                     physical id: 1
                     bus info: scsi@0:0.0.0,1
                     version: FAT32
                     serial: 32f2-4737
                     size: 1073MiB
                     capacity: 1074MiB
                     capabilities: boot fat initialized
                     configuration: FATs=2 filesystem=fat
                *-volume:1
                     description: EXT4 volume
                     vendor: Linux
                     physical id: 2
                     bus info: scsi@0:0.0.0,2
                     logical name: /dev/sda2
                     logical name: /
                     version: 1.0
                     serial: c7c3c453-c192-4bb0-a492-cd4194f95ab5
                     size: 464GiB
                     capabilities: journaled extended_attributes large_files huge_files dir_nlink recover 64bit extents ext4 ext2 initialized
                     configuration: created=2025-11-23 08:53:09 filesystem=ext4 lastmountpoint=/ modified=2026-01-24 11:45:22 mount.fstype=ext4 mount.options=rw,relatime mounted=2026-01-24 11:45:28 state=mounted
             *-cdrom
                  description: DVD-RAM writer
                  product: DVD+-RW DU-8A5LH
                  vendor: PLDS
                  physical id: 1
                  bus info: scsi@1:0.0.0
                  logical name: /dev/cdrom
                  logical name: /dev/sr0
                  version: DD11
                  capabilities: removable audio cd-r cd-rw dvd dvd-r dvd-ram
                  configuration: ansiversion=5 status=nodisc
          *-serial
               description: SMBus
               product: Wildcat Point-LP SMBus Controller
               vendor: Intel Corporation
               physical id: 1f.3
               bus info: pci@0000:00:1f.3
               version: 03
               width: 64 bits
               clock: 33MHz
               configuration: driver=i801_smbus latency=0
               resources: irq:18 memory:aa218000-aa2180ff ioport:4040(size=32)
    *-battery
         description: Lithium Ion Battery
         product: NA
         vendor: NA
         physical id: 1
         version: Not Specified
         serial: Not Specified
         slot: Sys. Battery Bay
    *-input:0
         product: Sleep Button
         physical id: 2
         logical name: input0
         logical name: /dev/input/event0
         capabilities: platform
    *-input:1
         product: Lid Switch
         physical id: 3
         logical name: input1
         logical name: /dev/input/event1
         capabilities: platform
    *-input:2
         product: Synaptics s3203
         physical id: 4
         logical name: input16
         logical name: /dev/input/event11
         logical name: /dev/input/mouse1
         capabilities: i2c
    *-input:3
         product: DELL Wireless hotkeys
         physical id: 5
         logical name: input17
         logical name: /dev/input/event12
         capabilities: platform
    *-input:4
         product: Dell WMI hotkeys
         physical id: 6
         logical name: input18
         logical name: /dev/input/event13
         capabilities: platform
    *-input:5
         product: Power Button
         physical id: 7
         logical name: input2
         logical name: /dev/input/event2
         capabilities: platform
    *-input:6
         product: Video Bus
         physical id: 8
         logical name: input20
         logical name: /dev/input/event15
         capabilities: platform
    *-input:7
         product: Power Button
         physical id: 9
         logical name: input3
         logical name: /dev/input/event3
         capabilities: platform
    *-input:8
         product: AT Translated Set 2 keyboard
         physical id: a
         logical name: input4
         logical name: /dev/input/event4
         logical name: input4::capslock
         logical name: input4::numlock
         logical name: input4::scrolllock
         capabilities: i8042
