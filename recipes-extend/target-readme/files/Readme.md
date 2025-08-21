# RZ Common target folder

## Overview

This directory contains the environment setup and image files required for the target system, specifically for the RZ Common platform.

## Top-level layout

```
target/
├── env/
├── images/
└── Readme.md
```

- `env/` - Includes U-Boot environment configuration files.  
- `images/` - Includes boot and flashable image files, kernel binaries, device tree blobs, and overlays.

Each subdirectory includes its own `Readme.md` with detailed descriptions and instructions:

- See `env/Readme.md` for environment setup details.
- See `images/Readme.md` for the structure and usage of boot images and device trees.