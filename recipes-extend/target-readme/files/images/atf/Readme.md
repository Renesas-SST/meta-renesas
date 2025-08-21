
# Overview

Arm Trusted Firmware-A (TF-A) binaries and TF-A configuration DTBs (FDTS).

# Top-level layout

```
atf/
├── bl2-rz-cmn.bin
├── bl31-rz-cmn.bin
├── fdts/
└── Readme.md
```

- `bl2-*.bin` – BL2 stage (early init, loads BL31/U-Boot).
- `bl31-*.bin` – BL31 (EL3 runtime firmware).
- `fdts/` – TF-A DTBs consumed by FCONF.

**Note**: BL2/BL31 are shared across boards; per-board specifics are provided via FDTS DTBs. Universal script will help to merge the TF-A DTBs to BL2.