# RZ/G2L-SBC env folder

## Description

This directory contains essential environment setup files for the RZ/G2L-SBC platform, specifically for managing and configuring the build environment and boot process.

## A top-level directory of env folder

```
env                             
├── core-image-qt.env           <---- Environment file specific to core-image-qt in yocto build
├── uEnv.txt                    <---- Environment setup files for configuring the bootloader
└── Readme.md                   <---- This document
```

### Files:
- **core-image-qt.env**: This file sets up the environment variables required for building and deploying the core-image-qt image on the RZ/G2L-SBC platform using Yocto.
- **uEnv.txt**: Configuration file for the bootloader, which defines specific boot parameters for the RZ/G2L-SBC board.
