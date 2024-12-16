# RZ/G2L-SBC rootfs folder

## Description

This directory contains the compressed root filesystem image used for deploying to the RZ/G2L-SBC platform. It includes the primary root filesystem image and this documentation.

## A top-level directory of rootfs

```
rootfs                                                  
├── renesas-core-image-weston-rzg2l-sbc.tar.bz2                  <---- Compressed root filesystem image
└── Readme.md                                   <---- This document
```

### Files
- **renesas-core-image-weston-rzg2l-sbc.tar.bz2**: Compressed tarball of the root filesystem image for the RZ/G2L-SBC.
The above structure is an example when building using the target image `IMAGE=renesas-core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `renesas-core-image-weston`. Other target images will have the same structure.

