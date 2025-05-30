# RZ Common dtbs Folder

## Description

This directory contains Device Tree Blob (DTB) files used for hardware configuration on the RZ/G2L-SBC platform. DTBs are essential for defining the hardware layout and enabling the Linux kernel to interact with the hardware components.

## A top-level directory of dtbs

```
dtbs                                                  
├── overlays                                       <---- Device Tree Overlay files for extending DTB functionality
│   ├── rzg2l-sbc-can.dtbo                         <---- Overlay for CAN interface
│   ├── rzg2l-sbc-dsi.dtbo                         <---- Overlay for DSI display interface
│   ├── rzg2l-sbc-ext-i2c.dtbo                     <---- Overlay for external I2C devices
│   ├── rzg2l-sbc-ext-spi.dtbo                     <---- Overlay for external SPI devices
│   ├── rzg2l-sbc-ov5640.dtbo                      <---- Overlay for OV5640 camera
│   └── Readme.md
├── r9a07g044l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo      <---- Main device tree blob file for RZG2L SMARC
├── r9a07g044l2-smarc.dtb                                                                    <---- Symlink to the main dtb file
├── r9a07g054l2-smarc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo      <---- Main device tree blob file for RZV2L SMARC
├── r9a07g054l2-smarc.dtb                                                                    <---- Symlink to the main dtb file
├── r9a09g057h4-evk-ver1--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo   <---- Main device tree blob file for RZV2H-EVK
├── r9a09g057h4-evk-ver1.dtb                                                                 <---- Symlink to the main dtb file
├── rzg2l-sbc--6.10.14+git0+af06ad75b8_bbe3d1be4e-r0-rz-cmn-20250523093711.dtbo              <---- Main device tree blob file for RZ/G2L-SBC
├── rzg2l-sbc.dtb                                                                            <---- Symlink to the main dtb file
└── Readme.md                                                                                <---- This document

```

### Files:
- **overlays**: Contains Device Tree Overlay files that allow additional hardware configurations to be applied on top of the base DTB.
- **rzg2l-sbc.dtb**: The device tree blob file that defines the hardware configuration for the - RZ/G2L-SBC.