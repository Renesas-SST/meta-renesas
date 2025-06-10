# RZ Common host folder

## Description

This directory contains files and tools used for managing and deploying images to the RZ Common platform. It includes build artifacts, manifests, test data, and documentation.

## A top-level directory of host

```
$ tree -L 1
host/
├── build
│   ├── core-image-bsp-20250523093711.rootfs.manifest         -> Manifest file for the root filesystem
│   ├── core-image-bsp-20250523093711.testdata.json           -> Test data for the image
│   ├── core-image-bsp.manifest -> core-image-bsp-20250523093711.rootfs.manifest     -> Symlink to the root filesystem manifest
│   ├── core-image-bsp.testdata.json -> core-image-bsp-20250523093711.testdata.json  -> Symlink to the test data JSON
│   ├── core-image-minimal-20250523100902.rootfs.manifest
│   ├── core-image-minimal-20250523100902.testdata.json
│   ├── core-image-minimal.manifest -> core-image-minimal-20250523100902.rootfs.manifest
│   ├── core-image-minimal.rootfs-20250523100902.spdx.json
│   ├── core-image-minimal.rootfs.spdx.json -> core-image-minimal.rootfs-20250523100902.spdx.json
│   ├── core-image-minimal.testdata.json -> core-image-minimal-20250523100902.testdata.json
│   ├── core-image-weston-20250523095612.rootfs.manifest
│   ├── core-image-weston-20250523095612.testdata.json
│   ├── core-image-weston.manifest -> core-image-weston-20250523095612.rootfs.manifest
│   └── core-image-weston.testdata.json -> core-image-weston-20250523095612.testdata.json
├── env
│   ├── core-image-bsp.env
│   ├── core-image-minimal.env
│   ├── core-image-weston.env          -> Environment file specific to core-image-weston in yocto build
│   └── Readme.md
├── Readme.md                          -> This document
└── tools
```

## Note
The above structure is an example when building using the target image `IMAGE=core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `core-image-weston`. Other target images will have the same structure.

- `env/`: Environment variable files for Yocto builds, containing exported variables that set up the build environment for different images.

- `src/`: Contains the main build scripts, including a single script that automates building the entire Yocto project from scratch.

- `tools/`: Utility scripts and tools for flashing bootloaders, creating SD card images, with support for both Linux and Windows platforms.

## Usage

Each subdirectory includes its own `Readme.md` with detailed descriptions and instructions:

- See `env/Readme.md` for environment configurations and setting up the Yocto build environment.
- See `src/rz-cmn-srp/README.md` for details on the main build script and how to use it.
- See `tools/Readme.md`  for instructions on platform-specific utilities and deployment tools.
