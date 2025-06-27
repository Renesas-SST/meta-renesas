# RZ Common rootfs folder

## Description

This directory contains the compressed root filesystem image used for deploying to the RZ Common (support multi boards) platform. It includes the primary root filesystem image and this documentation.

## A top-level directory of rootfs

```
rootfs/
├── core-image-bsp.tar.bz2
├── core-image-minimal.tar.bz2
├── core-image-weston.tar.bz2
├── Readme.md
├── renesas-core-image-cli.tar.bz2
├── renesas-core-image-weston.tar.bz2
├── renesas-quickboot-cli.tar.bz2
├── renesas-quickboot-wayland.tar.bz2
├── renesas-ubuntu.tar.bz2
├── ubuntu-core-image.tar.bz2
├── ubuntu-lxde-image.tar.bz2
└── Readme.md                                   <---- This document
```

### Files
- **core-image-weston.tar.bz2**: Compressed tarball of the root filesystem image for the RZ Common.
The above structure is an example when building using the target image `IMAGE=core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `core-image-weston`. Other target images will have the same structure.

### `rootfs/`
- Contains root filesystem archives `.tar.bz2`, these archives can be extracted or used directly depending on your boot method (e.g., NFS boot, manual rootfs deployment).

### `Readme.md`
- This Readme explains the purpose and contents of this directory.