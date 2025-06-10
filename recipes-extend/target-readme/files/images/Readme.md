# RZ/G2L-SBC images folder

## Description

This directory contains various image files used for deploying and booting the RZ/G2L-SBC platform. These images include the core operating system images, Device Tree Blobs (DTBs), and any additional overlays required for the hardware configuration.

## A top-level directory of images

```
images/
├── bl2_bp-rzg2l-sbc.bin
├── bl2_bp-rzg2l-sbc.srec
├── bl2-rzg2l-sbc.bin
├── core-image-bsp-rzg2l-sbc.wic
├── core-image-minimal-rzg2l-sbc.wic
├── core-image-weston-rzg2l-sbc.wic
├── dtbs
│   ├── overlays
│   │   ├── Readme.md
│   │   ├── rzg2l-sbc-can.dtbo
│   │   ├── rzg2l-sbc-dsi.dtbo
│   │   ├── rzg2l-sbc-ext-i2c.dtbo
│   │   ├── rzg2l-sbc-ext-spi.dtbo
│   │   └── rzg2l-sbc-ov5640.dtbo
│   ├── Readme.md
│   ├── rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.dtb
│   └── rzg2l-sbc.dtb
├── fip-rzg2l-sbc.bin
├── fip-rzg2l-sbc.srec
├── Flash_Writer_SCIF_rzg2l-sbc.mot
├── Image
├── Image--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.bin
├── Readme.md
├── renesas-core-image-cli-rzg2l-sbc.wic
├── renesas-core-image-weston-rzg2l-sbc.wic
├── renesas-quickboot-cli-rzg2l-sbc.wic
├── renesas-quickboot-wayland-rzg2l-sbc.wic
├── renesas-ubuntu-rzg2l-sbc.wic
├── rootfs
│   ├── core-image-bsp-rzg2l-sbc.tar.bz2
│   ├── core-image-minimal-rzg2l-sbc.tar.bz2
│   ├── core-image-weston-rzg2l-sbc.tar.bz2
│   ├── Readme.md
│   ├── renesas-core-image-cli-rzg2l-sbc.tar.bz2
│   ├── renesas-core-image-weston-rzg2l-sbc.tar.bz2
│   ├── renesas-quickboot-cli-rzg2l-sbc.tar.bz2
│   ├── renesas-quickboot-wayland-rzg2l-sbc.tar.bz2
│   ├── renesas-ubuntu-rzg2l-sbc.tar.bz2
│   ├── ubuntu-core-image-rzg2l-sbc.tar.bz2
│   └── ubuntu-lxde-image-rzg2l-sbc.tar.bz2
├── ubuntu-core-image-rzg2l-sbc.wic.gz
└── ubuntu-lxde-image-rzg2l-sbc.wic.gz

3 directories, 41 files
```

## Content Breakdown

### `images/`
This directory contains the actual bootable and flashable output files, grouped as follows:

#### Firmware Files
- `bl2*.bin`, `bl2*.srec`: Bootloader stage 2 binaries.
- `fip-rzg2l-sbc.*`: Firmware Image Package (FIP) containing BL31, BL32, BL33.
- `Flash_Writer_SCIF_rzg2l-sbc.mot`: Flash writer for initial programming over SCIF.
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