# How to configure the environment variables in uEnv.txt

It is possible to set U-Boot environment variables in uEnv.txt file.
You can set U-Boot environment variables in the uEnv.txt file, which is located on the FAT32 partition (in partition 1). Modify this file to match your U-Boot environment settings.
To load the devicetree overlay file from "overlays/" folder, you should set "enable_overlay_".
Also you can set some environment variables from U-Boot to overwrite the old settings.

Refer to the following description for different loading options.


## For RZ SBC U-Boot Env
/------------------------------|--------------|------------------------------
|       Config                 | Value if set |     To be loading
|------------------------------|--------------|------------------------------
| enable_overlay_i2c           | '1' or 'yes' |  rzpi-ext-i2c.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_spi           | '1' or 'yes' |  rzpi-ext-spi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_can           | '1' or 'yes' |  rzpi-can.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_dsi           | '1' or 'yes' |  rzpi-dsi.dtbo
|------------------------------|--------------|------------------------------
| enable_overlay_csi_ov5640    | '1' or 'yes' |  rzpi-ov5640.dtbo
|----------------------------------------------------------------------------
| fdtfile   : is a base dtb file, should be set rzpi.dtb
|----------------------------------------------------------------------------
| uboot env : you could set U-Boot's environment variables here, such as 'console=' 'bootargs='
\---------------------------------------------------------------------------

default settings:
    fdtfile=rzpi.dtb
    #enable_overlay_i2c=1
    #enable_overlay_spi=1
    #enable_overlay_can=1
    #enable_overlay_dsi=1
    #enable_overlay_csi_ov5640=1
