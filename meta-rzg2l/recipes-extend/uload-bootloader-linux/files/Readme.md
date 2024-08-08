# RZ/G2L-SBC uload-bootloader-linux

## Description

This directory contains files and tools used for flashing and managing the bootloader on the RZ/G2L-SBC

## A top-level directory of host
```
    uload-bootloader
    └─── linux
          ├── uload_bootloader_flash.py   <- uload bootloader flash script
          └── Readme.md                   <--- This document 
```

## Script usage

### Copy necessary images

1.Place all bootloader images (.bin) in the /boot/uload-bootloader folder (optional).

We've already prepared these images in the /boot/uload-bootloader folder on the SD card. If you want to change the images, replace these files.

The `/boot/uload-bootloader` folder should contain the following files:
- fip-rzpi.bin
- bl2_bp-rzpi.bin

### Running the script
To run the script, use the following command:

```bash
./uload_bootloader_flash.py --serial_port /dev/ttyUSB0 --serial_port_baud 115200
```

**Note:**

**1. Before performing a flashing, make sure the board is powered off and SD Card is attached on the board with the latest root filesystem (for details, see `Prepare image and rootfs in microSD card on Linux/Windows` in the startup guide `README.md`)**

**2. (Optional) Default bootloader images (.bin) are located in the folder `/boot/uload-bootloader` of the root filesystem. You can put your own bootloader images there and perform a flashing by some manual steps in U-Boot console as below:**

- Step 1: probe the QSPI NOR flash on RZG2L SBC board.
```
=> sf probe
```

- Step 2: erase the current IPL

**Warning: this step will erase all data on QSPI NOR flash. If step 3 and step 4 are not proceed next, you will not be able to boot RZG2L SBC board.**
```
=> sf erase 0 100000
```

- Step 3: load bl2 bootloader into DRAM and then write to QSPI NOR flash.

```
=> ext4load mmc 0:2 0x48000000 boot/uload-bootloader/bl2_bp-rzpi.bin
=> sf write 0x48000000 0 $filesize
```

- Step 4: load fip file into DRAM and then write to QSPI NOR flash.

```
=> ext4load mmc 0:2 0x48000000 boot/uload-bootloader/fip-rzpi.bin
=> sf write 0x48000000 1d200 $filesize
```