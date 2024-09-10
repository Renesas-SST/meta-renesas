# RZ/G2L-SBC images folder

## Description

This directory contains various image files used for deploying and booting the RZ/G2L-SBC platform. These images include the core operating system images, Device Tree Blobs (DTBs), and any additional overlays required for the hardware configuration.

## A top-level directory of images

```
images
├── bl2_bp-rzpi.bin
├── bl2_bp-rzpi.srec
├── bl2-rzpi.bin
├── core-image-qt-rzpi.wic
├── dtbs                                    <---- Directory containing Device Tree Blob files
│   ├── overlays                                <---- Directory containing Device Tree Overlay files
│   │   ├── rzpi-can.dtbo
│   │   ├── rzpi-dsi.dtbo
│   │   ├── rzpi-ext-i2c.dtbo
│   │   ├── rzpi-ext-spi.dtbo
│   │   ├── rzpi-ov5640.dtbo 
│   ├   └── Readme.md
│   ├── rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb
│   ├── rzpi.dtb -> rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb
│   └── Readme.md
├── fip-rzpi.bin
├── fip-rzpi.srec
├── Flash_Writer_SCIF_rzpi.mot
├── Image > Image-5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.bin
├── Image--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.bin
├── rootfs                                  <---- Directory containing root filesystem images
│   ├── core-image-qt-rzpi.tar.bz2          
│   └── Readme.md
└── Readme.md                               <---- This document
```

## Note

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
