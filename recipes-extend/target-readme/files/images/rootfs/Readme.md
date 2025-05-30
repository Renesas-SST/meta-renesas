# RZ Common rootfs folder

## Description

This directory contains the compressed root filesystem image used for deploying to the RZ Common (support multi boards) platform. It includes the primary root filesystem image and this documentation.

## A top-level directory of rootfs

```
rootfs                                                  
├── core-image-weston.tar.bz2            <---- Compressed root filesystem image
└── Readme.md                                   <---- This document
```

### Files
- **core-image-weston.tar.bz2**: Compressed tarball of the root filesystem image for the RZ Common.
The above structure is an example when building using the target image `IMAGE=core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `core-image-weston`. Other target images will have the same structure.

