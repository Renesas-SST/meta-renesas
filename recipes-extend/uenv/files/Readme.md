# How to configure the environment variables in uEnv.txt

It is possible to set U-Boot environment variables in uEnv.txt file.
You can set U-Boot environment variables in the uEnv.txt file, which is located on the FAT32 partition (in partition 1). Modify this file to match your U-Boot environment settings.
To load the devicetree overlay file from "overlays/" folder, you should set "enable_overlay_".
Also you can set some environment variables from U-Boot to overwrite the old settings.

Refer to the following description for different loading options.

## For RZ CMN U-Boot Env

Overlays are supported for all RZ CMN boards. Each board has its own individual overlay settings. Enabling overlays intended for other boards may have no effect.

The device tree overlay loading follows the pattern `${model_string}-${revision_major}.${revision_minor}`. These U-Boot environment variables are automatically set by U-Boot during runtime. Details:

- `${model_string}`: Board model string (e.g., `rzg2l-sbc`)
- `${revision_major}`: Board major revision
- `${revision_minor}`: Board minor revision

Sample `rzg2l-sbc` device tree overlay list:

- `rzg2l-sbc-1.0-ext-i2c.dtbo`
- `rzg2l-sbc-1.0-ext-spi.dtbo`
- `rzg2l-sbc-1.0-can.dtbo`
- `rzg2l-sbc-1.0-dsi.dtbo`
- `rzg2l-sbc-1.0-ov5640.dtbo`

| Config                        | Description                                         | Value if set | To be loading                                                               | Board supported          |
| ----------------------------  | -------------------------------------------         | ------------ | -----------------------------------------------------------------------     | ----------------------   |
| `enable_overlay_i2c`          | Enable external I2C bus on expansion header         | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-ext-i2c.dtbo            | RZ/G2L-SBC               |
| `enable_overlay_spi`          | Enable external SPI bus on expansion header         | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-ext-spi.dtbo            | RZ/G2L-SBC, RZ/V2H-RDK   |
| `enable_overlay_can`          | Enable CAN controller and pin mux                   | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-can.dtbo                | RZ/G2L-SBC, RZ/V2H-RDK   |
| `enable_overlay_dsi`          | Enable MIPI-DSI display interface                   | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-dsi.dtbo                | RZ/G2L-SBC, IMDT-V2H-SBC |
| `enable_overlay_audio_codec`  | Enable on-board analog audio codec                  | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-audio_codec.dtbo        | RZ/V2H-RDK               |
| `enable_overlay_csi_ov5640`   | Enable MIPI-CSI camera module OV5640                | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-ov5640.dtbo             | RZ/G2L-SBC               |
| `enable_overlay_csi_ov5645`   | Enable MIPI-CSI camera module OV5645                | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-cru-csi-ov5645.dtbo     | RZ/G2L-EVK, RZ/V2L-EVK   |
| `enable_overlay_csi22_ar1335` | Enable MIPI-CSI2 AR1335 camera on slot 3 (CSI2-2)   | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-cru-csi22-ar1335.dtbo   | IMDT-V2H-SBC             |
| `enable_overlay_csi23_ar1335` | Enable MIPI-CSI2 AR1335 camera on slot 4 (CSI2-3)   | '1' or 'yes' | ${model_string}-${revision_major}.${revision_minor}-cru-csi23-ar1335.dtbo   | IMDT-V2H-SBC             |
---

```
default settings:
    #enable_overlay_i2c=1
    #enable_overlay_spi=1
    #enable_overlay_can=1
    #enable_overlay_dsi=1
    #enable_overlay_audio_codec=1
    #enable_overlay_csi_ov5640=1
    #enable_overlay_csi_ov5645=1
    #enable_overlay_csi22_ar1335=1
    #enable_overlay_csi23_ar1335=1
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
