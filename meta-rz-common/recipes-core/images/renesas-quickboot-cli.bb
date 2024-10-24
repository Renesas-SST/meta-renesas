require recipes-core/images/core-image-minimal.bb
require include/core-image-renesas-base.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-quickboot.inc

SUMMARY = "Renesas core image for Linux quickboot CLI"

IMAGE_FEATURES += " \
    dev-pkgs tools-sdk \
    tools-debug debug-tweaks \
"

ROOTFS_POSTPROCESS_COMMAND += ' sed_service_sytemd_quickboot;'

ROOTFS_POSTPROCESS_COMMAND += ' optimize_service_sytemd_wayland;'

ROOTFS_POSTPROCESS_COMMAND += ' optimize_service_sytemd_cli;'

