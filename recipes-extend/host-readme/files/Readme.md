# RZ Common host folder

## Description

This directory contains files and tools used for managing and deploying images to the RZ Common platform. It includes build artifacts, manifests, test data, and documentation.

## A top-level directory of host

```
host
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

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
