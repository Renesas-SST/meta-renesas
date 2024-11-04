require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-quickboot.inc
require include/core-image-renesas-qt.inc

SUMMARY = "Renesas core image for Linux quickboot with Wayland, QT support"

# Install scripts that help the user enable or disable the networking stack using systemd
IMAGE_INSTALL_append = " systemd-network-control-wayland"

IMAGE_INSTALL_append = " packagegroup-qt5"

ROOTFS_POSTPROCESS_COMMAND += ' sed_service_sytemd_quickboot;'

ROOTFS_POSTPROCESS_COMMAND += ' optimize_service_sytemd_wayland;'

ROOTFS_POSTPROCESS_COMMAND += ' mask_systemd_networking;'

ROOTFS_POSTPROCESS_COMMAND += ' mask_unused_services;'

ROOTFS_POSTPROCESS_COMMAND += ' off_load_systemd_generators;'

ROOTFS_POSTPROCESS_COMMAND += ' blacklist_modules;'

