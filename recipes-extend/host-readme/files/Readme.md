# RZ/G2L-SBC host folder

## Description

This directory contains files and tools used for managing and deploying images to the RZ/G2L-SBC platform. It includes build artifacts, manifests, test data, and documentation.

## A top-level directory of host

```
host
├── build
│   ├── renesas-core-image-weston-rzg2l-sbc-20240717204209.rootfs.manifest                                       # Manifest file for the root filesystem
│   ├── renesas-core-image-weston-rzg2l-sbc-20240717204209.testdata.json                                         # Test data for the image
│   ├── renesas-core-image-weston-rzg2l-sbc.manifest -> renesas-core-image-weston-rzg2l-sbc-20240717204209.rootfs.manifest        # Symlink to the root filesystem manifest
│   └── renesas-core-image-weston-rzg2l-sbc.testdata.json -> renesas-core-image-weston-rzg2l-sbc-20240717204209.testdata.json     # Symlink to the test data JSON
├── Readme.md                                                                                   # This document
├── env                             
│   ├── renesas-core-image-weston.env                                                                       # Environment file specific to renesas-core-image-weston in yocto build
│   └── Readme.md
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
The above structure is an example when building using the target image `IMAGE=renesas-core-image-weston`. The compressed root filesystems and the environment artifacts will have names with the prefix `renesas-core-image-weston`. Other target images will have the same structure.

Each of these subfolders have Readme's at the appropriate level in the file hierarchy to help you further.
