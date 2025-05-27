# RZ/G2L-SBC target folder

## Description

This directory contains the environment setup and image files required for the target system, specifically for the RZ/G2L-SBC platform.

## A top-level directory of target

```
target
├── env                                                     <---- Environment setup files for configuring the bootloader
│   ├── uEnv.txt
│   └── Readme.md
├── Readme.md                                               <---- This document
└── images                                                  <---- Contains bootloader, kernel, and root filesystem images
    ├── bl2_bp-rzg2l-sbc.bin
    ├── bl2_bp-rzg2l-sbc.srec
    ├── bl2-rzg2l-sbc.bin
    ├── renesas-core-image-weston-rzg2l-sbc.wic
    ├── dtbs                                                <---- Contains Device tree blobs (DTBs) for hardware configuration
    │   ├── overlays                                        <---- Overlays for extending device tree functionality
    │   │   ├── Readme.md
    │   │   ├── rzg2l-sbc-can.dtbo
    │   │   ├── rzg2l-sbc-dsi.dtbo
    │   │   ├── rzg2l-sbc-ext-i2c.dtbo
    │   │   ├── rzg2l-sbc-ext-spi.dtbo
    │   │   └── rzg2l-sbc-ov5640.dtbo
    │   ├── Readme.md
    │   ├── rzg2l-sbc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rzg2l-sbc-20241213061340.dtbo
    │   └── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rzg2l-sbc-20241213061340.dtbo
    ├── fip-rzg2l-sbc.bin
    ├── fip-rzg2l-sbc.srec
    ├── Flash_Writer_SCIF_rzg2l-sbc.mot
    ├── Image > Image--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rzg2l-sbc-20241213061340.bin
    ├── Image--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rzg2l-sbc-20241213061340.bin
    ├── Readme.md
    └── rootfs                                              <---- Contains compressed root filesystem images
        ├── renesas-core-image-weston-rzg2l-sbc.tar.bz2
        └── Readme.md
```

## Note

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
The above structure is an example when building using the target image `IMAGE=renesas-core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `renesas-core-image-weston`. Other target images will have the same structure.

