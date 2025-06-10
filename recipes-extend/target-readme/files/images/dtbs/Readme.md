# RZ/G2L-SBC dtbs Folder

## Description

This directory contains Device Tree Blob (DTB) files used for hardware configuration on the RZ/G2L-SBC platform. DTBs are essential for defining the hardware layout and enabling the Linux kernel to interact with the hardware components.

## A top-level directory of dtbs

```
dtbs                                                  
├── overlays                                  <---- Device Tree Overlay files for extending DTB functionality
│   ├── rzg2l-sbc-can.dtbo                         <---- Overlay for CAN interface
│   ├── rzg2l-sbc-dsi.dtbo                         <---- Overlay for DSI display interface
│   ├── rzg2l-sbc-ext-i2c.dtbo                     <---- Overlay for external I2C devices
│   ├── rzg2l-sbc-ext-spi.dtbo                     <---- Overlay for external SPI devices
│   ├── rzg2l-sbc-ov5640.dtbo                      <---- Overlay for OV5640 camera
│   └── Readme.md
├── rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.dtbo  <---- Main device tree blob file for RZ/G2L-SBC
└── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rzg2l-sbc-<timestamp>.dtbo  <---- Symlink to the main dtb file
└── Readme.md                                  <---- This document

```

### Files:
- **overlays**: Contains Device Tree Overlay files that allow additional hardware configurations to be applied on top of the base DTB.
- **rzg2l-sbc.dtb**: The device tree blob file that defines the hardware configuration for the - RZ/G2L-SBC.