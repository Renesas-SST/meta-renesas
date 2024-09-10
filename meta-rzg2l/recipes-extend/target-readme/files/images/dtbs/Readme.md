# RZ/G2L-SBC dtbs Folder

## Description

This directory contains Device Tree Blob (DTB) files used for hardware configuration on the RZ/G2L-SBC platform. DTBs are essential for defining the hardware layout and enabling the Linux kernel to interact with the hardware components.

## A top-level directory of dtbs

```
dtbs                                                  
├── overlays                                  <---- Device Tree Overlay files for extending DTB functionality
│   ├── rzpi-can.dtbo                         <---- Overlay for CAN interface
│   ├── rzpi-dsi.dtbo                         <---- Overlay for DSI display interface
│   ├── rzpi-ext-i2c.dtbo                     <---- Overlay for external I2C devices
│   ├── rzpi-ext-spi.dtbo                     <---- Overlay for external SPI devices
│   ├── rzpi-ov5640.dtbo                      <---- Overlay for OV5640 camera
│   └── Readme.md
├── rzpi--5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb  <---- Main device tree blob file for RZ/G2L-SBC
└── rzpi.dtb > rzpi-5.10.184-cip36+gitAUTOINC+5f065ec41b-r1-rzpi-20240717204209.dtb  <---- Symlink to the main dtb file
└── Readme.md                                  <---- This document

```

### Files:
- **overlays**: Contains Device Tree Overlay files that allow additional hardware configurations to be applied on top of the base DTB.
- **rzpi.dtb**: The device tree blob file that defines the hardware configuration for the - RZ/G2L-SBC.