# How to configure the environment variables in uEnv.txt

It is possible to set U-Boot environment variables in uEnv.txt file.
You can set U-Boot environment variables in the uEnv.txt file, which is located on the FAT32 partition (in partition 1). Modify this file to match your U-Boot environment settings.
To load the devicetree overlay file from "overlays/" folder, you should set "enable_overlay_".
Also you can set some environment variables from U-Boot to overwrite the old settings.

Refer to the following description for different loading options.

## For RZ CMN U-Boot Env

Overlays are currently supported only on the RZ/G2L-SBC. Enabling them on other boards may have no effect.

| Config                    | Value if set | To be loading       |
|---------------------------|--------------|---------------------|
| `enable_overlay_i2c`      | '1' or 'yes' | rzg2l-sbc-ext-i2c.dtbo   |
| `enable_overlay_spi`      | '1' or 'yes' | rzg2l-sbc-ext-spi.dtbo   |
| `enable_overlay_can`      | '1' or 'yes' | rzg2l-sbc-can.dtbo       |
| `enable_overlay_dsi`      | '1' or 'yes' | rzg2l-sbc-dsi.dtbo       |
| `enable_overlay_csi_ov5640` | '1' or 'yes' | rzg2l-sbc-ov5640.dtbo    |

---

```
default settings:
    #enable_overlay_i2c=1
    #enable_overlay_spi=1
    #enable_overlay_can=1
    #enable_overlay_dsi=1
    #enable_overlay_csi_ov5640=1
```

## How to add a new board

U-Boot's environment already supports user-defined hooks. To load a new device tree for a new board without rebuilding U-Boot, add a rule in `uEnv.txt` that sets fdtfile when the board's identifiers match.

```shell
# Set fdtfile to "new-board.dtb" when the board model and revision match.
# This tells U-Boot which device tree to load and pass to the kernel at boot.
# Replace "model-string", "1", and "0" with your board's actual identifiers.
fdt_user_cases=if test "${model_string}" = "model-string" -a "${revision_major}" = "1" -a "${revision_minor}" = "0"; then setenv fdtfile new-board.dtb; fi
```

### How it works

- **fdt_user_cases**: Executed after the built-in selection table. When fdtfile remains unset, this hook can be used to assign a DTB.
- **Identifiers**: `model_string`, `revision_major`, and `revision_minor` come from the board-info blob generated from [platform_info.json](https://github.com/Renesas-SST/meta-renesas/blob/styhead/rz-cmn/recipes-tools/binmake/files/platform_info.json) in the build system. These values must match the identifiers for the target hardware.

**Note**: If the condition matches the board identification, then `new-board.dtb` will be loaded during kernel boot. The `new-board.dtb` file should be placed under partition 1 (FAT32) at `dtb/renesas/new-board.dtb`.