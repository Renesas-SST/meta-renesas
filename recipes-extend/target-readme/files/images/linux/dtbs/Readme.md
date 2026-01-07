# RZ Common dtbs Folder

## Description

This directory contains Device Tree Blob (DTB) files used for hardware configuration on the RZ Common System platform. DTBs are essential for defining the hardware layout and enabling the Linux kernel to interact with the hardware components.

## A top-level directory of dtbs

```
dtbs/
├── imdt-v2h-sbc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── imdt-v2h-sbc.dtb
├── overlays
│   ├── Readme.md
│   ├── rzg2l-evk-1.0-cru-csi-ov5645.dtbo
│   ├── rzg2l-sbc-1.0-can.dtbo
│   ├── rzg2l-sbc-1.0-dsi.dtbo
│   ├── rzg2l-sbc-1.0-ext-i2c.dtbo
│   ├── rzg2l-sbc-1.0-ext-spi.dtbo
│   ├── rzg2l-sbc-1.0-ov5640.dtbo
│   ├── rzv2h-rdk-1.0-audio-codec.dtbo
│   ├── rzv2h-rdk-1.0-can.dtbo
│   ├── rzv2h-rdk-1.0-ext-spi.dtbo
│   └── rzv2l-evk-1.0-cru-csi-ov5645.dtbo
├── Readme.md
├── rs-g2l100--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rs-g2l100.dtb -> rs-g2l100--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzg2l-evk--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzg2l-evk.dtb -> rzg2l-evk--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzv2h-evk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzv2h-evk-ver1.dtb -> rzv2h-evk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzv2h-rdk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzv2h-rdk-ver1.dtb -> rzv2h-rdk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── rzv2l-evk--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
└── rzv2l-evk.dtb -> rzv2l-evk--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
```

### Files:
- **overlays**: Contains Device Tree Overlay files that allow additional hardware configurations to be applied on top of the base DTB for RZ Common System boards.
- ***.dtb**: The device tree blob file that defines the hardware configuration.
    - **imdt-v2h-sbc.dtb**: Device tree blob file for IMDT V2H-SBC.
    - **rs-g2l100**: Device tree blob file for RS-G2L100
    - **rzg2l-evk.dtb**: Device tree blob file for RZ/G2L-EVK.
    - **rzg2l-sbc**: Device tree blob file for RZ/G2L-SBC.
    - **rzv2h-evk-ver1.dtb**: Device tree blob file for RZ/V2H-EVK.
    - **rzv2h-rdk-ver1.dtb**: Device tree blob file for RZ/V2H-RDK.
    - **rzv2l-evk.dtb**: Device tree blob file for RZ/V2L-EVK.