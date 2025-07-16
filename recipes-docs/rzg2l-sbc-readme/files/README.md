# RZG2L SBC board #
This is the quick startup guide for RZG2L SBC board (hereinafter referred to as `RZG2L-SBC`).
The below will describe the current status of development, how to build, set up environment for RZG2L-SBC.

## Status
This is a system release of the RZG2L development product for RZG2L-SBC

This release provides the following features:

 - Yocto (Styhead) build compatible with RZG2L SoC
 - RZG2L-SBC Linux BSP functionalities (customized with upstream kernel 6.10)
 - Codec libraries supported
 - 40 IO expansion interface supported
 - On-board Wireless Modules enabled (only support for Wi-Fi)
 - On-board Audio Codec with Stereo Jack Analog Audio IO
 - Generic USB Bluetooth framework supported
 - MIPI DSI enabled
 - MIPI CSI-2 enabled
 - Bootloader with U-Boot Fastboot UDP enabled.

Known issues:

 - Only support for 48 Khz audio sampling rate family.

## Building

### Prepare build environment
Step 1: Prepare environment for building package

Linux Ubuntu 24.04 is recommended for Yocto build.
Before starting the build, run the command below on the Linux Host PC to install packages to be used.
```
$ sudo apt-get update
$ sudo apt-get install build-essential chrpath cpio debianutils diffstat file \
gawk gcc git iputils-ping libacl1 liblz4-tool locales python3 python3-git \
python3-jinja2 python3-pexpect python3-pip python3-subunit socat texinfo unzip \
wget xz-utils zstd
```

Run the below commands to set the user name and email address before starting the build procedure.
```
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```

Step 2: Prepare the local build environment

After preparing the host machine for building, download necessary packages (get them from Renesas website):
- Codec: https://www.renesas.com/us/en/document/swo/rz-mpu-video-codec-library-evaluation-version-rzg2l-rtk0ef0045z15001zj-v110xxzip?r=1535641

Then create a workspace folder (example: `~/renesas/rz-cmn-srp`) for the build and put the files `rzsbc_builder.sh`, `site.conf`, `README.md`, `jq-linux-amd64`, `images.json` and a patch folder for eSDK build support from the release package into it.
```
$ mkdir ~/renesas/rz-cmn-srp
$ cp *.zip ~/renesas/rz-cmn-srp
$ cp README.md ~/renesas/rz-cmn-srp
$ cp rzsbc_builder.sh ~/renesas/rz-cmn-srp
$ cp site.conf ~/renesas/rz-cmn-srp
$ cp jq-linux-amd64 ~/renesas/rz-cmn-srp
$ cp git_patch.json ~/renesas/rz-cmn-srp
$ cp images.json ~/renesas/rz-cmn-srp
$ cp -r patches/ ~/renesas/rz-cmn-srp
$ cp -r files_to_add/ ~/renesas/rz-cmn-srp
```

### Build Host Resource Configuration

Building certain recipes or the overall Yocto image can be resource-intensive for the build host (in terms of CPU and memory). To contribute to a stable and efficient build process and to assist in preventing Out-Of-Memory (OOM) conditions, configuration of BitBake's resource pressure monitoring is available.

BitBake utilizes **Linux Kernel's Pressure Stall Information (PSI)**, which provides insights into CPU, I/O, and Memory resource contention. PSI data is exposed via `/proc/pressure` and is supported in Linux kernels from version 4.20 onwards. If resource pressure exceeds configured thresholds, BitBake's scheduler may pause the initiation of new tasks, which can assist in preventing system unresponsiveness or Out-Of-Memory (OOM) conditions.

The following variables can be set in the `conf/local.conf` file to control BitBake's behavior under resource pressure:

* `BB_PRESSURE_MAX_CPU`: Configures the maximum tolerable CPU pressure threshold.
* `BB_PRESSURE_MAX_MEMORY`: Configures the maximum tolerable Memory pressure threshold.
* `BB_PRESSURE_MAX_IO`: *(Optional)* Configures the maximum tolerable I/O pressure threshold.

**Operation:**

The values assigned to these variables are expressed in internal "pressure units," which are not direct measurements (e.g., MiB/GiB). They represent the difference in "total" pressure from the preceding second. If the actual resource pressure on the build host surpasses the configured threshold, BitBake's scheduler is designed to temporarily suspend the commencement of new tasks until the pressure alleviates.

#### Suggested Default Pressure Thresholds

Based on Yocto Project documentation ([BitBake User Manual - Reference Variables](https://github.com/yoctoproject/poky/blob/master/bitbake/doc/bitbake-user-manual/bitbake-user-manual-ref-variables.rst)), the following values are used as initial configurations, intended to balance build execution speed with the stability of the build host:

```bash
# In conf/local.conf
BB_PRESSURE_MAX_MEMORY = "100000"
#BB_PRESSURE_MAX_CPU = "15000"
#BB_PRESSURE_MAX_IO = "15000" # May be included for disk-intensive builds
```

In the default `local.conf` configuration provided with this project, `BB_PRESSURE_MAX_MEMORY` is enabled with a value of "100000". `BB_PRESSURE_MAX_CPU` and `BB_PRESSURE_MAX_IO` are commented out by default.

**Note**: To enable or adjust any of these resource pressure variables, modify the corresponding lines in the `conf/local.conf` file by uncommenting them (if necessary) and setting the desired values. Please adjust these values as needed based on your specific build host and workload requirements.

### Build package

Build the package by executing the following commands:
```
$ cd ~/renesas/rz-cmn-srp
$ IMAGE=<target_image> ./rzsbc_builder.sh build
```

<target_image>: the target Yocto build image. It can be one from the following table of supported images

| Target Image               | Description                                                                                 |
|----------------------------|---------------------------------------------------------------------------------------------|
| core-image-minimal         |  A basic image that contains the minimal set of components required to boot the device. It focuses on essential system functions without extra tools or features. |
| core-image-bsp             | Extends core-image-minimal with additional utilities and tools, providing a lightweight environment for system validation, hardware diagnostics, and basic development|
| core-image-weston          | A standard graphical image with Wayland and Weston support for embedded GUI applications.|
| renesas-core-image-cli     | Based on core-image-bsp, this image offers a CLI environment for Renesas hardware development without graphical interfaces.Besides the useful tools inherited from the core-image-bsp, this image also containsnew packages for SBC (Single Board Computer) development. For example,package managers (apt, dpgk), network utilities for Bluetooth, Wi-Fi. |
| renesas-core-image-weston  | Renesas customized core image based on the core-image-weston, with Qt5 framework support (no QT demo apps included). This image offers a full graphical environment for Renesas hardware development and all the useful tools from the renesas-core-image-cli.      |
| renesas-quickboot-cli      | This image has the same system functionality as the renesas-core-image-cli but with Quickboot enabled, allowing for faster boot times and efficient system validation on a CLI environment.|
| renesas-quickboot-wayland  | This image has the same system functionality as the renesas-core-image-weston but with Quickboot enabled, allowing for faster boot times and efficient system validation on a graphical environment              |
| renesas-ubuntu | Ubuntu-based image built on top of the ubuntu-tiny Yocto distro, ideal for embedded development. It includes core support for Wayland, X11, OpenGL, and Qt5, but does not include full development tools or environments. This image is not meant to be used as a Yocto rootfs, but rather as a foundation for pure Ubuntu-based systems that depend on Yocto-generated artifacts.|

**Note:**

**(1) Please note that this build requires internet access and will take several hours.**

**(2) If `IMAGE` is not set in the build command. The default image is `renesas-core-image-weston`.**

Step 4: Collect the output

After building Yocto, the output folder should be `~/renesas/rz-cmn-srp/yocto_rzsbc_board/build/tmp/deploy/images/rzg2l-sbc`

The output folder outline:
```
rzg2l-sbc/
├── host
│   ├── build
│   │   ├── core-image-bsp-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-bsp-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── core-image-bsp-rzg2l-sbc.manifest -> core-image-bsp-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-bsp-rzg2l-sbc.testdata.json -> core-image-bsp-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── core-image-minimal-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-minimal-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── core-image-minimal-rzg2l-sbc.manifest -> core-image-minimal-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-minimal-rzg2l-sbc.testdata.json -> core-image-minimal-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── core-image-weston-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-weston-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── core-image-weston-rzg2l-sbc.manifest -> core-image-weston-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── core-image-weston-rzg2l-sbc.testdata.json -> core-image-weston-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-core-image-cli-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-core-image-cli-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-core-image-cli-rzg2l-sbc.manifest -> renesas-core-image-cli-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-core-image-cli-rzg2l-sbc.testdata.json -> renesas-core-image-cli-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-core-image-weston-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-core-image-weston-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-core-image-weston-rzg2l-sbc.manifest -> renesas-core-image-weston-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-core-image-weston-rzg2l-sbc.testdata.json -> renesas-core-image-weston-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-quickboot-cli-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-quickboot-cli-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-quickboot-cli-rzg2l-sbc.manifest -> renesas-quickboot-cli-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-quickboot-cli-rzg2l-sbc.testdata.json -> renesas-quickboot-cli-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-quickboot-wayland-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   ├── renesas-quickboot-wayland-rzg2l-sbc-<timestamp>.testdata.json
│   │   ├── renesas-quickboot-wayland-rzg2l-sbc.manifest -> renesas-quickboot-wayland-rzg2l-sbc-<timestamp>.rootfs.manifest
│   │   └── renesas-quickboot-wayland-rzg2l-sbc.testdata.json -> renesas-quickboot-wayland-rzg2l-sbc-<timestamp>.testdata.json
│   ├── env
│   │   ├── core-image-bsp.env
│   │   ├── core-image-minimal.env
│   │   ├── core-image-weston.env
│   │   ├── Readme.md
│   │   ├── renesas-core-image-cli.env
│   │   ├── renesas-core-image-weston.env
│   │   ├── renesas-quickboot-cli.env
│   │   └── renesas-quickboot-wayland.env
│   ├── Readme.md
│   ├── src
│   │   └── rz-cmn-srp
│   │       ├── files_to_add
│   │       │   └── meta-rz-features
│   │       │       ├── 0001-rzg2l-sbc-Bring-compat_alloc_user_space-back.patch
│   │       │       └── 0004-rzg2l-sbc-Get-interrupt-number.patch
│   │       ├── git_patch.json
│   │       ├── images.json
│   │       ├── jq-linux-amd64
│   │       ├── patches
│   │       │   ├── meta-rz-features
│   │       │   │   └── 0001-support-codec-for-linux-6.10-and-yocto-styhead.patch
│   │       │   └── meta-summit-radio
│   │       │       ├── 0001-rz-sbc-meta-summit-radio-Support-build-in-yocto-styh.patch
│   │       │       └── 0002-rz-sbc-summit-radio-support-eSDK-build.patch
│   │       ├── README.md
│   │       ├── rzsbc_builder.sh
│   │       ├── site.conf                                <----- Optional
│   │       └── ubuntu
│   │           ├── config
│   │           │   ├── ubuntu_core
│   │           │   │   ├── network_interfaces.conf
│   │           │   │   ├── NetworkManager.conf
│   │           │   │   └── resolved.conf
│   │           │   └── ubuntu_lxde
│   │           │       ├── connman-gtk.desktop
│   │           │       ├── interfaces
│   │           │       ├── lightdm.conf
│   │           │       ├── NetworkManager.conf
│   │           │       ├── panel
│   │           │       ├── rsyslog
│   │           │       ├── ttyS0.conf
│   │           │       └── v4l2-init.sh
│   │           ├── config.ini
│   │           ├── docs
│   │           │   ├── ubuntu_core
│   │           │   │   └── README.md
│   │           │   └── ubuntu_lxde
│   │           │       ├── Pictures
│   │           │       │   ├── audacity.png
│   │           │       │   ├── bluetooth_0.png
│   │           │       │   ├── bluetooth_1.png
│   │           │       │   ├── bluetooth_2.png
│   │           │       │   ├── bluetooth_3.png
│   │           │       │   ├── bluetooth_4.png
│   │           │       │   ├── csi_0.png
│   │           │       │   ├── csi_1.png
│   │           │       │   ├── csi_2.png
│   │           │       │   ├── eth_1.png
│   │           │       │   ├── eth_2.png
│   │           │       │   ├── eth_3.png
│   │           │       │   ├── eth_4.png
│   │           │       │   ├── eth_5.png
│   │           │       │   ├── eth.png
│   │           │       │   ├── save_audio_0.png
│   │           │       │   ├── save_audio_1.png
│   │           │       │   ├── save_audio_2.png
│   │           │       │   ├── vlc_open_0.png
│   │           │       │   ├── vlc_open_1.png
│   │           │       │   ├── vlc_open_2.png
│   │           │       │   ├── vlc.png
│   │           │       │   ├── vlc_video_1.png
│   │           │       │   ├── vlc_video.png
│   │           │       │   ├── web_1.png
│   │           │       │   ├── web_2.png
│   │           │       │   ├── web_lxterm_htop.png
│   │           │       │   ├── web.png
│   │           │       │   └── wifi_0.png
│   │           │       └── README.md
│   │           ├── include
│   │           │   ├── common
│   │           │   │   ├── allow_empty_password.sh
│   │           │   │   ├── create_wic.sh
│   │           │   │   ├── install_gstreamer.sh
│   │           │   │   ├── install_weston.sh
│   │           │   │   ├── mount.sh
│   │           │   │   ├── prepare_env_rootfs.sh
│   │           │   │   ├── prepare_env.sh
│   │           │   │   ├── prepare_ubuntu_base.sh
│   │           │   │   └── yocto_working.sh
│   │           │   ├── ubuntu_core
│   │           │   │   ├── prepare_conf.sh
│   │           │   │   ├── prepare_env.sh
│   │           │   │   ├── prepare_rootfs_qt.sh
│   │           │   │   └── setup_dns.sh
│   │           │   └── ubuntu_lxde
│   │           │       ├── create_swap.sh
│   │           │       ├── prepare_conf.sh
│   │           │       └── prepare_rootfs_qt.sh
│   │           ├── README.md
│   │           ├── script
│   │           │   ├── common
│   │           │   │   ├── dpkg-install-lock-fix.sh
│   │           │   │   └── setup_dns_and_time.sh
│   │           │   ├── ubuntu_core
│   │           │   │   ├── apt_install_base.sh
│   │           │   │   ├── link_to_leagcy_iptables.sh
│   │           │   │   └── set_root_password.sh
│   │           │   └── ubuntu_lxde
│   │           │       ├── apt_audio_video.sh
│   │           │       ├── apt_blueman.sh
│   │           │       ├── apt_install_base.sh
│   │           │       ├── apt_lxde_desktop.sh
│   │           │       ├── apt_wifi_ble.sh
│   │           │       ├── create_user.sh
│   │           │       ├── set_root_password.sh
│   │           │       ├── set_swap_enable.sh
│   │           │       └── setup-set-permissions.sh
│   │           └── setup_ubuntu_environment.sh
│   └── tools
│       ├── bootloader-flasher
│       │   ├── linux
│       │   │   ├── bootloader_flash.py
│       │   │   └── Readme.md
│       │   ├── Readme.md
│       │   └── windows
│       │       ├── config.ini
│       │       ├── flash_bootloader.bat
│       │       ├── Readme.md
│       │       └── tools
│       │           ├── cygterm.cfg
│       │           ├── flash_bootloader.ttl
│       │           ├── TERATERM.INI
│       │           ├── ttermpro.exe
│       │           ├── ttpcmn.dll
│       │           ├── ttpfile.dll
│       │           ├── ttpmacro.exe
│       │           ├── ttpset.dll
│       │           └── ttxssh.dll
│       ├── Readme.md
│       ├── sd-creator
│       │   ├── linux
│       │   │   ├── Readme.md
│       │   │   └── sd_flash.sh
│       │   ├── Readme.md
│       │   └── windows
│       │       ├── config.ini
│       │       ├── flash_filesystem.bat
│       │       ├── Readme.md
│       │       └── tools
│       │           ├── AdbWinApi.dll
│       │           ├── cygterm.cfg
│       │           ├── fastboot.bat
│       │           ├── fastboot.exe
│       │           ├── flash_system_image.ttl
│       │           ├── TERATERM.INI
│       │           ├── ttermpro.exe
│       │           ├── ttpcmn.dll
│       │           ├── ttpfile.dll
│       │           ├── ttpmacro.exe
│       │           ├── ttpset.dll
│       │           └── ttxssh.dll
│       └── uload-bootloader
│           ├── linux
│           │   ├── Readme.md
│           │   └── uload_bootloader_flash.py
│           ├── Readme.md
│           └── windows
│               ├── config.ini
│               ├── Readme.md
│               ├── tools
│               │   ├── cygterm.cfg
│               │   ├── TERATERM.INI
│               │   ├── ttermpro.exe
│               │   ├── ttpcmn.dll
│               │   ├── ttpfile.dll
│               │   ├── ttpmacro.exe
│               │   ├── ttpset.dll
│               │   ├── ttxssh.dll
│               │   └── uload-flash_bootloader.ttl
│               └── uload-flash_bootloader.bat
├── license
│   └── Disclaimer051.pdf
├── <xxxxxx>-rz-srp-<yocto-version>-um.pdf          # <xxxxxx> is a placeholder for the internal tracking code, <yocto-version> represents the specific Yocto Project version used (e.g., "yocto3", "yocto5", etc.)
├── <xxxxxx>-rz-srp-<yocto-version>-um-quick-start-guide.pdf   # <xxxxxx> is a placeholder for the internal tracking code, <yocto-version> represents the specific Yocto Project version used (e.g., "yocto3", "yocto5", etc.)
├── README.md
├── RZ_System_Release_Package_Evaluation_license.pdf
└── target
    ├── env
    │   ├── Readme.md
    │   └── uEnv.txt
    ├── images
    │   ├── bl2_bp-rzg2l-sbc.bin
    │   ├── bl2_bp-rzg2l-sbc.srec
    │   ├── bl2-rzg2l-sbc.bin
    │   ├── core-image-bsp-rzg2l-sbc.wic
    │   ├── core-image-minimal-rzg2l-sbc.wic
    │   ├── core-image-weston-rzg2l-sbc.wic
    │   ├── dtbs
    │   │   ├── overlays
    │   │   │   ├── Readme.md
    │   │   │   ├── rzg2l-sbc-can.dtbo
    │   │   │   ├── rzg2l-sbc-dsi.dtbo
    │   │   │   ├── rzg2l-sbc-ext-i2c.dtbo
    │   │   │   ├── rzg2l-sbc-ext-spi.dtbo
    │   │   │   └── rzg2l-sbc-ov5640.dtbo
    │   │   ├── Readme.md
    │   │   ├── rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.dtbo
    │   │   └── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.dtbo
    │   ├── fip-rzg2l-sbc.bin
    │   ├── fip-rzg2l-sbc.srec
    │   ├── Flash_Writer_SCIF_rzg2l-sbc.mot
    │   ├── Flash_Writer_SCIF_rzg2l-sbc_PMIC.mot
    │   ├── Image -> Image--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.bin
    │   ├── Image--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.bin
    │   ├── Readme.md
    │   ├── renesas-core-image-cli-rzg2l-sbc.wic
    │   ├── renesas-core-image-weston-rzg2l-sbc.wic
    │   ├── renesas-quickboot-cli-rzg2l-sbc.wic
    │   ├── renesas-quickboot-wayland-rzg2l-sbc.wic
    │   └── rootfs
    │       ├── core-image-bsp-rzg2l-sbc.tar.bz2
    │       ├── core-image-minimal-rzg2l-sbc.tar.bz2
    │       ├── core-image-weston-rzg2l-sbc.tar.bz2
    │       ├── Readme.md
    │       ├── renesas-core-image-cli-rzg2l-sbc.tar.bz2
    │       ├── renesas-core-image-weston-rzg2l-sbc.tar.bz2
    │       ├── renesas-quickboot-cli-rzg2l-sbc.tar.bz2
    │       ├── renesas-quickboot-wayland-rzg2l-sbc.tar.bz2
    │       └── renesas-ubuntu-rzg2l-sbc.tar.bz2
    └── Readme.md

44 directories, 209 files
```

### eSDK

The extensible SDK makes it easy to add new applications and libraries to an image, modify the source for an existing component, test changes on RZ/G2L-SBC, and ease integration into the rest of the OpenEmbedded Build System.

The eSDK build generates an installer, which you will use to install the eSDK on the same PC where your Yocto environment is set up.

Running the build script with the following option to build eSDK:

```shell
$ IMAGE=<target_image> ./rzsbc_builder.sh build-sdk
```

For example:

```shell
$ IMAGE=renesas-core-image-weston ./rzsbc_builder.sh build-sdk
```

The resulting eSDK installer will be located in `~/renesas/rz-cmn-srp/yocto_rzsbc_board/build/tmp/deploy/sdk`.
The eSDK installer will have the extension “.sh”.

```shell
$ ls
poky-glibc-x86_64-renesas-core-image-weston-cortexa55-rzg2l-sbc-toolchain-ext-5.1.4.sh
poky-glibc-x86_64-renesas-core-image-weston-cortexa55-rzg2l-sbc-toolchain-ext-5.1.4.host.manifest
poky-glibc-x86_64-renesas-core-image-weston-cortexa55-rzg2l-sbc-toolchain-ext-5.1.4.testdata.json
poky-glibc-x86_64-renesas-core-image-weston-cortexa55-rzg2l-sbc-toolchain-ext-5.1.4.target.manifest
```

**Note:**
**(1) The SDK build may fail depending on the build environment. At that time, please run the build again after a period of time.**

**(2) The SDK result of the `ls` command is built using the target image `IMAGE=renesas-core-image-weston`. Other SDKs will be located in the same location `~/renesas/rz-cmn-srp/yocto_rzsbc_board/build/tmp/deploy/sdk` but will have different names according to the target image.**

#### Install eSDK on your host machine

The eSDK allows you to develop and test custom applications for RZG2L-SBC on different systems. This section covers setting up your development environment and with the setup, you can develop your applications that run on RZG2L-SBC.

```shell
$ sh ./build/tmp/deploy/sdk/poky-glibc-x86_64-renesas-core-image-weston-cortexa55-rzg2l-sbc-toolchain-ext-5.1.4.sh
```

Everytime you want to build your applications, run the environment setup script first (`~/esdk/5.1.4` is the location that the eSDK is installed):

```shell
$ source ~/esdk/5.1.4/environment-setup-cortexa55-poky-linux
```

## Programming/Flashing images for RZG2L-SBC

### Flash Bootloader on Linux

To flash the bootloader on a Linux system, use the script `bootloader_flash.py` located in the Yocto build output directory:

```
host/tools/bootloader-flasher/linux/
```

This script is generated as part of the Yocto build process.

To see usage instructions and available options, run:

```
$ ./bootloader_flash.py -h
```

**Before performing a flashing, make sure the board is powered off, connect the debug serial (SCIF0 - TXD,RXD,GND) to your Linux PC and change switches to enter SCIF download mode**

### Flash Bootloader on Windows

Same as Flash Bootloader on Linux, we prepare some suppport scripts for flashing bootloader on Windows.

Please get folder `host/tools/bootloader-flasher/windows/` from Yocto build output folder. Then refer to `Readme.md` file to know how to use the scripts.

### Flash Bootloader on U-Boot console

In case users want to update Bootloader without touching the hardware setup. We support a method to flash Bootloader on U-Boot console.

Please get folder `host/tools/uload-bootloader/` from Yocto build output folder. Then refer to `Readme.md` file to know the flashing procedure.

### Prepare image and rootfs in microSD card on Linux

Before booting the RZG2L-SBC system, you need to flash the root filesystem image onto a microSD card.

A support script named `sd_flash.sh` is provided for this purpose. You can find the script in the Yocto build output directory:

```
host/tools/sd-creator/linux/
```
Please run the follow command to know how to use the script:

```
$ ./sd_flash.sh
```

After executing SD card flashing script successfully. In U-boot console, running the below command and make sure the result is the same:

```test
=> ext4ls mmc 0:2
<DIR>       4096 .
<DIR>       4096 ..
<DIR>       4096 bin
<DIR>       4096 boot
<DIR>       4096 dev
<DIR>       4096 etc
<DIR>       4096 home
<DIR>       4096 lib
<DIR>       4096 lib64
<DIR>       4096 media
<DIR>       4096 mnt
<DIR>       4096 proc
<DIR>       4096 run
<DIR>       4096 sbin
<DIR>       4096 sys
<DIR>       4096 tmp
<DIR>       4096 usr
<DIR>       4096 var
```

### Prepare image and rootfs in microSD card on Windows

Same as Linux, we prepare some suppport scripts on Windows for preparing image and rootfs in microSD card.

Please get folder `host/tools/sd-creator/windows/` from Yocto build output folder. Then refer to `README.md` file to know how to use the scripts.

### U-boot environment

In U-Boot console, execute one more command to bring RZG2L-SBC system up:

```
=> boot
```
## Confirm supported features on RZG2L-SBC

### 40 IO expansion interface settings

The RZ/G2L-SBC features a versatile 40-pin IO Expansion Interface that supports various communication protocols and functions. This interface can be configured for:

- I2C: Channels 0 and 3
- SPI: Channel 0
- SCIF: Channel 0
- CAN: Channels 0 and 1
- GPIO: Pin-function (default setting)

By default, I2C Channel 0 and SCIF Channel 0 are enabled. However, you can easily reconfigure the interface to use other channels and functions using FDT overlays.

#### Understanding FDT Overlays and uEnv.txt

The RZ/G2L-SBC uses FDT (Flattened Device Tree) overlays to manage the configuration of its IO expansion interface. These overlays are enabled by setting specific environment variables in the `uEnv.txt` file.

The `uEnv.txt` file is located in partition 1 of the SD card.

The following table details the available configuration options that can be set in uEnv.txt:

```
## For RZ SBC U-Boot Env
/------------------------------|--------------|------------------------------
|       Config                 | Value if set |     To be loading
|------------------------------|--------------|------------------------------
| enable_overlay_i2c           | '1' or 'yes' |  rzg2l-sbc-ext-i2c.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_spi           | '1' or 'yes' |  rzg2l-sbc-ext-spi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_can           | '1' or 'yes' |  rzg2l-sbc-can.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_dsi           | '1' or 'yes' |  rzg2l-sbc-dsi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_csi_ov5640    | '1' or 'yes' |  rzg2l-sbc-ov5640.dtbo
|----------------------------------------------------------------------------
| fdtfile   : is a base dtb file, should be set rzg2l-sbc.dtb
|----------------------------------------------------------------------------
| uboot env : you could set U-Boot's environment variables here, such as 'console=' 'bootargs='
\---------------------------------------------------------------------------

default settings:
    fdtfile=rzg2l-sbc.dtb
    #enable_overlay_i2c=1
    #enable_overlay_spi=1
    #enable_overlay_can=1
    #enable_overlay_dsi=1
    #enable_overlay_csi_ov5640=1

(Note: Lines starting with # are commented out and not active.)
```

#### How to Edit uEnv.txt

The `uEnv.txt` file can be edited using two primary methods:

- On Windows

Mount the SD card on a Windows computer. The `uEnv.txt` file should be accessible for direct editing as it resides in the first partition, typically formatted as FAT32.

- On Linux

When working within a Linux environment (e.g., via SSH or serial console on the RZG2L-SBC), the SD card's first partition can be mounted and the file edited:


You can refer to the `Readme.md` file in partition 1 for the FDT overlays information.
You can mount the sdcard on Windows to edit the uEnv.txt or do it on linux as below

Step 1: Mount the partition
```shell
root@rzg2l-sbc:~# mount /dev/mmcblk2p1 /tmp
root@rzg2l-sbc:/tmp# ls uEnv.txt
uEnv.txt
root@rzg2l-sbc:/tmp# nano uEnv.txt
```

After modifying `uEnv.txt`, save the file and umount the partition:

```shell
root@rzg2l-sbc:/tmp# cd ~
root@rzg2l-sbc:~# umount /tmp
root@rzg2l-sbc:~# sync
```

After changing the value of overlays options, we need to run `sync` to ensure that the changes are affected. Then, execute `reboot` to apply the changes.

For further details on FDT overlays and advanced configurations, refer to the `Readme.md` file located in partition 1 of the SD card.

The below section shows how to configure for each GPIO function:

#### Configuring GPIO Pins

To set the state of a GPIO pin, use the `gpioset` command with the following syntax:

```shell
gpioset -c <chip> <pin> = <value>
```

- chip: Specifies the GPIO chip (e.g., gpiochip0).
- pin: Refers to the specific GPIO pin number on that chip.
- value: Sets the pin state (0 for low, 1 for high).

Examples:

To set GPIO pin 0 on gpiochip0 to a low state:

```
root@rzg2l-sbc:~# gpioset -c gpiochip0 0=0
```

To set GPIO pin 0 on gpiochip0 to a high state:

```shell
root@rzg2l-sbc:~# gpioset -c gpiochip0 0=1
```

#### I2C function (channel 3 - RIIC3)

You should edit `uEnv.txt` as follows to enable I2C channel 3 on 40 IO expansion interface:

```
enable_overlay_i2c=1
```

To check the I2C channel 3 is enabled or not, run the following command and check the result:

```
root@rzg2l-sbc:~# i2cdetect -l
i2c-3   i2c             Renesas RIIC adapter                    I2C adapter
i2c-1   i2c             Renesas RIIC adapter                    I2C adapter
i2c-4   i2c             i2c-1-mux (chan_id 0)                   I2C adapter
i2c-0   i2c             Renesas RIIC adapter                    I2C adapter
root@rzg2l-sbc:~#
```

You can also check devices existance on I2C bus by running the following command:

```
root@rzg2l-sbc:~# i2cdetect -y -r 3
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

#### SPI function (channel 0 - RSPI0)

You should edit `uEnv.txt` as follows to enable SPI channel 0 on 40 IO expansion interface:

```
enable_overlay_spi=1
```

Run the following command to config the SPI:

```
root@rzg2l-sbc:~# spi-config -d /dev/spidev0.0 -q
/dev/spidev0.0: mode=0, lsb=0, bits=8, speed=2000000, spiready=0
```

Connect Pin 19 (RSPI0 MOSI) to Pin 21 (RSPI0 MISO), then run the below command and check the result:

```
root@rzg2l-sbc:~# echo -n -e "1234567890" | spi-pipe -d /dev/spidev0.0 -s 10000000 | hexdump
0000000 3231 3433 3635 3837 3039
000000a
```

#### CAN function (channel 0,1 - CAN0, CAN1)

You should edit `uEnv.txt` as follows to enable CAN channel 0,1 on 40 IO expansion interface:

```
enable_overlay_can=1
```

To check the CAN channels are enabled or not, run the following command and check the result:

```
root@rzg2l-sbc:~# ip a | grep can
3: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can
4: can1: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can
root@rzg2l-sbc:~#
```

Then set up for CAN devices. Now you can up/down or send data from CAN channels.

The below shows the communication between two CAN channels.
```
root@rzg2l-sbc:~# ip link set can0 down
root@rzg2l-sbc:~# ip link set can0 type can bitrate 500000
root@rzg2l-sbc:~# ip link set can0 up
[   48.120419] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
root@rzg2l-sbc:~# ip link set can1 down
root@rzg2l-sbc:~# ip link set can1 type can bitrate 500000
root@rzg2l-sbc:~# ip link set can1 up
[   69.906039] IPv6: ADDRCONF(NETDEV_CHANGE): can1: link becomes ready
root@rzg2l-sbc:~# candump can0 & cansend can1 123#01020304050607
[1] 271
  can0  123   [7]  01 02 03 04 05 06 07
root@rzg2l-sbc:~# candump can1 & cansend can0 123#01020304050607
[2] 273
  can0  123   [7]  01 02 03 04 05 06 07
  can1  123   [7]  01 02 03 04 05 06 07
root@rzg2l-sbc:~#
```

### On-board Wi-Fi Modules configurations

RZG2L-SBC has an on-board Wireless modules on it. Currently, we only support for Wi-Fi feature in this release.

To settings for Wi-Fi on RZG2L-SBC, run the following commands:

```
root@rzg2l-sbc:~# connmanctl
connmanctl> enable wifi
Enabled wifi
connmanctl> agent on
Agent registered
connmanctl> scan wifi
Scan completed for wifi
connmanctl> services
    xDredme10zW          wifi_0025ca329da3_78447265646d6531307a57_managed_psk
                         wifi_0025ca329da3_hidden_managed_psk
    REL-GLOBAL           wifi_0025ca329da3_52454c2d474c4f42414c_managed_ieee8021x
    R-GUEST              wifi_0025ca329da3_522d4755455354_managed_none
    RVC-WLS              wifi_0025ca329da3_5256432d574c53_managed_ieee8021x
connmanctl> connect wifi_0025ca329da3_78447265646d6531307a57_managed_psk
Agent RequestInput wifi_0025ca329da3_78447265646d6531307a57_managed_psk
  Passphrase = [ Type=psk, Requirement=mandatory ]
Passphrase? nFjey48aT9pk
connmanctl> exit
```

To confirm the Wi-Fi is connected, ping to the outside world:

```
root@rzg2l-sbc:~# ping www.google.com
PING www.google.com(hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004)) 56 data bytes
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=1 ttl=57 time=43.2 ms
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=2 ttl=57 time=81.1 ms
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=3 ttl=57 time=124 ms
```

**Please note that before using Wi-Fi feature on RZG2L-SBC, the ethernet connections need to be down.**

```
root@rzg2l-sbc:~# ifconfig eth0 down
root@rzg2l-sbc:~# ifconfig eth1 down
```

### On-board Audio Codec with Stereo Jack Analog Audio IO configurations

The RZ/G2L-SBC features an onboard audio codec, Renesas DA7219, enabling audio playback and recording through a 3.5mm stereo jack (connector J8, 6-pin).
- Audio Data Interface: Connected to DAI (SSI1) using the I2S format.
- Control Interface: Managed via I2C0.
- Headset Jack: Marked J8 on the board.

Audio playback and recording are supported through ALSA tools with PCM WAV files. For other formats such as MP3, the pre-installed GStreamer framework provides compatibility.

Prepare the required audio files and place them in the target directory before executing the following commands. Example commands are shown below:

```
root@rzg2l-sbc:~# aplay /home/root/audios/04_16KH_2ch_bgm_maoudamashii_healing01.wav
root@rzg2l-sbc:~# gst-play-1.0 /home/root/audios/COMMON6_MPEG2_L3_24KHZ_160_2.mp3
```

`aplay` command supports `wav` format audio files

`gst-play-1.0` command supports `wav`, `mp3` and `aac` formats

To perform a recording, run the following command to record audio to an `audio_capture.wav` file:

```
root@rzg2l-sbc:~# arecord -f S16_LE -r 48000 audio_capture.wav
```

Press Ctrl+C if you want to stop recording.

In the above command:

-f S16_LE : audio format

-r 48000  : sample rate of the audio file (48KHz)

To verify the recorded file, you can play it by the following command:

```
root@rzg2l-sbc:~# aplay audio_capture.wav
```

To adjust the level of the audio record/playback, use the following command to open the ALSA mixer GUI:

```
root@rzg2l-sbc:~# alsamixer
```

### MIPI DSI with display panels

RZG2L-SBC supports the MIPI DSI interface and the Waveshare 5 inch Touchscreen Monitor MIPI-DSI LCD is enabled and tested.

You should edit `uEnv.txt` as follows to enable MIPI DSI interface with the panel supported:

```
enable_overlay_dsi=1
```

**Please note that selecting the MIPI DSI display will cause the HDMI display be disabled.**

### Playing Video Files on RZ/G2L-SBC

Use `gst-launch-1.0` to play video files. The playbin element in GStreamer makes it easy to play multimedia content. Prepare an mp4 file and run the following command:

```
root@rzg2l-sbc:~# gst-launch-1.0 playbin uri=file:///<path/to/your/video/path>
```

We have prepared some test videos in the /home/root/videos folder. You can use these for testing. For example:

```
root@rzg2l-sbc:~# gst-launch-1.0 playbin uri=file:///home/root/videos/renesas-bigideasforeveryspace.mp4
```

### MIPI CSI2 with Arducam 5MP MIPI Camera

RZG2L-SBC supports the MIPI CSI-2 camera interface and the Arducam 5MP MIPI Camera (OV5640 image sensor) is enabled and tested.

You should edit `uEnv.txt` as follows to enable MIPI CSI-2 interface with the camera supported:

```
enable_overlay_csi_ov5640=1
```
To use the camera, we need to enable the CSI-2 module. Run the following commands:

```
root@rzg2l-sbc:~# cd /home/root/
root@rzg2l-sbc:~# ./v4l2-init.sh <resolution>
```

The <resolution> argument specifies the resolution for the camera. Valid resolutions are:

- 720x480
- 720x576
- 1024x768
- 1280x720
- 1920x1080
- 2592x1944

If no resolution is specified or an invalid resolution is provided, the default resolution 1280x720 will be used. For example:

When use a valid resolution:

```
root@rzg2l-sbc:~# ./v4l2-init.sh 1920x1080
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_1X16 and resolution 1920x1080
```

When no resolution is specified:

```
root@rzg2l-sbc:~# ./v4l2-init.sh
No resolution specified. Using default resolution: 1280x720
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_1X16 and resolution 1280x720
```

When an invalid resolution is provided:

```
root@rzg2l-sbc:~# ./v4l2-init.sh 3000x2000
Invalid resolution: 3000x2000
Input resolution is not available. Using default resolution: 1280x720
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_1X16 and resolution 1280x720
```

The `v4l2-init.sh` script helps enable the CSI-2 module and select the camera's supported display resolution.

After running the script, initiate a video capture session using the matching width and height

```
root@rzg2l-sbc:~# gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=1280,height=720 ! videoconvert ! waylandsink
```

Ensure that the width and height values in the GStreamer pipeline match the resolution specified in `v4l2-init.sh`. This command starts a continuous stream of the camera feed to the active video display.

### Generic USB Bluetooth framework

The RZG2L-SBC supports the generic USB Bluetooth framework, which is back-ported from the Linux kernel mainline. TP-Link UB500 Bluetooth 5.0 Nano USB Adapter (Realtek chipset) has been tested and proven to work on the board.

The following steps will guide how to enable the TP-Link UB500 adapter:

- Step 1: Download the appropriate firmware for the TP-Link UB500 adapter and store it on the RZG2L-SBC. This will ensure it is loaded each time the board boots (one-time setup).

```shell
root@rzg2l-sbc:~# mkdir -p /lib/firmware/rtl_bt
root@rzg2l-sbc:~# curl -s https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761b_fw -o /lib/firmware/rtl_bt/rtl8761bu_fw.bin
```
**Note:**
**(1) Please make sure you have internet access before running the commands.**

**(2) If the firmware is being downloaded for the first time, a reboot of the board is required to ensure the TP-Link UB500 adapter functions properly.**

**(3) By default, Bluetooth is blocked by RFKILL. To unblock it, use the command 'rfkill unblock bluetooth'**

- Step 2: Unblock bluetooth and verify whether the bluetooth status is UP RUNNING.

Run the following command to ensure that rfkill unblock bluetooth:

```shell

root@rzg2l-sbc:~# hciconfig -a
hci0:   Type: Primary  Bus: USB
        BD Address: E8:48:B8:C8:20:00  ACL MTU: 1021:6  SCO MTU: 255:12
        DOWN
        RX bytes:1045 acl:0 sco:0 events:92 errors:0
        TX bytes:12279 acl:0 sco:0 commands:92 errors:0
        Features: 0xff 0xff 0xff 0xfe 0xdb 0xfd 0x7b 0x87
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF PARK
        Link mode: PERIPHERAL ACCEPT
root@rzg2l-sbc:~# rfkill list
0: hci0: Bluetooth
        Soft blocked: yes
        Hard blocked: no
root@rzg2l-sbc:~# rfkill unblock bluetooth
root@rzg2l-sbc:~# rfkill list
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
root@rzg2l-sbc:~# hciconfig hci0 up
root@rzg2l-sbc:~# hciconfig -a
hci0:   Type: Primary  Bus: USB
        BD Address: E8:48:B8:C8:20:00  ACL MTU: 1021:6  SCO MTU: 255:12
        UP RUNNING
        RX bytes:1773 acl:0 sco:0 events:142 errors:0
        TX bytes:13029 acl:0 sco:0 commands:142 errors:0
        Features: 0xff 0xff 0xff 0xfe 0xdb 0xfd 0x7b 0x87
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF PARK
        Link mode: PERIPHERAL ACCEPT
        Name: 'rzg2l-sbc'
        Class: 0x000000
        Service Classes: Unspecified
        Device Class: Miscellaneous,
        HCI Version: 5.1 (0xa)  Revision: 0x97b
        LMP Version: 5.1 (0xa)  Subversion: 0xec43
        Manufacturer: Realtek Semiconductor Corporation (93)

The bluetooth status is UP RUNNING.

- Step 3: Verify whether the TP-Link UB500 adapter is properly attached.

Run the following command to ensure that the system has recognized the TP-Link UB500 adapter:

```shell
root@rzg2l-sbc:~# hciconfig hci0 -a
hci0:   Type: Primary  Bus: USB
        BD Address: E8:48:B8:C8:20:00  ACL MTU: 1021:5  SCO MTU: 255:11
        UP RUNNING PSCAN
        RX bytes:2264 acl:0 sco:0 events:211 errors:0
        TX bytes:32795 acl:0 sco:0 commands:211 errors:0
        Features: 0xff 0xff 0xff 0xfe 0xdb 0xfd 0x7b 0x87
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF PARK
        Link mode: SLAVE ACCEPT
        Name: 'rzg2l-sbc'
        Class: 0x000000
        Service Classes: Unspecified
        Device Class: Miscellaneous,
        HCI Version: 5.1 (0xa)  Revision: 0x9dc6
        LMP Version: 5.1 (0xa)  Subversion: 0xd922
        Manufacturer: Realtek Semiconductor Corporation (93)
```

The TP-Link UB500 adapter is now ready to connect.

- Step 4: Connect Bluetooth Device

Use `bluetoothctl` to connect Bluetooth Device:

```Shell
root@rzg2l-sbc:~# bluetoothctl
[bluetooth]# power on
[bluetooth]# pairable on
[bluetooth]# agent on
[bluetooth]# default-agent
```

Set the RZG2L-SBC to be discoverable by other Bluetooth devices:

```Shell
[bluetooth]# discoverable on
```

Enable and disable scan function:

```Shell
[bluetooth]# scan on
[bluetooth]# scan off
```

Pair and connect the device:

```Shell
[bluetooth]# pair FC:02:96:A5:80:97
[bluetooth]# trust FC:02:96:A5:80:97
[bluetooth]# connect FC:02:96:A5:80:97
```

`FC:02:96:A5:80:97` is the address of the Bluetooth device. Please change it to match your device’s address.

Exit `bluetoothctl`.

```Shell
[Mi Sports BT]# quit
```

#### Send files over Bluetooth

To share files between the RZG2L-SBC and the target Bluetooth device, run the obexctl daemon and connect:

```Shell
root@rzg2l-sbc:~# export $(dbus-launch)
root@rzg2l-sbc:~# /usr/libexec/bluetooth/obexd -r /home/root -a -d & obexctl
[1] 595
[NEW] Client /org/bluez/obex
[obex]#
[obex]# connect FC:02:96:A5:80:97
Attempting to connect to FC:02:96:A5:80:97
[NEW] Session /org/bluez/obex/client/session0 [default]
[NEW] ObjectPush /org/bluez/obex/client/session0
Connection successful
```

`FC:02:96:A5:80:97` is the address of the Bluetooth device. Please change it to match your device’s address.

Then, to send files, use `send` command while connected to the OBEX Object Push profile.

```Shell
[FC:02:96:A5:80:97]# send /boot/uEnv.txt
Attempting to send /boot/uEnv.txt to /org/bluez/obex/client/session0
[NEW] Transfer /org/bluez/obex/client/session0/transfer0
Transfer /org/bluez/obex/client/session0/transfer0
        Status: queued
        Name: uEnv.txt
        Size: 2069
        Filename: /boot/uEnv.txt
        Session: /org/bluez/obex/client/session0
[CHG] Transfer /org/bluez/obex/client/session0/transfer0 Status: complete
[DEL] Transfer /org/bluez/obex/client/session0/transfer0
[FC:02:96:A5:80:97]# quit
```

In this example, a text file names `uEnv.txt` which is located at `/boot` is sent to the target Bluetooth device.

### Package Management

The distribution comes with Debian package manager `apt-get` and `dpkg` for binary package handling. 

#### Setting up Debian as a backend source
The default configuration for the `sources.list` file, which defines the package repositories, is as follows:

```
deb [arch=arm64] http://ports.ubuntu.com/ oracular main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ oracular-security main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ oracular-backports main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ oracular-updates main multiverse universe
```

#### Configuring the Debian package repository

`sources.list` is a critical configuration file for packages installation and updates used by package managers on Debian-based Linux distributions. The `sources.list` file contains a list of URLs or repository addresses where the package manager can find software packages. These repositories may be maintained by the Linux distribution itself or by third-party individuals or organizations.

The file is located at `/etc/apt/sources.list.d/sources.list`. You can modify it to add or change the repositories according to your needs.

After configuring the APT repositories, refresh the package database by running:

```
root@rzg2l-sbc:~# apt-get update
```

**Please make sure you have internet access before running `apt-get update`.**

This command refreshes the package database and ensures that your system is aware of the latest available packages from the configured repositories.

In the contents of `sources.list` file, you can see `[arch=arm64]` on each line. This is because the RZG2L-SBC's architecture is aarch64, as indicated by the output of the `lscpu` command:

```
root@rzg2l-sbc:~# lscpu
Architecture:                    aarch64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
CPU(s):                          2
...
Vendor ID:                       ARM
```

So we need to specify `[arch=arm64]` in `sources.list` file to filter the binary packages in the repository.

This specification is to limit the existing APT sources to arm64 only, so APT won't try to fetch packages for other architectures from the existing repository.

However, if we use a repository which is already designed for ARM architectures, we don't need to specify `[arch=arm64]`. For example:

```
deb http://deb.debian.org/debian trixie main contrib non-free
```

Remember that sources doesn’t have to be a single origin. It's very common to add multiple repositories and sources for packages and manage them using keys.

The source management is beyond the scope of this document.

#### Using `apt-get` to install packages

To install a package using `apt-get`, use the following command:

```
root@rzg2l-sbc:~# apt-get install <package-name>
```

#### Using `DPKG` to install packages

The utility `dpkg` is the low-level package manager for Debian-based systems. It is the local systemwide package manager. It handles installation, removal, provisioning about package.deb file, indexing and other aspects of packages installed on the system. However, it does not perform any cloud operations. Dpkg also doesn’t handle dependency resolution. This is another task handled by a high-level manager like `apt-get`. In fact, `dpkg` is the backend for `apt-get`. While `apt-get` handles fetching and indexing, the local installations and management of the packages are performed by the `dpkg` manager.

Basic `dpkg` commands:

- `dpkg -i <package.deb>`: Installs a `package.deb` package.
- `dpkg -r <package>`: Removes a package.
- `dpkg -l <pattern>`: Lists installed packages matching `<pattern>`.
- `dpkg -s <package>`: Provides information about an installed package.

You can install `package.deb` using `dpkg` with the following command:

```
root@rzg2l-sbc:~# dpkg -i <package.deb>
```

After installing a package using dpkg, if you need to resolve dependency issues, use the following command:

```
root@rzg2l-sbc:~# apt-get install -f
```

### Docker Installation Setup

Step 1: Enable Docker support in Kernel build

To enable Docker integration at the kernel level, set the following configuration option in the build configuration file:

```
# Enable Docker Support for Kernel Build
# Set to "1" to enable building the kernel with Docker-based configurations
# Set to "0" to disable Docker integration (default)
DOCKER_SUPPORT = "1"
```

Rebuilding the kernel is required after changing this setting to apply the update.

Step 2: Install Docker via APT

Make sure your device has internet access, then run:

```shell
root@rzg2l-sbc:~# apt-get update
root@rzg2l-sbc:~# apt-get install docker.io
```

Step 3: Docker supports only iptables-legacy and iptables-nft. Firewall rules created directly with nftables are not compatible with Docker. To ensure proper operation, switch to legacy iptables:

```shell
root@rzg2l-sbc:~# update-alternatives --set iptables /usr/sbin/iptables-legacy
root@rzg2l-sbc:~# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

Restart the Docker service to apply changes:

```shell
root@rzg2l-sbc:~# systemctl restart docker
```

Step 4: Verify Docker Installation

Run the following command to test Docker.

```
root@rzg2l-sbc:~# docker run hello-world
```

You should see a message similar to:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### Network Boot and TFTP
This section outlines the process for network booting using TFTP (Trivial File Transfer Protocol). It includes configuration steps and commands necessary for a successful setup.

Network booting allows devices to boot from an image stored on a network server, rather than relying on local storage.

#### TFTP server setup
This subsection covers the setup of a TFTP server, which is necessary for the device to retrieve the boot images over the network.

- Step 1: Install a TFTP server using the following command:

  ```shell
  $ sudo apt update
  $ sudo apt install tftpd-hpa
  ```

- Step 2: Create a TFTP directory and set the appropriate permissions.

  ```shell
  $ sudo mkdir /tftpboot
  $ sudo chmod 755 /tftpboot
  ```

- Step 3: Edit the TFTP configuration file (typically found at /etc/default/tftpd-hpa) and set it up as follows:

  ```shell
  # /etc/default/tftpd-hpa
  TFTP_USERNAME="<tftp_name>"
  TFTP_DIRECTORY="</path/to/your/tftp_folder"
  TFTP_ADDRESS="0.0.0.0:69"
  TFTP_OPTIONS="--secure"
  ```

  For example:
  ```shell
  # /etc/default/tftpd-hpa
  TFTP_USERNAME="tftp"
  TFTP_DIRECTORY="/tftpboot"
  TFTP_ADDRESS="0.0.0.0:69"
  TFTP_OPTIONS="--secure"
  ```

- Step 4: Restart the TFTP service to apply the changes.

  ```shell
  $ sudo systemctl restart tftpd-hpa
  ```

  Make sure the tftpd-hpa service is running:

  ```shell
  $ sudo systemctl status tftpd-hpa
  ```

#### NFS server setup

NFS (Network File System) is a protocol that allows clients to access files over a network as if they were local. It enables multiple clients to share files from a central server, simplifying file management across machines.

In this setup, NFS will share the root filesystem (rootfs) with clients booting over the network. This allows client devices to dynamically retrieve their operating system files and configurations, making it ideal for embedded systems that require consistent file access without local storage.

- Step 1: Install NFS server and NFS client package if it's not already installed on your host PC:
  ```shell
  $ sudo apt update
  $ sudo apt install nfs-kernel-server nfs-common
  ```

- Step 2: Edit the `/etc/exports` file to specify the directories to be shared and their access permissions.
  ```shell
  $ vi /etc/exports
  ```

  For example, to share the `/tftpboot` directory, add the following line:

  ```shell
  /tftpboot *(rw,no_root_squash,async)
  ```

  Here, * allows access from any client. Consider replacing it with specific client IP addresses for better security.

- Step 3: After editing `/etc/exports`, run the following command to export the directories:

  ```shell
  $ sudo exportfs -a
  ```

- Step 4: Start the NFS server and enable it to run at boot:
  ```shell
  $ sudo systemctl start nfs-kernel-server
  $ sudo systemctl enable nfs-kernel-server
  ```

#### U-Boot DHCP IP Configuration

In this subsection, the U-Boot environment will be configured for network settings, including the specification of the Ethernet device and the configuration of the server and device IP addresses.

- Step 1: Enter the U-Boot interactive command prompt for configuration by pressing any key when prompted with `Hit any key to stop autoboot`:


  ```shell
  U-Boot 2021.10 (May 24 2024 - 07:26:08 +0000)

  CPU:   Renesas Electronics CPU rev 1.0
  Model: RZ/G2L-SBC
  DRAM:  896 MiB
  MMC:   sd@11c00000: 0
  Loading Environment from SPIFlash... SF: Detected is25wp256 with page size 256 Bytes, erase size 4 KiB, total 32 MiB

  In:    serial@1004b800
  Out:   serial@1004b800
  Err:   serial@1004b800
  Net:   eth0: ethernet@11c20000, eth1: ethernet@11c30000
  Hit any key to stop autoboot:  0
  =>
  =>
  ```

- Step 2: Enter Specify the Ethernet device (eth1) to use for the network connection. For example,

  ```shell
  => setenv ethact ethernet@11c30000
  ```

- Step 3: Configure server and device IPs:

  ```shell
  => setenv serverip <server_ip>
  => setenv ipaddr <device_ip>
  ```

  For example:
  ```shell
  => setenv serverip 192.168.5.86
  => setenv ipaddr 192.168.5.30
  ```

##### TFTP Boot

In this subsection, the boot arguments and commands for U-Boot will be configured to load the kernel image and device tree from the TFTP server.

Step 1: After setting up the TFTP server, you need to ensure that the necessary boot images, including the kernel image, device tree blob (DTB), device tree overlay (DTBO), and root file system, are placed in the TFTP directory.

```shell
renesas@builder-pc:/tftpboot/rzsbc/$ tree -L 2
.
├── Image
├── overlays
│   ├── rzg2l-sbc-can.dtbo
│   ├── rzg2l-sbc-dsi.dtbo
│   ├── rzg2l-sbc-ext-i2c.dtbo
│   ├── rzg2l-sbc-ext-spi.dtbo
│   └── rzg2l-sbc-ov5640.dtbo
├── rootfs
│   ├── bin -> usr/bin
│   ├── boot
│   ├── dev
│   ├── etc
│   ├── home
│   ├── lib -> usr/lib
│   ├── media
│   ├── mnt
│   ├── opt
│   ├── proc
│   ├── root
│   ├── run
│   ├── sbin -> usr/sbin
│   ├── snap
│   ├── srv
│   ├── sys
│   ├── tmp
│   ├── usr
│   └── var
└── rzg2l-sbc.dtb
```
- Step 2: Define the boot arguments to specify the network and root file system settings:

  ```shell
  => setenv bootargs 'consoleblank=0 strict-devmem=0 ip=<device_ip>:<server_ip>::::<eth_device> root=/dev/nfs rw nfsroot=<server_ip>:</path/to/your/rootfs>,v3,tcp' 
  ```

  For example: 
  ```shell
  => setenv bootargs 'consoleblank=0 strict-devmem=0 ip=192.168.5.30:192.168.5.86::::eth1 root=/dev/nfs rw nfsroot=192.168.5.86:/tftpboot/rzsbc/rootfs,v3,tcp'
  ```

- Step 3: Configure the boot command to load the kernel image and device tree files.

  ```shell
  => setenv bootcmd 'tftp <load_address_kernel> <path/to/kernel_image>; tftp <load_address_dtb> <path/to/device_tree_blob>; tftp <load_address_dtbo> <path/to/dtbo file>; booti <load_address_kernel> - <load_address_dtb> - <load_address_dtbo>'
  ```

  For example load `Image`, `rzg2l-sbc.dtb` and `rzg2l-sbc-ext-spi.dtbo` files.
  ```shell
  => setenv bootcmd 'tftp 0x48080000 rzsbc/Image; tftp 0x48000000 rzsbc/rzg2l-sbc.dtb; tftp 0x48010000 rzsbc/overlays/rzg2l-sbc-ext-spi.dtbo; booti 0x48080000 - 0x48000000 - 0x48010000'
  ```

- Step 4: Save the changes to the environment variables so they persist across reboots:

  ```shell
  => saveenv
  ```

- Step 5: Initiate the boot progress by running bootcmd:

  ```shell
  run bootcmd
  ```

  If everything is set up correctly, the images will be booted from the network.

  ```
  => run bootcmd
  Using ethernet@11c30000 device
  TFTP from server 192.168.5.86; our IP address is 192.168.5.30
  Filename rzsbc/Image'.
  Load address: 0x48080000
  Loading: #################################################################
          #################################################################
          #################################################################
          19.6 MiB/s
  done
  Bytes transferred = 18035200 (1133200 hex)
  Using ethernet@11c30000 device
  TFTP from server 192.168.5.86; our IP address is 192.168.5.30
  Filename 'rzsbc/rzg2l-sbc.dtb'.
  Load address: 0x48000000
  Loading: ####
          8.6 MiB/s
  done
  Bytes transferred = 44855 (af37 hex)
  Using ethernet@11c30000 device
  TFTP from server 192.168.5.86; our IP address is 192.168.5.30
  Filename 'rzsbc/overlays/rzg2l-sbc-ext-spi.dtbo'.
  Load address: 0x48010000
  Loading: #
          455.1 KiB/s
  done
  Bytes transferred = 932 (3a4 hex)
  Moving Image from 0x48080000 to 0x48200000, end=493a0000
  ## Flattened Device Tree blob at 48000000
    Booting using the fdt blob at 0x48000000
    Loading Device Tree to 000000007bf1a000, end 000000007bf27f36 ... OK

  Starting kernel ...
  ```

### Using SSH and SCP for Remote Access and File Transfers

This section explains how to use SSH (Secure Shell) for secure remote access to the RZ/G2L-SBC and how to utilize SCP (Secure Copy Protocol) for file transfers. By default, OpenSSH is employed as it is a feature-rich and widely used SSH implementation that offers advanced capabilities for secure communication. While OpenSSH serves as the default option, Dropbear SSH can be considered for lightweight, resource-constrained environments making it particularly suitable for embedded systems.

#### Differences Between Dropbear and OpenSSH
- **Resource Usage**: Dropbear is optimized for lower resource usage, making it ideal for embedded systems.
- **Feature Set**: OpenSSH has a more extensive feature set, including advanced options for authentication and configuration.
- **Key Authentication**: OpenSSH requires the use of SSH keys for authentication, while Dropbear can operate with both keys and passwords.

#### Using OpenSSH

OpenSSH is a widely-used, full-featured SSH implementation that provides encrypted communication between hosts. It supports advanced authentication methods and secure remote administration, making it ideal for robust network security.

The RZ/G2L-SBC supports both password and key-based authentication methods. To enhance security by enforcing SSH key-based login, follow these steps to switch to key-based authentication:

- Step 1: Generate an SSH key pair on your local machine, run the following command to generate a secure SSH key pair:

  ```shell
  $ ssh-keygen -t rsa -b 4096
  ```

  - Step 2: Copying an SSH public key to the board using SSH, transfer your public key to the board with this command:

  ```shell
  $ cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```
  For example:

  ```shell
  $ cat ~/.ssh/id_rsa.pub | ssh root@192.168.5.30 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```

- Step 3: Authenticate using SSH keys:

  ```shell
  $ ssh root@192.168.5.30
  ```

  If this is the first time connecting to this host (as mentioned in the previous method), a message similar to the following may appear:

  ```shell
  $ The authenticity of host 192.169.5.30 (192.168.5.30)' can't be established.
  ED25519 key fingerprint is SHA256:esQPI0Ip9HZH9A6dvTsA9+k7eLjT4sqzpiF7znl0tyw.
  This key is not known by any other names
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  ```

  This indicates that the local computer does not recognize the remote host. Type `yes` and press `ENTER` key to proceed.

- Step 4: Disable password authentication. If login to your account using SSH is successful without a password, SSH key-based authentication has been correctly configured. However, password-based authentication remains active, which leaves the server vulnerable to brute-force attacks.

  Once the SSH connection is established, open the SSH daemon's configuration file:

  ```shell
  $ vi /etc/ssh/sshd_config
  ```

  Inside the file, search for a directive called `PasswordAuthentication`. This may be commented out. Uncomment the line by removing any # at the beginning of the line, and set the value to `no`. This will disable your ability to log in through SSH using account passwords: /etc/ssh/sshd

  ```shell
  PasswordAuthentication no
  ```

- Step 5: Restart the SSH service to apply the changes:
  ```shell
  $ systemctl restart ssh
  ```

#### SSH Access

After configuring the authentication key, access to the RZ/G2L-SBC via SSH can be achieved using various tools available on both Windows and Linux platforms.

1. **SSH from Windows host**
   - **Using Git Bash**:
        - Install Git for Windows if you haven't already.
        - Use the following command:
            ```shell
            $ ssh username@<device_ip>
            ```
            For example:
            ```shell
            $ ssh root@192.168.5.30
            ```
        - Type `yes` to confirm the host's authenticity when prompted.
          ```shell
          $ ssh root@192.168.5.30
          The authenticity of host '192.168.5.30 (192.168.5.30)' can't be established.
          RSA key fingerprint is SHA256:v39PhjNp4F7HcQpwJmfNOYcC+ZZ3Yw8i1ICsL2mXUgg.
          This key is not known by any other names.
          Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
          Warning: Permanently added '192.168.5.30' (RSA) to the list of known hosts.
          ```

   - **Using MobaXTerm**:
        - Download and install MobaXterm.
        - Select "Session" > "SSH" and enter the device's IP address.
        - Confirm the host's authenticity if prompted.

2. **SSH from Linux host**
    - Open a terminal and run
        ```shell
        $ ssh username@<device_ip>
        ```
        For example:
        ```shell
        $ ssh root@192.168.5.30
        ```
    - Type `yes` to confirm the host's authenticity when prompted.

#### SCP (Secure Copy)

To securely transfer files between local and remote systems, SCP can be used on both Windows and Linux.

1. **SCP from Windows host**
   - **Using Git Bash**:
     - Install Git for Windows if you haven't already.
     - Use the following command:
       ```shell
       $ scp <local_file> username@<device_ip>:<remote_path>
       ```
       For example:
       ```shell
       $ scp hello-world root@192.168.5.30:home/root
       ```
     - Type `yes` to confirm the host's authenticity when prompted.

   - **Using WinSCP**:
     - Open WinSCP and select "New Session"
     - Choose SCP as protocol then enter the remote device's IP address and the user name.
     - Click "Login" and choose yes to confirm the host's authenticity when prompted.
     - Drag and drop files between your local machine (Left) and the target board (Right) to transfer.

2. **SCP from Linux host**
   - Use the following command:
      ```shell
      $ scp <local_file> username@<device_ip>:<remote_path>
      ```
     For example:
      ```shell
      $ scp hello-world root@192.168.5.30:home/root
      ```
   - Type `yes` to confirm the host's authenticity when prompted.

#### Switching from OpenSSH to Dropbear
By default, the RZ/G2L-SBC image uses OpenSSH as the SSH server. If you want to switch to Dropbear, follow these steps:

- Step 1: Edit the local.conf file in Yocto build configuration
- Step 2: Step 2: Modify the SSH-related variables to disable OpenSSH and enable Dropbear by changing:

  ```shell
  EXTRA_IMAGE_FEATURES:remove = " ssh-server-dropbear"
  EXTRA_IMAGE_FEATURES:append = " ssh-server-openssh"
  ```

  to

  ```shell
  EXTRA_IMAGE_FEATURES:append = " ssh-server-dropbear"
  EXTRA_IMAGE_FEATURES:remove = " ssh-server-openssh"
  ```

  This tells the build system to remove OpenSSH support and include Dropbear instead.

- Step 3: Rebuild and deploy the image to apply the changes.

This will automatically remove OpenSSH and enable Dropbear during the image build.

### Remote debugging using GDBServer on RZG2L-SBC

In this section, GDBServer will be utilized to facilitate remote debugging on the RZ/G2L-SBC. GDBServer enables the debugging process to run on the RZ/G2L-SBC (the target machine) while being controlled from a different system (the host machine) via a network connection.

This setup is particularly beneficial for application development, as it allows the execution and debugging of programs on the RZ/G2L-SBC while providing the capability to view and control the process from the host machine.

To ensure that all necessary tools and libraries for debugging are available, preparations must be made on both the host and target machines. With this preparation complete, the next step is to proceed with the remote debugging process.

#### Prepare GDB on the host machine

GGDB has two components to work with. One is the host side `gdb` debugger. The other is the target side `gdbserver`. The GDB (GNU debugger) is executed on the host side. It is executed on your host system to connect to the target system. It is always available within the eSDK. The eSDK installation as described in Section `Install eSDK on your host machine` is a prerequisite for this operation .

To set up the environment that would use the GDB targeting the RZ/G2L-SBC from the eSDK, simply run the poky environment script as follows:

```shell
$ source ~/esdk/5.1.4/environment-setup-cortexa55-poky-linux
```

To confirm GDB is ready to use, run the following command and check the result:
```shell
$ echo ${GDB}
aarch64-poky-linux-gdb
```

#### Install GDBServer on RZG2L-SBC

By default, GDBServer is not installed on the RZ/G2L-SBC. It is necessary to install it using APT.

Execute the following command to install GDBServer:

```shell
root@rzg2l-sbc:~# apt-get update
root@rzg2l-sbc:~# apt-get install gdbserver
```
**Please make sure you have internet access before running `apt-get update`.**

This concludes the preparation of the basic host environment. The next section will discuss the remote debugging process.

#### Remote Debugging Example on CLI

CLI (Command Line Interface) is a text-based user interface used to interact with computer programs and operating systems. Unlike graphical user interfaces (GUIs), where users interact with visual elements (like buttons and icons), a CLI requires users to input commands in text form.

Firstly, run GDBServer with a specific network port (`2000` is the assinged port in this case) and your program `hello-gdbserver` as a parameter on the target as follows:

```shell
root@rzg2l-sbc:~# gdbserver localhost:2000 hello-gdbserver
Process /home/root/hello-gdbserver created; pid = 358
Listening on port 2000
```

The content before compiling of the `hello-gdbserver` program:
```c
#include <stdio.h>

int main() {

        int i;

        printf("Program to demonstrate gdbserver debugging!\n");
        printf("Print from 1 to 10\n");

        for (i = 1;i <= 10;i++)
                printf("%d\n", i);

        printf("Program completed!\n");

        return 0;
}
```

The target's IP address is required for use on the host later. In this example, `169.254.43.30` is the IP address that will be used.

```shell
root@rzg2l-sbc:~# ifconfig eth1
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500  metric 1
        inet 169.254.43.30  netmask 255.255.0.0  broadcast 169.254.255.255
        inet6 fe80::1ea0:d3ff:fe20:119b  prefixlen 64  scopeid 0x20<link>
        ether 1c:a0:d3:20:11:9b  txqueuelen 1000  (Ethernet)
        RX packets 34497  bytes 2657706 (2.5 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 68954  bytes 97379412 (92.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 133
```

Next, launch GDB on the host:

```shell
$ aarch64-poky-linux-gdb
GNU gdb (GDB) 9.1
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "--host=x86_64-pokysdk-linux --target=aarch64-poky-linux".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word".
(gdb)
```

Use `target remote` with the IP address and the assigned network port to connect to the target.

```shell
(gdb) target remote 169.254.43.30:2000
Remote debugging using 169.254.43.30:2000
Reading /home/root/hello-gdbserver from remote target...
warning: File transfers from remote targets can be slow. Use "set sysroot" to access files locally instead.
Reading /home/root/hello-gdbserver from remote target...
Reading symbols from target:/home/root/hello-gdbserver...
Reading /lib64/ld-linux-aarch64.so.1 from remote target...
Reading /lib64/ld-linux-aarch64.so.1 from remote target...
Reading symbols from target:/lib64/ld-linux-aarch64.so.1...
Reading /lib64/ld-2.31.so from remote target...
Reading /lib64/.debug/ld-2.31.so from remote target...
Reading /lib64/.debug/ld-2.31.so from remote target...
Reading symbols from target:/lib64/.debug/ld-2.31.so...
0x0000fffff7fcd0c0 in _start () from target:/lib64/ld-linux-aarch64.so.1
```

Then, add a break point at `main` function to stop the program at that function in the next step:

```shell
(gdb) b main
Breakpoint 1 at 0xaaaaaaaa07cc: file hello-gdbserver.c, line 7.
```

Now, you can use `continue` to jump to the main function:

```shell
(gdb) continue
Continuing.
Reading /lib64/libc.so.6 from remote target...
Reading /lib64/libc-2.31.so from remote target...
Reading /lib64/.debug/libc-2.31.so from remote target...
Reading /lib64/.debug/libc-2.31.so from remote target...

Breakpoint 1, main () at hello-gdbserver.c:7
warning: Source file is more recent than executable.
7               printf("Program to demonstrate gdbserver debugging!\n");
```

Then, you can type `continue` to run the rest of the program:

```shell
(gdb) continue
Continuing.
[Inferior 1 (process 342) exited normally]
```

Eventually, run `quit` to exit GDB and stop the debugging section.

```shell
(gdb) quit
```

In parallel, the output can be monitored on the target device.

```shell
Remote debugging from host ::ffff:169.254.43.86, port 40666
Program to demonstrate gdbserver debugging!
Print from 1 to 10
1
2
3
4
5
6
7
8
9
10
Program completed!

Child exited with status 0
root@rzg2l-sbc:~#
```

#### Remote Debugging Example on Visual Studio Code

In the previous subsection, remote debugging using the command line was discussed, specifically with GDB and GDBServer. While this method is effective, it can be complex and challenging, particularly for developers who may not be familiar with command-line operations.

This section describes how to set up and use Visual Studio Code (VSCode) for remote debugging with the GDB. Using VSCode simplifies the debugging process by providing a user-friendly graphical interface that streamlines the workflow, making it easier to troubleshoot and test C/C++ applications running on RZ-G2L/SBC.

Here's how to get started:

Step 1: Install the C/C++ Extension (If have not installed yet):
-	Open VSCode.
-	Go to the Extensions tab on the left side (or press Ctrl + Shift + X).
-	Search for C/C++.
-	Click Install to add the extension.

Step 2: Create a Workspace:
-	Create a new workspace (you can name it `remote-debugging`).
-	Create a folder within this workspace and place your program file, `hello-gdbserver.c` in it.
-	Build the execution file using eSDK, we assume that you have source the environment.

```shell
renesas@builder-pc:~/remote-debugging/program$ $CC $CFLAGS hello-gdbserver.c -o hello-gdbserver
```

Step 3: Set Up Debug Configuration:
-	Open the Run and Debug view in VSCode (or press Ctrl + Shift + D)
-	Click on create a `launch.json` file to configure the debugger.
-	Select the C++ (GDB) option and customize the configuration as needed.
-	Place the content as below:

  ```shell
  {
      "version": "0.2.0",
      "configurations": [
          {
              "name": "gdb",
              "type": "cppdbg",
              "request": "launch",
              "program": "</local/path/to/the/executable>",
              "cwd": "${workspaceFolder}",
              "stopAtEntry": true,
              "stopAtConnect": true,
              "MIMode": "gdb",
              "miDebuggerPath": "</path/to/gdb>",
              "miDebuggerServerAddress": "<target_addr>:<port>",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "enable-pretty-printing",
                      "ignoreFailures": true
                  }
              ]
          }
      ]
  }
  ```

  For example:

  ```shell
  {
      "version": "0.2.0",
      "configurations": [
          {
              "name": "gdb",
              "type": "cppdbg",
              "request": "launch",
              "program": "/home/renesas/remote-debugging/program/hello-gdbserver",
              "cwd": "${workspaceFolder}",
              "stopAtEntry": true,
              "stopAtConnect": true,
              "MIMode": "gdb",
              "miDebuggerPath": "/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gdb",
              "miDebuggerServerAddress": "169.254.43.30:2000",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "enable-pretty-printing",
                      "ignoreFailures": true
                  }
              ]
          }
      ]
  }
  ```

- Ensure your workspace appears as follows:

```shell
renesas@builder-pc:~/remote-debugging$ tree -a
.
├── program
│   ├── hello-gdbserver
│   └── hello-gdbserver.c
└── .vscode
    └── launch.json

2 directories, 4 files
```
 
Step 4: Connect to the Remote Target:
  
- As with the CLI section, start the GDBServer on the remote device and specify the target application.

```shell
root@rzg2l-sbc:~# gdbserver localhost:2000 hello-gdbserver
Process /home/root/hello-gdbserver created; pid = 358
Listening on port 2000 
```

Step 5: Start the debugging:
-	Back in VSCode, select your launch configuration. 
-	You can place breakpoint within `hello-gdbserver.c` file in VSCode.
-	Click the Start Debugging button (green play icon) to begin the debugging session.
-	You can press F5 to continue execution, F10 to step over the current line, and F11 to step into functions, etc.

#### Remote Debugging Example on Eclipse IDE

In the previous section, the use of VSCode for remote debugging with GDB and GDBServer was discussed. While VSCode offers a modern and user-friendly environment, many developers prefer Eclipse IDE for its comprehensive toolset and robust support for C/C++ development. This section explains how to set up and use Eclipse IDE for remote debugging with GDB.

Step 1: Install the Eclipse IDE (if not already installed) by following the official instructions on the Eclipse website: https://www.eclipse.org/downloads/packages/installer

Step 2: Create a C/C++ project:
- Open Eclipse and navigate to File > New > C/C++ Project.
- Create a new C/C++ file and paste the content from `hello-gdbserver.c`.

Step 3: Configure the Cross Toolchain
- Go to Project -> Properties.
- In the left pane, select C/C++ Build > Settings.
- Under the Tool Settings tab, configure the Cross Settings as follows:
  - Prefix: `aarch64-poky-linux`
  - Path: `/path/to/your/aarch64-poky-linux`

  For example:
  - Prefix: `aarch64-poky-linux`
  - Path: `/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux`
- In the Includes section, specify the include paths:
  - Include paths: `/home/renesas/esdk/5.1.4/tmp/sysroots/rzg2l-sbc/usr/include`

- In the Cross GCC Linker section, go to Libraries and specify the library search path:
  - Library search path: `/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/lib`

- In the Miscellaneous section, specify the linker flags:
  - Linker flags: `--sysroot=/home/renesas/esdk/5.1.4/poky_sdk/tmp/sysroots/rzg2l-sbc`

Step 4: Configure Eclipse to connect to the GDB Server:
- In Eclipse, go to the `Run` menu and select `Debug Configurations`.
- Under the Debugger tab, select `C/C++ Remote Application`
- In the `Main` tab, in `Connection Type`, select `Remote` and click `Edit`
  - Host: Enter the IP address of RZ/G2L-SBC.
  - User: Enter the user name of RZ/G2L-SBC (typically `root`).
  - Authentication: Choose between key-based authentication or password-based authentication, depending on your preference.
  - Finally, click Finish to complete the setup for the SSH session.
- In the Remote Absolute File Path field, specify the location where Eclipse will copy the program on the RZ/G2L-SBC. Click Browse to connect via SSH and select the target location, or manually enter the path on the RZ/G2L-SBC.
- In the Debugger tab:
  - In GDB Debugger: Provide the path to your cross-compiled GDB (e.g., `/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gdb`).

Step 5: Start the Debugging Session: 
- After configuring the debug settings, click Apply and then Debug. 
- Eclipse will attempt to connect to the GDB server running on your target device.
- If the connection is successful, it will be possible to set breakpoints, step through the code, and inspect variables just as in a local debugging session.

**Note**: The path of the compiler may need to be adjusted to reflect the specific system configuration.

### Postmortem Analysis Example

This section provides an overview of postmortem analysis, a critical process for diagnosing application crashes by examining core dump files. It details how developers can analyze these core dumps to pinpoint the exact lines of code that led to an error, allowing for effective troubleshooting and resolution of issues.

#### Postmortem Analysis Example on CLI

This subsection describes how to perform postmortem analysis using the command-line interface (CLI). It emphasizes the steps for loading core dump files with CLI tools, enabling developers to navigate directly to the lines of code where errors occurred. The section highlights the efficiency of command-line tools for diagnosing issues quickly.

Step 1: Create a simple C program that intentionally causes a segmentation fault. For example, the file name `segfault_example.c` has below content:
 
 ```shell
  #include <stdio.h>

  int main() {
          int *ptr = NULL;

          printf("Attempting to dereference a NULL pointer...\r\n");

          *ptr = 42;

          return 0;
  } 
 ```
Step 2: Source the environment and compile the `segfault_example.c` program

 ```shell
  renesas@builder-pc:~$ source ~/esdk/5.1.4/environment-setup-cortexa55-poky-linux
  SDK environment now set up; additionally you may now run devtool to perform development tasks.
  Run devtool --help for further details.
  renesas@builder-pc:~/remote-debugging/segfault_program$ $CC $CFLAGS segfault_example.c -o segfault_example
 ```

Step 3: Transfer the program to RZ/G2L-SBC

 ```shell
 renesas@builder-pc:~/remote-debugging/segfault_program$ scp segfault_example root@169.254.43.30:/home/root
 ```

Step 4: Ensure your system allows core dumps. You can set the core dump size to unlimited by running:
 
 ```shell
 root@rzg2l-sbc:~# ulimit -c unlimited
 ```
Step 5: Run the program and get the core dump file
 
 ```shell
  root@rzg2l-sbc:~# ./segfault_example

  Attempting to dereference a NULL pointer...
  Segmentation fault (core dumped)
 ```
When the segmentation fault occurs, a core dump file will be generated, usually named core or core.<pid>, for example core.880 in my case.

 ```shell
  root@rzg2l-sbc:~# ls core*

  core.880
 ```

Transfer the core dump file back to your host machine.

Step 6: Using GDB to analyze the core dump file. Return to your remote machine and use the following command.
 
 ```shell
 renesas@builder-pc:~/remote-debugging/segfault_program$ aarch64-poky-linux-gdb </path/to/local_program> </path/to/core/dump/file>
 ```
For example:

 ```shell
  renesas@builder-pc:~/remote-debugging/segfault_program$ aarch64-poky-linux-gdb segfault_example core.810

  GNU gdb (GDB) 9.1
  Copyright (C) 2020 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.
  Type "show copying" and "show warranty" for details.
  This GDB was configured as "--host=x86_64-linux --target=aarch64-poky-linux".
  Type "show configuration" for configuration details.
  For bug reporting instructions, please see:
  <http://www.gnu.org/software/gdb/bugs/>.
  Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

  For help, type "help".
  Type "apropos word" to search for commands related to "word".
  Reading symbols from segfault...
  [New LWP 810]

  warning: Could not load shared library symbols for 2 libraries, e.g. /lib64/libc.so.6.
  Use the "info sharedlibrary" command to see the complete listing.
  Do you need "set solib-search-path" or "set sysroot"?
  Core was generated by `./segfault.
  Program terminated with signal SIGSEGV, Segmentation fault.
  #0  0x0000aaaae3340794 in main () at segfault_example.c:8
  --Type <RET> for more, q to quit, c to continue without paging--
  8               *ptr = 42;
  (gdb)
  (gdb) quit
 ```
The segmentation fault occurred because the program attempted to dereference a NULL pointer at line 8 in segfault_example.c, where it tried to assign 42 to *ptr, resulting in an invalid memory access.

#### Postmortem analysis on Visual Studio Code

In this subsection, the process of analyzing core dump files using Visual Studio Code (VSCode) is explored. It explains how to load core dumps and utilize VSCode's debugging features to automatically jump to the lines of code that caused the application to crash.
If you've followed subsection `Remote debugging on Visual Studio Code`, you're almost ready to analyze the core dump file. Just one small addition remains: in the `launch.json`, include a line specifying the path to the core dump file for analysis. This simple tweak allows you to fully leverage VSCode's capabilities for inspecting the crash details.
For example, in `launch.json`, you would add:
 
 ```shell
 "coreDumpPath": "</path/to/core/dump/file>,
 ```

Here's a complete example of a `launch.json` in this example
 
 ```shell
  {
    "version": "0.2.0",
    "configurations": [
        {
            "name": "gdb",
            "type": "cppdbg",
            "request": "launch",
            "program": "/home/renesas/remote-debugging/program/segfault_example",
            "cwd": "${workspaceFolder}",
            "stopAtEntry": true,
            "stopAtConnect": true,
            "MIMode": "gdb",
            "miDebuggerPath": "/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gdb",
            "miDebuggerServerAddress": "169.254.43.30:2000",
            "coreDumpPath": "/home/renesas/remote-debugging/segfault/core.810",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
  }
 ```

After running the debugging session with the core dump file, the IDE (Visual Studio Code) will automatically point to the exact line in the source code where the crash occurred.
 
#### Postmortem analysis on Eclipse

This subsection describes postmortem analysis using Eclipse IDE. Similar with Visual Studio Code, Eclipse allows loading core dump to inspect the application's state at the time of a crash. 

Step 1: Configure Eclipse to connect to the GDB Server:
- In Eclipse, go to the `Run` menu and select `Debug Configurations`.
- Under the Debugger tab, select `C/C++ Postmortem Debugger`
- In the `Main` tab, in `Core file field`, click and specify where is core dump file.
- In the Debugger tab:
  - In GDB Debugger: Provide the path to your cross-compiled GDB (e.g., `/home/renesas/esdk/5.1.4/tmp/sysroots/x86_64/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gdb`).

Step 2: Start the Debugging Session: 
- Once the debugging session starts, Eclipse will show the line of code that caused the segmentation fault, along with the call stack.
- You can inspect the values of variables at that point in time by hovering over them or using the Variables view.
- Utilize the Expressions view to evaluate any expressions or check the state of specific variables.
- Navigate through the call stack to see the sequence of function calls leading to the crash. This can provide insight into how the program reached the faulting line.
