# RZ/G2L-SBC env folder

## Description

This directory contains the environment file, which includes Yocto build environment variables.

## A top-level directory of env folder

```
env                             
├── renesas-core-image-weston.env           <---- Environment file specific to renesas-core-image-weston in yoctobuild
└── Readme.md                   <---- This document
```

### Files:
**renesas-core-image-weston.env**: This file includes environment variables relevant to the build process of the renesas-core-image-weston image for the RZ/G2L-SBC platform using Yocto. It contains paths and configurations necessary for building, deploying, and managing the image.

The above structure is an example when building using the target image `IMAGE=renesas-core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `renesas-core-image-weston`. Other target images will have the same structure.