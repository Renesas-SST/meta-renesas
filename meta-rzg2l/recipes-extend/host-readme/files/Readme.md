# RZ/G2L-SBC host folder

## Description

This directory contains files and tools used for managing and deploying images to the RZ/G2L-SBC platform. It includes build artifacts, manifests, test data, and documentation.

## A top-level directory of host

```
host
├── build
│   ├── core-image-qt-rzpi-20240717204209.rootfs.manifest                                       # Manifest file for the root filesystem
│   ├── core-image-qt-rzpi-20240717204209.testdata.json                                         # Test data for the image
│   ├── core-image-qt-rzpi.manifest -> core-image-qt-rzpi-20240717204209.rootfs.manifest        # Symlink to the root filesystem manifest
│   └── core-image-qt-rzpi.testdata.json -> core-image-qt-rzpi-20240717204209.testdata.json     # Symlink to the test data JSON
├── Readme.md                                                                                   # This document
├── src                                                                                         # Build script folder
│   ├── git_patch.json
│   ├── jq-linux-amd64
│   ├── patches
│   ├── README.md
│   ├── rzsbc_yocto.sh
│   └── site.conf
└── tools/                                                                                      # Tools and scripts used for managing and flashing bootloaders and filesystems across different platforms
```

## Note

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
