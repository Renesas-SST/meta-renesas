# SD Card Creation Tool for Linux

This tool is used for creating a bootable SD card for the RZ/G2L-SBC board in a Linux environment.

## Step 1: Identify the SD Card Slot

1. Insert your SD card into the Linux PC.
2. Use the following command to identify the correct device name for your SD card

```bash
lsblk
```

## Step 2: Flash the SD Card
1. Ensure the sd_flash.sh script is executable.
```
chmod +x sd_flash.sh
```
2. Run the sd_flash.sh script with the SD card device name. Optionally, you can include the filesystem tarball image path as a second argument
```
./sd_flash.sh <device> <path/to/your/core-image-qt-rzpi.tar.bz2>
```

**Note:**
- **device**: The path to your SD card device, identified in Step 2 (e.g., `/dev/sda`).
- **path/to/your/core-image-qt-rzpi.tar.bz2**: The path to the directory containing the root filesystem tarball image (core-image-qt-rzpi.tar.bz2).

3. Example run

Without passing the filesystem tarball path as an argument:

```
./sd_flash.sh /dev/sda
```

Passing the filesystem tarball path as an argument:

```
./sd_flash.sh /dev/sda /home/renesas/rz-sbc/images/core-image-qt-rzpi.tar.bz2
```

After successfully executing the SD card flashing script, the SD card will be automatically unmounted.



