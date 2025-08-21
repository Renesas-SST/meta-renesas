
## Overview

TF-A configuration device trees parsed by FCONF (AKA FDTS).

## Contents

```
fdts/
├── *.dtb       # Per-board FCONF device tree, providing TF-A runtime configuration.
└── Readme.md
```

- `*.dtb` – HW_CONFIG DTBs (per-board TF-A configuration).

**Note**: the universal script selects the correct FDTS for the selected board when flashing; no manual action is usually required.