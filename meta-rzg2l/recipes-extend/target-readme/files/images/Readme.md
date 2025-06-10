# RZ/G2L-SBC images folder

## Description

This directory contains various image files used for deploying and booting the RZ/G2L-SBC platform. These images include the core operating system images, Device Tree Blobs (DTBs), and any additional overlays required for the hardware configuration.

## A top-level directory of images

```
images/
├── bl2_bp-rzpi.bin
├── bl2_bp-rzpi.srec
├── bl2-rzpi.bin
├── core-image-bsp-rzpi.wic
├── core-image-minimal-rzpi.wic
├── core-image-qt-rzpi.wic
├── core-image-weston-rzpi.wic
├── dtbs
│   ├── overlays
│   │   ├── Readme.md
│   │   ├── rzpi-can.dtbo
│   │   ├── rzpi-dsi.dtbo
│   │   ├── rzpi-ext-i2c.dtbo
│   │   ├── rzpi-ext-spi.dtbo
│   │   └── rzpi-ov5640.dtbo
│   ├── Readme.md
│   ├── rzpi--5.10.184-cip36+git<commit-hash>-r<release>-rzpi-<timestamp>.dtb
│   └── rzpi.dtb
├── fip-rzpi.bin
├── fip-rzpi.srec
├── Flash_Writer_SCIF_rzpi.mot
├── Image
├── Image--5.10.184-cip36+git<commit-hash>-r<release>-rzpi-<timestamp>.bin
├── Readme.md
├── renesas-core-image-cli-rzpi.wic
├── renesas-core-image-weston-rzpi.wic
├── renesas-quickboot-cli-rzpi.wic
├── renesas-quickboot-wayland-rzpi.wic
├── renesas-ubuntu-rzpi.wic
├── rootfs
│   ├── core-image-bsp-rzpi.tar.bz2
│   ├── core-image-minimal-rzpi.tar.bz2
│   ├── core-image-qt-rzpi.tar.bz2
│   ├── core-image-weston-rzpi.tar.bz2
│   ├── Readme.md
│   ├── renesas-core-image-cli-rzpi.tar.bz2
│   ├── renesas-core-image-weston-rzpi.tar.bz2
│   ├── renesas-quickboot-cli-rzpi.tar.bz2
│   ├── renesas-quickboot-wayland-rzpi.tar.bz2
│   ├── renesas-ubuntu-rzpi.tar.bz2
│   ├── ubuntu-core-image-qt-rzpi.tar.bz2
│   └── ubuntu-lxde-image-qt-rzpi.tar.bz2
├── ubuntu-core-image-qt-rzpi.wic.gz
└── ubuntu-lxde-image-qt-rzpi.wic.gz

3 directories, 41 files
```

## Content Breakdown

### `images/`
This directory contains the actual bootable and flashable output files, grouped as follows:

#### Firmware Files
- `bl2*.bin`, `bl2*.srec`: Bootloader stage 2 binaries.
- `fip-rzpi.*`: Firmware Image Package (FIP) containing BL31, BL32, BL33.
- `Flash_Writer_SCIF_rzpi.mot`: Flash writer for initial programming over SCIF.
- `Image`, `Image--*`: Linux kernel images.

#### Flashing Images
- `.wic`, `.wic.gz`: Full disk images containing boot + rootfs partitions. These are used with tools like `dd` or Etcher to flash onto SD cards.
- `.tar.bz2`: Root filesystem archives. These can be extracted or mounted depending on the boot method.

#### Device Tree Blobs
- `dtbs/`: Contains `.dtb` files and overlay `.dtbo` files for various hardware configurations.
    - `overlays/`: Specific overlay files for enabling peripherals (e.g., CAN, DSI, SPI).

### `rootfs/`
- Contains root filesystem archives `.tar.bz2` that correspond to the `.wic` images found in the parent `images/` directory.
- These archives can be extracted or used directly depending on your boot method (e.g., NFS boot, manual rootfs deployment).

## Note 
- Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.