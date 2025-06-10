# RZ Common images folder

## Description

This directory contains various image files used for deploying and booting the RZ Common platform. These images include the core operating system images, Device Tree Blobs (DTBs), and any additional overlays required for the hardware configuration.

## A top-level directory of images

```
images
├── bl2_bp_esd_rzg2l-evk.bin
├── bl2_bp_esd_rzg2l-sbc.bin
├── bl2_bp_esd_rzv2h-evk.bin
├── bl2_bp_esd_rzv2h-evk.srec
├── bl2_bp_esd_rzv2l-evk.bin
├── bl2_bp_mmc_rzv2h-evk.bin
├── bl2_bp_mmc_rzv2h-evk.srec
├── bl2_bp_rzg2l-evk.bin
├── bl2_bp_rzg2l-evk.srec
├── bl2_bp_rzg2l-sbc.bin
├── bl2_bp_rzg2l-sbc.srec
├── bl2_bp_rzv2l-evk.bin
├── bl2_bp_rzv2l-evk.srec
├── bl2_bp_spi_rzv2h-evk.bin
├── bl2_bp_spi_rzv2h-evk.srec
├── bl2-rzg2l-evk.bin
├── bl2-rzg2l-sbc.bin
├── bl2-rzv2h-evk.bin
├── bl2-rzv2l-evk.bin
├── core-image-bsp.wic
├── core-image-minimal.wic
├── core-image-weston.wic
├── dtbs                                   <---- Directory containing Device Tree Blob files
│   ├── overlays                           <---- Directory containing Device Tree Overlay files
│   │   ├── Readme.md
│   │   ├── rzg2l-sbc-can.dtbo
│   │   ├── rzg2l-sbc-dsi.dtbo
│   │   ├── rzg2l-sbc-ext-i2c.dtbo
│   │   ├── rzg2l-sbc-ext-spi.dtbo
│   │   └── rzg2l-sbc-ov5640.dtbo
│   ├── r9a07g044l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── r9a07g044l2-smarc.dtb -> r9a07g044l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── r9a07g054l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── r9a07g054l2-smarc.dtb -> r9a07g054l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── r9a09g057h4-evk-ver1--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── r9a09g057h4-evk-ver1.dtb -> r9a09g057h4-evk-ver1--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   ├── Readme.md
│   ├── rzg2l-sbc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
│   └── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo
├── fip_rzg2l-sbc.bin
├── fip_rzg2l-sbc.srec
├── fip_rzv2h-evk.bin
├── fip_rzv2h-evk.srec
├── fip_rzv2l-evk.bin
├── fip_rzv2l-evk.srec
├── Flash_Writer_SCIF_rzg2l-sbc.mot
├── Flash_Writer_SCIF_rzg2l-sbc_PMIC.mot
├── Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot
├── Flash_Writer_SCIF_rzv2l-evk.mot
├── Flash_Writer_SCIF_rzv2l-evk_PMIC.mot
├── Image -> Image--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.bin
├── Image--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.bin
├── Readme.md                              <---- This document
└── rootfs                                 <---- Directory containing root filesystem images                  
    ├── core-image-bsp.tar.bz2
    ├── core-image-minimal.tar.bz2
    ├── core-image-weston.tar.bz2
    └── Readme.md

```

## Content Breakdown

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
The above structure is an example when building using the target image `IMAGE=core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `core-image-weston`. Other target images will have the same structure.

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