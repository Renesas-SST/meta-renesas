# RZ Common U-boot device tree readme

## Overview

This directory contains per-board U-Boot device trees. These DTBs are used exclusively by U-Boot and are not identical to the Linux kernel device trees. They describe only the hardware required at the U-Boot stage (clocks, memory, peripherals needed for boot).

## Folder hierarchy
```
dtbs/
├── *.dtb       # Per-board U-Boot device trees
└── Readme.md
```

- *.dtb: Per-board U-Boot DTBs, selected automatically during build or flash based on the board.

**Note:** The correct U-Boot DTB is usually chosen by the flash scripts; manual selection is rarely necessary.