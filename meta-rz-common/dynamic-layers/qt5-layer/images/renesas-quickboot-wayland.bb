require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-quickboot.inc
require include/core-image-renesas-qt.inc

SUMMARY = "Renesas core image for Linux quickboot with Wayland, QT support"

IMAGE_INSTALL_append = " packagegroup-qt5 "
