# RZ Common Linux folder

## Overview

Linux kernel and device trees for the target images.

## Structure

```
linux/
├── dtbs/
├── Image -> Image--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.bin
├── Image--6.10.14+git0+<commit-hash>-r0-rz-cmn-<timestamp>.bin
└── Readme.md
```

- `Image` - kernel image (symlink to versioned Image--…bin).
- `dtbs/` - board DTBs and overlay DTBOs.