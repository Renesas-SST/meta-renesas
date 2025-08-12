# RZ Common target folder

## Overview

This directory contains the environment setup and image files required for the target system, specifically for the RZ Common platform.

## Directory Structure

```
target/
├── env
│   ├── Readme.md
│   └── uEnv.txt
├── images
│   ├── bl2_bp_esd_rzg2l-evk.bin
│   ├── bl2_bp_esd_rzg2l-sbc.bin
│   ├── bl2_bp_esd_rzv2h-evk.bin
│   ├── bl2_bp_esd_rzv2h-evk.srec
│   ├── bl2_bp_esd_rzv2l-evk.bin
│   ├── bl2_bp_mmc_rzv2h-evk.bin
│   ├── bl2_bp_mmc_rzv2h-evk.srec
│   ├── bl2_bp_rzg2l-evk.bin
│   ├── bl2_bp_rzg2l-evk.srec
│   ├── bl2_bp_rzg2l-sbc.bin
│   ├── bl2_bp_rzg2l-sbc.srec
│   ├── bl2_bp_rzv2l-evk.bin
│   ├── bl2_bp_rzv2l-evk.srec
│   ├── bl2_bp_spi_rzv2h-evk.bin
│   ├── bl2_bp_spi_rzv2h-evk.srec
│   ├── bl2-rzg2l-evk.bin
│   ├── bl2-rzg2l-sbc.bin
│   ├── bl2-rzv2h-evk.bin
│   ├── bl2-rzv2l-evk.bin
│   ├── core-image-bsp.wic
│   ├── dtbs
│   │   ├── overlays
│   │   │   ├── Readme.md
│   │   │   ├── rzg2l-sbc-can.dtbo
│   │   │   ├── rzg2l-sbc-dsi.dtbo
│   │   │   ├── rzg2l-sbc-ext-i2c.dtbo
│   │   │   ├── rzg2l-sbc-ext-spi.dtbo
│   │   │   └── rzg2l-sbc-ov5640.dtbo
│   │   ├── r9a07g044l2-smarc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g044l2-smarc-cru-csi-ov5645--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g044l2-smarc-cru-csi-ov5645.dtb -> r9a07g044l2-smarc-cru-csi-ov5645--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g044l2-smarc.dtb -> r9a07g044l2-smarc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g054l2-smarc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g054l2-smarc-cru-csi-ov5645--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g054l2-smarc-cru-csi-ov5645.dtb -> r9a07g054l2-smarc-cru-csi-ov5645--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a07g054l2-smarc.dtb -> r9a07g054l2-smarc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a09g057h4-evk-ver1--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── r9a09g057h4-evk-ver1.dtb -> r9a09g057h4-evk-ver1--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   ├── Readme.md
│   │   ├── rzg2l-sbc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   │   └── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
│   ├── fip_rzg2l-evk.bin
│   ├── fip_rzg2l-evk.srec
│   ├── fip_rzg2l-sbc.bin
│   ├── fip_rzg2l-sbc.srec
│   ├── fip_rzv2h-evk.bin
│   ├── fip_rzv2h-evk.srec
│   ├── fip_rzv2l-evk.bin
│   ├── fip_rzv2l-evk.srec
│   ├── Flash_Writer_SCIF_rzg2l-evk.mot
│   ├── Flash_Writer_SCIF_rzg2l-evk_PMIC.mot
│   ├── Flash_Writer_SCIF_rzg2l-sbc.mot
│   ├── Flash_Writer_SCIF_rzg2l-sbc_PMIC.mot
│   ├── Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot
│   ├── Flash_Writer_SCIF_rzv2l-evk.mot
│   ├── Flash_Writer_SCIF_rzv2l-evk_PMIC.mot
│   ├── Image -> Image--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.bin
│   ├── Image--6.10.14+git0+d<commit-hash>-r0-rz-cmn-<timestamp>.bin
│   ├── Readme.md
│   ├── renesas-core-image-cli.wic
│   ├── renesas-core-image-weston.wic
│   ├── renesas-quickboot-cli.wic
│   ├── renesas-quickboot-wayland.wic
│   ├── rootfs
│   │   ├── core-image-bsp.tar.bz2
│   │   ├── Readme.md
│   │   ├── renesas-core-image-cli.tar.bz2
│   │   ├── renesas-core-image-weston.tar.bz2
│   │   ├── renesas-quickboot-cli.tar.bz2
│   │   ├── renesas-quickboot-wayland.tar.bz2
│   │   ├── renesas-ubuntu.tar.bz2
│   │   ├── ubuntu-core-image.tar.bz2
│   │   └── ubuntu-lxde-image.tar.bz2
│   ├── rzg2l-evk-platform-settings.bin
│   ├── rzg2l-evk-platform-settings.srec
│   ├── rzg2l-sbc-platform-settings.bin
│   ├── rzg2l-sbc-platform-settings.srec
│   ├── rzv2h-evk-ver1.0-platform-settings.bin
│   ├── rzv2h-evk-ver1.0-platform-settings.srec
│   ├── rzv2h-evk-ver2.0-platform-settings.bin
│   ├── rzv2h-evk-ver2.0-platform-settings.srec
│   ├── rzv2l-evk-platform-settings.bin
│   ├── rzv2l-evk-platform-settings.srec
│   ├── ubuntu-core-image.wic.gz
│   └── ubuntu-lxde-image.wic.gz
└── Readme.md
```

- `env/` - Includes U-Boot environment configuration files.  
- `images/` - Includes boot and flashable image files, kernel binaries, device tree blobs, and overlays.  

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
The above structure is an example when building using the target image `IMAGE=core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `core-image-weston`. Other target images will have the same structure.

Each subdirectory includes its own `Readme.md` with detailed descriptions and instructions:

- See `env/Readme.md` for environment setup details.  
- See `images/Readme.md` for the structure and usage of boot images and device trees.  