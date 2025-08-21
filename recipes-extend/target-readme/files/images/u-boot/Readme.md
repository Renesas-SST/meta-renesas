# RZ Common U-boot readme

## Overview

U-boot

## Top-level layout

```
u-boot/
├── dtbs/
├── u-boot-nodtb-<MACHINE>.bin
└── Readme.md
```

- `u-boot-nodtb-<machine>.bin` – U-Boot without embedded DTB (DTB is selected per board).
- `dtbs/` – per-board U-Boot DTBs.

**Note**: the universal flashing script will pair u-boot-nodtb-*.bin with the correct U-Boot DTB for your board.