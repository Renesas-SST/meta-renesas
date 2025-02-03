require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-qt6.inc

SUMMARY = "Renesas core image with Qt6 platform support (no demo apps) based on core-image-weston"

IMAGE_INSTALL:append = " packagegroup-qt6 packagegroup-qt6-modules"
