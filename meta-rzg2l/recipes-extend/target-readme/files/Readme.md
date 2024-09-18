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
    ├── bl2_bp-rzpi.bin
    ├── bl2_bp-rzpi.srec
    ├── bl2-rzpi.bin
    ├── core-image-qt-rzpi.wic
    ├── dtbs                                                <---- Contains Device tree blobs (DTBs) for hardware configuration
    │   ├── overlays                                        <---- Overlays for extending device tree functionality
    │   │   ├── Readme.md
    │   │   ├── rzpi-can.dtbo
    │   │   ├── rzpi-dsi.dtbo
    │   │   ├── rzpi-ext-i2c.dtbo
    │   │   ├── rzpi-ext-spi.dtbo
    │   │   └── rzpi-ov5640.dtbo
    │   ├── Readme.md
    │   ├── rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb
    │   └── rzpi.dtb > rzpi-5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb
    ├── fip-rzpi.bin
    ├── fip-rzpi.srec
    ├── Flash_Writer_SCIF_rzpi.mot
    ├── Image > Image-5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.bin
    ├── Image--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.bin
    ├── Readme.md
    └── rootfs                                              <---- Contains compressed root filesystem images
        ├── core-image-qt-rzpi.tar.bz2
        └── Readme.md
```

## Note

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
