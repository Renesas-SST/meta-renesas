# RZ/G2L-SBC rootfs folder

## Description

This directory contains the compressed root filesystem image used for deploying to the RZ/G2L-SBC platform. It includes the primary root filesystem image and this documentation.

## A top-level directory of rootfs

```
rootfs/
├── core-image-bsp-rzg2l-sbc.tar.bz2
├── core-image-minimal-rzg2l-sbc.tar.bz2
├── core-image-weston-rzg2l-sbc.tar.bz2
├── Readme.md
├── renesas-core-image-cli-rzg2l-sbc.tar.bz2
├── renesas-core-image-weston-rzg2l-sbc.tar.bz2
├── renesas-quickboot-cli-rzg2l-sbc.tar.bz2
├── renesas-quickboot-wayland-rzg2l-sbc.tar.bz2
├── renesas-ubuntu-rzg2l-sbc.tar.bz2
├── ubuntu-core-image-rzg2l-sbc.tar.bz2
└── ubuntu-lxde-image-rzg2l-sbc.tar.bz2

0 directories, 12 files
```

## Content breakdown

### `rootfs/`
- Contains root filesystem archives `.tar.bz2`, these archives can be extracted or used directly depending on your boot method (e.g., NFS boot, manual rootfs deployment).

### `Readme.md`
- This Readme explains the purpose and contents of this directory.