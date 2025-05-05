# RZ/G2L-SBC rootfs folder

## Description

This directory contains the compressed root filesystem image used for deploying to the RZ/G2L-SBC platform. It includes the primary root filesystem image and this documentation.

## A top-level directory of rootfs

```
rootfs                                                  
├── core-image-qt-rzpi.tar.bz2                  <---- Compressed root filesystem image
└── Readme.md                                   <---- This document
```

### Files
- **core-image-qt-rzpi.tar.bz2**: Compressed tarball of the root filesystem image for the RZ/G2L-SBC.

### Note

- The above structure is an example when building with the target image `IMAGE=core-image-qt`. The compressed root filesystems is `core-image-qt-rzpi.tar.bz2` (tar.bz2 format). Other target images will follow the same structure but with names corresponding to their respective target images.
