# RZ Common dtbs Folder

## Description

This directory contains Device Tree Blob (DTB) files used for hardware configuration on the RZ/G2L-SBC platform. DTBs are essential for defining the hardware layout and enabling the Linux kernel to interact with the hardware components.

## A top-level directory of dtbs

```
dtbs/
├── overlays
│   ├── Readme.md
│   ├── rzg2l-sbc-can.dtbo
│   ├── rzg2l-sbc-dsi.dtbo
│   ├── rzg2l-sbc-ext-i2c.dtbo
│   ├── rzg2l-sbc-ext-spi.dtbo
│   └── rzg2l-sbc-ov5640.dtbo
├── r9a07g044l2-smarc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g044l2-smarc-cru-csi-ov5645--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g044l2-smarc-cru-csi-ov5645.dtb -> r9a07g044l2-smarc-cru-csi-ov5645--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g044l2-smarc.dtb -> r9a07g044l2-smarc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g054l2-smarc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g054l2-smarc-cru-csi-ov5645--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g054l2-smarc-cru-csi-ov5645.dtb -> r9a07g054l2-smarc-cru-csi-ov5645--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a07g054l2-smarc.dtb -> r9a07g054l2-smarc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a09g057h4-evk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── r9a09g057h4-evk-ver1.dtb -> r9a09g057h4-evk-ver1--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
├── Readme.md
├── rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
└── rzg2l-sbc.dtb -> rzg2l-sbc--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.dtbo
```

### Files:
- **overlays**: Contains Device Tree Overlay files that allow additional hardware configurations to be applied on top of the base DTB for RZ/G2L-SBC.
- ***.dtb**: The device tree blob file that defines the hardware configuration.
    - **rzg2l-sbc.dtb**: Device tree blob file for RZ/G2L-SBC.
    - **r9a07g054l2-smarc.dtb**: Device tree blob file for RZ/G2L-EVK.
    - **r9a07g054l2-smarc.dtb**: Device tree blob file for RZ/V2L-EVK.
    - **r9a09g057h4-evk-ver1.dtb**: Device tree blob file for RZ/V2H-EVK.