# RZG2L SBC board #
This is the quick startup guide for RZG2L SBC board (hereinafter referred to as `RZG2L-SBC`).
The below will describe the current status of development, how to build, set up environment for RZG2L-SBC.

## Status
This is a VLP v3.0.5 release of the RZG2L development product for RZG2L-SBC.

This release provides the following features:

 - Yocto build compatible with RZG2L SoC (VLP v3.0.5)
 - RZG2L-SBC Linux BSP functionalities (based on RZG2L BSP v3.0.5-update1)
 - Graphic and Codec libraries supported with QT demo applications.
 - 40 IO expansion interface supported
 - On-board Wireless Modules enabled (only support for Wi-Fi)
 - On-board Audio Codec with Stereo Jack Analog Audio IO
 - MIPI DSI enabled
 - MIPI CSI-2 enabled
 - Bootloader with U-Boot Fastboot UDP enabled.

Known issues:

 - Only support for 48 Khz audio sampling rate family.

## Building
Step 1: Prepare environment for building package

Linux Ubuntu 20.04 is recommended for Yocto build.
Before starting the build, run the command below on the Linux Host PC to install packages to be used.
```
$ sudo apt-get update
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm p7zip-full
```

Run the below commands to set the user name and email address before starting the build procedure.
```
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```

Step 2: Prepare the local build environment

After preparing the host machine for building, download necessary packages (get them from Renesas website):
- Graphic: https://www.renesas.com/us/en/document/swo/rz-mpu-graphics-library-evaluation-version-rzg2l-and-rzg2lc-rtk0ef0045z13001zj-v112enzip
- Codec: https://www.renesas.com/us/en/document/swo/rz-mpu-video-codec-library-evaluation-version-rzg2l-rtk0ef0045z15001zj-v110xxzip?r=1535641

Then create a workspace folder (example: `~/Yocto`) for the build and put the files `rzsbc_yocto.sh`, `site.conf`, `README.md`, `jq-linux-amd64` and a patch folder for eSDK build support from the release package into it.
```
$ mkdir ~/Yocto
$ cp *.zip ~/Yocto
$ cp rzsbc_yocto.sh ~/Yocto
$ cp site.conf ~/Yocto
$ cp README.md ~/Yocto
$ cp jq-linux-amd64 ~/Yocto
$ cp git_patch.json ~/Yocto
$ cp -r patches ~/Yocto
```

Step 3: Build package

Build the package by executing the following commands:
```
$ cd ~/Yocto
$ ./rzsbc_yocto.sh build
```

**Please note that this build requires internet access and will take several hours.**

Step 4: Collect the output

After building Yocto, the output folder should be `~/Yocto/yocto_rzsbc_board/build/tmp/deploy/images/rzpi`

The output folder outline:
```
rzpi/
├── host
│   ├── build
│   │   ├── core-image-qt-rzpi-20240918051558.rootfs.manifest
│   │   ├── core-image-qt-rzpi-20240918051558.testdata.json
│   │   ├── core-image-qt-rzpi.manifest -> core-image-qt-rzpi-20240918051558.rootfs.manifest
│   │   └── core-image-qt-rzpi.testdata.json -> core-image-qt-rzpi-20240918051558.testdata.json
│   ├── env
│   │   ├── Readme.md
│   │   └── core-image-qt.env
│   ├── Readme.md
│   ├── src                                                             <---- Build script packages
│   │   ├── git_patch.json
│   │   ├── jq-linux-amd64
│   │   ├── patches
│   │   │   ├── meta-summit-radio
│   │   │   │   └── 0001-rzsbc-summit-radio-pre-3.4-support-eSDK-build.patch
│   │   │   └── poky
│   │   │       └── 0001-meta-classes-esdk-explicitly-address-the-location-of.patch
│   │   ├── README.md
│   │   ├── rzsbc_yocto.sh
│   │   └── site.conf
│   └── tools
│       ├── bootloader-flasher
│       │   ├── linux                                                    <---- Bootloader flashing script package folder on Linux
│       │   │   ├── bootloader_flash.py                                  <---- Bootloader flashing script on Linux
│       │   │   └── Readme.md                                            <---- Bootloader flashing script on Linux guideline
│       │   ├── Readme.md
│       │   └── windows                                                  <---- Bootloader flashing script package folder on Windows
│       │       ├── config.ini
│       │       ├── flash_bootloader.bat                                 <---- Bootloader flashing script on Windows
│       │       ├── Readme.md                                            <---- Bootloader flashing script on Windows guideline
│       │       └── tools
│       │           ├── cygterm.cfg
│       │           ├── flash_bootloader.ttl
│       │           ├── TERATERM.INI
│       │           ├── ttermpro.exe
│       │           ├── ttpcmn.dll
│       │           ├── ttpfile.dll
│       │           ├── ttpmacro.exe
│       │           ├── ttpset.dll
│       │           └── ttxssh.dll
│       ├── Readme.md
│       ├── sd-creator
│       │   ├── linux                                                    <---- SD card flashing script package folder on Linux
│       │   │   ├── sd_flash.sh                                          <---- SD card flashing script on Linux
│       │   │   └── Readme.md                                            <---- SD card flashing guideline on Linux
│       │   ├── Readme.md
│       │   └── windows                                                  <---- SD card flashing script package folder on Windows
│       │       ├── config.ini
│       │       ├── flash_filesystem.bat                             <---- SD card flashing script on Windows
│       │       ├── Readme.md                                        <---- SD card flashing guideline on Windows
│       │       └── tools
│       │           ├── AdbWinApi.dll
│       │           ├── cygterm.cfg
│       │           ├── fastboot.bat
│       │           ├── fastboot.exe
│       │           ├── flash_system_image.ttl
│       │           ├── TERATERM.INI
│       │           ├── ttermpro.exe
│       │           ├── ttpcmn.dll
│       │           ├── ttpfile.dll
│       │           ├── ttpmacro.exe
│       │           ├── ttpset.dll
│       │           └── ttxssh.dll
│       └── uload-bootloader
│           ├── linux                                                    <---- Bootloader flashing from U-Boot console script package on Linux
│           │   ├── uload_bootloader_flash.py                            <---- Bootloader flashing from U-Boot console script on Linux
│           │   └── Readme.md                                            <---- Bootloader flashing from U-Boot console guideline on Linux
│           ├── Readme.md
│           └── windows                                                  <---- Bootloader flashing from U-Boot console script package on Windows
│               ├── config.ini
│               ├── Readme.md                                            <---- Bootloader flashing from U-Boot console guideline on Windows
│               ├── tools
│               │   ├── cygterm.cfg
│               │   ├── TERATERM.INI
│               │   ├── ttermpro.exe
│               │   ├── ttpcmn.dll
│               │   ├── ttpfile.dll
│               │   ├── ttpmacro.exe
│               │   ├── ttpset.dll
│               │   ├── ttxssh.dll
│               │   └── uload-flash_bootloader.ttl
│               └── uload-flash_bootloader.bat                           <---- Bootloader flashing from U-Boot console script on Windows
├── license
│   ├── Disclaimer051.pdf
│   └── Disclaimer052.pdf
├── r12uz0158eu0101-rz-g2l-sbc-single-board-computer.pdf
├── README.md                                                            <---- This document
├── RZG2L-SBC_Evaluation_license.pdf
└── target                                                               <---- Holds images for bootloader, kernel, rootfs, and device tree
    ├── env                                                              <---- Contains environment configuration files for booting and system setup
    │   ├── Readme.md
    │   └── uEnv.txt
    ├── images                                                           <---- Contains bootloader, kernel, and root filesystem images
    │   ├── bl2_bp-rzpi.bin
    │   ├── bl2_bp-rzpi.srec
    │   ├── bl2-rzpi.bin
    │   ├── core-image-qt-rzpi.wic
    │   ├── dtbs                                                         <---- Contains Device tree blobs (DTBs) for hardware configuration
    │   │   ├── overlays                                                 <---- Overlays for extending device tree functionality
    │   │   │   ├── Readme.md
    │   │   │   ├── rzpi-can.dtbo
    │   │   │   ├── rzpi-dsi.dtbo
    │   │   │   ├── rzpi-ext-i2c.dtbo
    │   │   │   ├── rzpi-ext-spi.dtbo
    │   │   │   └── rzpi-ov5640.dtbo
    │   │   ├── Readme.md
    │   │   ├── rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240910054534.dtb
    │   │   └── rzpi.dtb -> rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240910054534.dtb
    │   ├── fip-rzpi.bin
    │   ├── fip-rzpi.srec
    │   ├── Flash_Writer_SCIF_rzpi.mot
    │   ├── Image -> Image--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240910054534.bin
    │   ├── Image--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240910054534.bin
    │   ├── Readme.md
    │   └── rootfs                                                       <---- Contains compressed root filesystem images
    │       ├── core-image-qt-rzpi.tar.bz2
    │       └── Readme.md
    └── Readme.md

28 directories, 92 files
```

## Programming/Flashing images for RZG2L-SBC

### Flash Bootloader on Linux

We prepare a suppport script `bootloader_flash.py` for flashing bootloader on Linux. The script can be achieved from Yocto build.

Please run the follow command to know how to use the script:

```
$ ./bootloader_flash.py -h
```

**Before performing a flashing, make sure the board is powered off, connect the debug serial (SCIF0 - TXD,RXD,GND) to your Linux PC and change switches to enter SCIF download mode**

### Flash Bootloader on Windows

Same as Flash Bootloader on Linux, we prepare some suppport scripts for flashing bootloader on Windows.

Please get folder `bootloader-windows-script` from Yocto build output folder. Then refer to `Readme.txt` file to know how to use the scripts.

### Flash Bootloader on U-Boot console

In case users want to update Bootloader without touching the hardware setup. We support a method to flash Bootloader on U-Boot console.

Please get folder `uload-bootloader` from Yocto build output folder. Then refer to `uload-readme.txt` file to know the flashing procedure.

### Prepare image and rootfs in microSD card on Linux

Please prepare the rootfs image in microSD card before booting RZG2L-SBC system.
We prepare a suppport script `sd_flash.sh` for this purpose. The script can be achieved from Yocto build.

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

Please get folder `filesystem-windows-script` from Yocto build output folder. Then refer to `README.md` file to know how to use the scripts.

### U-boot environment

In U-Boot console, execute one more command to bring RZG2L-SBC system up:

```
=> boot
```

## Confirm supported features on RZG2L-SBC

### QT demo applications

Some QT demo applications are suppported in this VLP release for RZG2L-SBC. 
Run the following commands to enter to QT demo applications folder and run a demo app as your needs.

For example, QT smart home demo application is executed.

```
root@rzpi:~# cd /home/root/demo/scripts/
root@rzpi:~/demo/scripts# ./QtSmarthome-demo.sh
```


### 40 IO expansion interface settings

The 40 IO Expansion Interface on RZG2L-SBC supports for I2C channel 0 and channel 3, SPI channel 0, SCIF channel 0, CAN channel 0 and channel 1 and GPIO pin-function (default).

By default, I2C channel 0 and SCIF channel 0 are enabled. Users can configure to use other channels.

We support an FDT overlays appoach to easily reconfigure for this Expansion Interface.

The specific description is as follows:

```
## For RZ SBC U-Boot Env
/------------------------------|--------------|------------------------------
|       Config                 | Value if set |     To be loading
|------------------------------|--------------|------------------------------
| enable_overlay_i2c           | '1' or 'yes' |  rzpi-ext-i2c.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_spi           | '1' or 'yes' |  rzpi-ext-spi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_can           | '1' or 'yes' |  rzpi-can.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_dsi           | '1' or 'yes' |  rzpi-dsi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_csi_ov5640    | '1' or 'yes' |  rzpi-ov5640.dtbo
|----------------------------------------------------------------------------
| fdtfile   : is a base dtb file, should be set rzpi.dtb
|----------------------------------------------------------------------------
| uboot env : you could set U-Boot's environment variables here, such as 'console=' 'bootargs='
\---------------------------------------------------------------------------

default settings:
    fdtfile=rzpi.dtb
    #enable_overlay_i2c=1
    #enable_overlay_spi=1
    #enable_overlay_can=1
    #enable_overlay_dsi=1
    #enable_overlay_csi_ov5640=1
```

You can refer to the `readme.txt` file in `/boot` folder for the FDT overlays information.

After changing the value of overlays options, we need to run `sync` to ensure that the changes are affected. Then, execute `reboot` to apply the changes.

The below section shows how to configure for each GPIO function:

#### GPIO

System uses /sys/class/gpio to control the GPIO pin, please refer to the following table:

```
/-----------|---------------|-------|-----|-----------|-----|-------|---------------|-------------\
|   pinum   |   Function    | group | pin |   J3 PIN  | pin | group |   Function    |   pinum     |
|-----------|---------------|-------|-----|-----------|-----|-------|---------------|-------------|
|           |   3.3V        |       |     |   1   2   |     |       |   5V          |             |
|   490     |   RIIC3 SDA   |   46  |  2  |   3   4   |     |       |   5V          |             |
|   491     |   RIIC3 SCL   |   46  |  3  |   5   6   |     |       |   GND         |             |
|   304     |   GPIO        |   23  |  0  |   7   8   |  0  |   38  |   SCIF0 TX    |   424       |
|           |   GND         |       |     |   9   10  |  1  |   38  |   SCIF0 RX    |   425       |
|   456     |   GPIO        |   42  |  0  |   11  12  |  2  |   7   |   GPIO        |   178       |
|   336     |   GPIO        |   27  |  0  |   13  14  |     |       |   GND         |             |
|   345     |   GPIO        |   28  |  1  |   15  16  |  0  |   8   |   GPIO        |   184       |
|           |   3.3V        |       |     |   17  18  |  0  |   15  |   GPIO        |   240       |
|   465     |   RSPI0 MOSI  |   43  |  1  |   19  20  |     |       |   GND         |             |
|   466     |   RSPI0 MISO  |   43  |  2  |   21  22  |  1  |   14  |   GPIO        |   233       |
|   464     |   RSPI0 CK    |   43  |  0  |   23  24  |  3  |   43  |   RSPI0 SSL   |   467       |
|           |   GND         |       |     |   25  26  |  1  |   11  |   GPIO        |   209       |
|           |   RIIC0 SDA   |       |     |   27  28  |     |       |   RIIC0 SCL   |             |
|   152     |   GPIO        |   4   |  0  |   29  30  |     |       |   GND         |             |
|   153     |   GPIO        |   4   |  1  |   31  32  |  0  |   32  |   GPIO        |   376       |
|   297     |   GPIO        |   22  |  1  |   33  34  |     |       |   GND         |             |
|   457     |   CAN0 TX     |   42  |  1  |   35  36  |  1  |   23  |   GPIO        |   305       |
|   208     |   CAN0 RX     |   11  |  0  |   37  38  |  0  |   46  |   CAN1 TX     |   488       |
|           |   GND         |       |     |   39  40  |  1  |   46  |   CAN1 RX     |   489       |
\-----------|---------------|-------|-----|-----------|-----|-------|---------------|-------------/
```

pinum = $group * $groupin + $pin + $pinbase (where pinbase=120, groupin=8)

Example for J3 PIN 7:
                              23*8 + 0 + 120 = 304 = pinum

To set GPIO pin, move to GPIO sysfs directory and set values as shown below:

```
root@rzpi:~# cd /sys/class/gpio/
root@rzpi:~# echo 304 > export
root@rzpi:~# echo out > P23_0/direction
root@rzpi:~# echo 1 > P23_0/value
root@rzpi:~# echo 0 > P23_0/value
```

#### I2C function (channel 3 - RIIC3)

You should edit `uEnv.txt` as follows to enable I2C channel 3 on 40 IO expansion interface:

```
enable_overlay_i2c=1
```

To check the I2C channel 3 is enabled or not, run the following command and check the result:

```
root@rzpi:~# i2cdetect -l
i2c-3   i2c             Renesas RIIC adapter                    I2C adapter
i2c-1   i2c             Renesas RIIC adapter                    I2C adapter
i2c-4   i2c             i2c-1-mux (chan_id 0)                   I2C adapter
i2c-0   i2c             Renesas RIIC adapter                    I2C adapter
root@rzpi:~#
```

You can also check devices existance on I2C bus by running the following command:

```
root@rzpi:~# i2cdetect -y -r 3
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
root@rzpi:~# spi-config -d /dev/spidev0.0 -q
/dev/spidev0.0: mode=0, lsb=0, bits=8, speed=2000000, spiready=0
```

Connect Pin 19 (RSPI0 MOSI) to Pin 21 (RSPI0 MISO), then run the below command and check the result:

```
root@rzpi:~# echo -n -e "1234567890" | spi-pipe -d /dev/spidev0.0 -s 10000000 | hexdump
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
root@rzpi:~# ip a | grep can
3: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can
4: can1: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can
root@rzpi:~#
```

Then set up for CAN devices. Now you can up/down or send data from CAN channels.

The below shows the communication between two CAN channels.
```
root@rzpi:~# ip link set can0 down
root@rzpi:~# ip link set can0 type can bitrate 500000
root@rzpi:~# ip link set can0 up
[   48.120419] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
root@rzpi:~# ip link set can1 down
root@rzpi:~# ip link set can1 type can bitrate 500000
root@rzpi:~# ip link set can1 up
[   69.906039] IPv6: ADDRCONF(NETDEV_CHANGE): can1: link becomes ready
root@rzpi:~# candump can0 & cansend can1 123#01020304050607
[1] 271
  can0  123   [7]  01 02 03 04 05 06 07
root@rzpi:~# candump can1 & cansend can0 123#01020304050607
[2] 273
  can0  123   [7]  01 02 03 04 05 06 07
  can1  123   [7]  01 02 03 04 05 06 07
root@rzpi:~#
```

### On-board Wi-Fi Modules configurations

RZG2L-SBC has an on-board Wireless modules on it. Currently, we only support for Wi-Fi feature in this release.

To settings for Wi-Fi on RZG2L-SBC, run the following commands:

```
root@rzpi:~# connmanctl
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
root@rzpi:~# ping www.google.com
PING www.google.com(hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004)) 56 data bytes
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=1 ttl=57 time=43.2 ms
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=2 ttl=57 time=81.1 ms
64 bytes from hkg07s39-in-x04.1e100.net (2404:6800:4005:813::2004): icmp_seq=3 ttl=57 time=124 ms
```

**Please note that before using Wi-Fi feature on RZG2L-SBC, the ethernet connections need to be down.**

```
root@rzpi:~# ifconfig eth0 down
root@rzpi:~# ifconfig eth1 down
```

### On-board Audio Codec with Stereo Jack Analog Audio IO configurations

RZG2L-SBC has an On-board Audio Codec - DA7219. It is the default audio device of RZG2L-SBC
and it will be enabled automatically when the system comes up.

Before playing an audio file, connect an audio device such as 3.5mm headset to J8.

Run the following commands to play an audio file:

```
root@rzpi:~# aplay /home/root/audios/04_16KH_2ch_bgm_maoudamashii_healing01.wav
root@rzpi:~# gst-play-1.0 /home/root/audios/COMMON6_MPEG2_L3_24KHZ_160_2.mp3
```

`aplay` command supports `wav` format audio files

`gst-play-1.0` command supports `wav`, `mp3` and `aac` formats

To perform a recording, run the following command to record audio to an `audio_capture.wav` file:

```
root@rzpi:~# arecord -f S16_LE -r 48000 audio_capture.wav
```

Press Ctrl+C if you want to stop recording.

In the above command:

-f S16_LE : audio format

-r 48000  : sample rate of the audio file (48KHz)

To verify the recorded file, you can play it by the following command:

```
root@rzpi:~# aplay audio_capture.wav
```

To adjust the level of the audio record/playback, use the following command to open the ALSA mixer GUI:

```
root@rzpi:~# alsamixer
```

### MIPI DSI with display panels

RZG2L-SBC supports the MIPI DSI interface and the Waveshare 5 inch Touchscreen Monitor MIPI-DSI LCD is enabled and tested.

You should edit `uEnv.txt` as follows to enable MIPI DSI interface with the panel supported:

```
enable_overlay_dsi=1
```

**Please note that selecting the MIPI DSI display will cause the HDMI display be disabled.**

### Playing Video Files on RZ/G2L-SBC

Use `gst-launch-1.0` to play the video file. The playbin element in GStreamer makes it easy to play multimedia content. Run the following command:

```
root@rzpi:~# gst-launch-1.0 playbin uri=file:///<path/to/your/video/path>
```

We have prepared some test videos in the /home/root/videos folder. You can use these for testing. For example:

```
root@rzpi:~# gst-launch-1.0 playbin uri=file:///home/root/videos/renesas-bigideasforeveryspace.mp4
```

### MIPI CSI2 with Arducam 5MP MIPI Camera

RZG2L-SBC supports the MIPI CSI-2 camera interface and the Arducam 5MP MIPI Camera (OV5640 image sensor) is enabled and tested.

You should edit `uEnv.txt` as follows to enable MIPI CSI-2 interface with the camera supported:

```
enable_overlay_csi_ov5640=1
```
To use the camera, we need to enable the CSI-2 module. Run the following commands:

```
root@rzpi:~# cd /home/root/
root@rzpi:~# ./v4l2-init.sh <resolution>
```

The <resolution> argument specifies the resolution for the camera. Valid resolutions are:

- 1280x720
- 1280x960
- 1600x900
- 1920x1080
- 1920x1200
- 2560x1080

If no resolution is specified or an invalid resolution is provided, the default resolution 1280x960 will be used. For example:

When use a valid resolution:

```
root@rzpi:~# ./v4l2-init.sh 1920x1080
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_2X8 and resolution 1920x1080
```

When no resolution is specified:

```
root@rzpi:~# ./v4l2-init.sh
No resolution specified. Using default resolution: 1280x960
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_2X8 and resolution 1280x960
```

When an invalid resolution is provided:

```
root@rzpi:~# ./v4l2-init.sh 3000x2000
Invalid resolution: 3000x2000
Input resolution is not available. Using default resolution: 1280x960
Link CRU/CSI2 to ov5640 1-003c with format UYVY8_2X8 and resolution 1280x960
```

The `v4l2-init.sh` script helps to enable the CSI-2 module and select supported display resolution for the camera as well.

Run the following to open Camera and preview the video on the screen.

```
root@rzpi:~# gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! waylandsink
```

### Chromium Web browser application

Chromium Web browser application is supported in this package release for supported RZ based projects.

The following command will show how to use Chromium to access a web page on the internet.

```
root@rzpi:~# chromium --no-sandbox --in-process-gpu https://google.com
```

**Please note that you must have an input device (USB mouse or touchscreen) plugged in before you start the browser. If you do not, you will get a "Segmentation fault".**

### Package Management

The distribution comes with Debian package manager `apt-get` and `dpkg` for binary package handling. 

#### Setting up Debian as a backend source
The default configuration for the `sources.list` file, which defines the package repositories, is as follows:

```
deb [arch=arm64] http://ports.ubuntu.com/ focal main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ focal-security main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ focal-backports main multiverse universe
deb [arch=arm64] http://ports.ubuntu.com/ focal-updates main multiverse universe
```

#### Configuring the Debian package repository

`sources.list` is a critical configuration file for packages installation and updates used by package managers on Debian-based Linux distributions. The `sources.list` file contains a list of URLs or repository addresses where the package manager can find software packages. These repositories may be maintained by the Linux distribution itself or by third-party individuals or organizations.

The file is located at `/etc/apt/sources.list.d/sources.list`. You can modify it to add or change the repositories according to your needs.

After configuring the APT repositories, refresh the package database by running:

```
root@rzpi:~# apt-get update
```

**Please make sure you have internet access before running `apt-get update`.**

This command refreshes the package database and ensures that your system is aware of the latest available packages from the configured repositories.

In the contents of `sources.list` file, you can see `[arch=arm64]` on each line. This is because the RZG2L-SBC's architecture is aarch64, as indicated by the output of the `lscpu` command:

```
root@rzpi:~# lscpu
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
deb http://deb.debian.org/debian bullseye main contrib non-free
```

Remember that sources doesn’t have to be a single origin. It's very common to add multiple repositories and sources for packages and manage them using keys.

The source management is beyond the scope of this document.

#### Using `apt-get` to install packages

To install a package using `apt-get`, use the following command:

```
root@rzpi:~# apt-get install <package-name>
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
root@rzpi:~# dpkg -i <package.deb>
```

After installing a package using dpkg, if you need to resolve dependency issues, use the following command:

```
root@rzpi:~# apt-get install -f
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
In this subsection, you will configure the U-Boot environment for network settings. This includes specifying the Ethernet device and setting the server and device IP addresses.

- Step 1: Enter U-Boot’s interactive command prompt for configuration.

  You can achieve this by pressing any key when prompted with Hit any key to stop autoboot:

  ```shell
  U-Boot 2021.10 (May 24 2024 - 07:26:08 +0000)

  CPU:   Renesas Electronics CPU rev 1.0
  Model: RZpi
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

In this subsection, you will configure the boot arguments and commands that U-Boot will use to load the kernel image and device tree from the TFTP server.

Step 1: After setting up the TFTP server, you need to ensure that the necessary boot images, including the kernel image, device tree blob (DTB), device tree overlay (DTBO), and root file system, are placed in the TFTP directory.

```shell
renesas@builder-pc:/tftpboot/rzsbc/$ tree -L 2
.
├── Image
├── overlays
│   ├── rzpi-can.dtbo
│   ├── rzpi-dsi.dtbo
│   ├── rzpi-ext-i2c.dtbo
│   ├── rzpi-ext-spi.dtbo
│   └── rzpi-ov5640.dtbo
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
└── rzpi.dtb
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

  For example load `Image`, `rzpi.dtb` and `rzpi-ext-spi.dtbo` files.
  ```shell
  => setenv bootcmd 'tftp 0x48080000 rzsbc/Image; tftp 0x48000000 rzsbc/rzpi.dtb; tftp 0x48010000 rzsbc/overlays/rzpi-ext-spi.dtbo; booti 0x48080000 - 0x48000000 - 0x48010000'
  ```

- Step 4: Save the changes to the environment variables so they persist across reboots:

  ```shell
  => saveenv
  ```

- Step 5: Initiate the boot progress by running bootcmd:

  ```shell
  run bootcmd
  ```

  If you set everything up correctly, you will be able to boot the images from the network.

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
  Filename 'rzsbc/rzpi.dtb'.
  Load address: 0x48000000
  Loading: ####
          8.6 MiB/s
  done
  Bytes transferred = 44855 (af37 hex)
  Using ethernet@11c30000 device
  TFTP from server 192.168.5.86; our IP address is 192.168.5.30
  Filename 'rzsbc/overlays/rzpi-ext-spi.dtbo'.
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

This section outlines the use of SSH (Secure Shell) for secure remote access to devices and how to use SCP (Secure Copy Protocol) for transferring files. By default, we use Dropbear SSH, which is lightweight and suitable for embedded systems. While Dropbear is designed for resource-constrained environments, OpenSSH is more feature-rich and widely used.

#### Differences Between Dropbear and OpenSSH
- **Resource Usage**: Dropbear is optimized for lower resource usage, making it ideal for embedded systems.
- **Feature Set**: OpenSSH has a more extensive feature set, including advanced options for authentication and configuration.
- **Key Authentication**: OpenSSH requires the use of SSH keys for authentication, while Dropbear can operate with both keys and passwords.

#### SSH Access

To access the device via SSH, you can use various tools on both Windows and Linux:

1. **SSH from Windows host**
   - **Using Git Bash**:
        - Install Git for Windows if you haven't already.
        - Use the following command:
            ```shell
            $ ssh -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa username@<device_ip>
            ```
            For example:
            ```shell
            $ ssh -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa root@192.168.5.30
            ```
        - Type `yes` to confirm the host's authenticity when prompted.
          ```shell
          $ ssh -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa root@192.168.5.30
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
        $ ssh -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa username@<device_ip>
        ```
        For example:
        ```shell
        $ ssh -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa root@192.168.5.30
        ```
    - Type `yes` to confirm the host's authenticity when prompted.

#### SCP (Secure Copy)

To transfer files securely between local and remote systems, you can use SCP from both Windows and Linux.

1. **SCP from Windows host**
   - **Using Git Bash**:
     - Install Git for Windows if you haven't already.
     - Use the following command:
       ```shell
       $ scp -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa <local_file> username@<device_ip>:<remote_path>
       ```
       For example:
       ```shell
       $ scp -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa hello-world root@192.168.5.30:home/root
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
      $ scp -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa <local_file> username@<device_ip>:<remote_path>
      ```
     For example:
      ```shell
      $ scp -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa hello-world root@192.168.5.30:home/root
      ```
   - Type `yes` to confirm the host's authenticity when prompted.

#### Using OpenSSH

OpenSSH is a widely-used, full-featured SSH implementation that provides encrypted communication between hosts. It supports advanced authentication methods and secure remote administration, making it ideal for robust network security.

##### Switching from Dropbear to OpenSSH

As mentioned, by default, the board uses Dropbear SSH. If you need to switch from Dropbear to OpenSSH, follow these steps to modify the local.conf:
- Step 1: Edit the local.conf file in Yocto build configuration
- Step 2: Uncomment the following lines in the local.conf

  ```shell
  #IMAGE_FEATURES_remove = "ssh-server-dropbear" 
  #IMAGE_FEATURES_append = "ssh-server-openssh"
  ```
  This will remove Dropbear and enable OpenSSH for the board.

- Step 3: Rebuild and deploy the image to apply the changes.

##### Using OpenSSH

By default, the board supports both password and key-based authentication. If you prefer to enforce SSH key-based login for enhanced security, follow these steps to switch to key-based authentication:

Once OpenSSH is installed, you can generate SSH keys for secure authentication:

- Step 1: Generate an SSH key pair on your local machine, run the following command to generate a secure SSH key pair:

  ```shell
  $ ssh-keygen -t rsa -b 4096
  ```

  - Step 2: Copying an SSH public Key to the board using SSH, transfer your public key to the board with this command:

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

  If this is your first time connecting to this host (if you used the last method above), you may see something like this:

  ```shell
  $ The authenticity of host 192.169.5.30 (192.168.5.30)' can't be established.
  ED25519 key fingerprint is SHA256:esQPI0Ip9HZH9A6dvTsA9+k7eLjT4sqzpiF7znl0tyw.
  This key is not known by any other names
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  ```

  This means that your local computer does not recognize the remote host. Type yes and then press ENTER to continue.

- Step 4: Disable password authentication: If you were able to login to your account using SSH without a password, you have successfully configured SSH key-based authentication to your account. However, your password-based authentication mechanism is still active, meaning that your server is still exposed to brute-force attacks.

  Once the SSH connection is established, open the SSH daemon's configuration file:

  ```shell
  $ vi /etc/ssh/sshd_config
  ```

  Inside the file, search for a directive called PasswordAuthentication. This may be commented out. Uncomment the line by removing any # at the beginning of the line, and set the value to no. This will disable your ability to log in through SSH using account passwords: /etc/ssh/sshd

- Step 5: Restart the SSH service to apply the changes:
  ```shell
  $ systemctl restart ssh
  ```