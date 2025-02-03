require recipes-core/images/core-image-minimal.bb
require include/core-image-renesas-base.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc

SUMMARY = "Renesas core image for deploying CLI apps based on core-image-bsp"

TOOLCHAIN_TARGET_TASK += " libusb1-dev alsa-dev"
