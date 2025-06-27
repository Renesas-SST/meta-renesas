require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-cmn.inc
require include/core-image-renesas-quickboot.inc
require include/renesas-qt6-framework.inc

SUMMARY = "Renesas core image for Linux quickboot with Wayland, QT support"

# Install scripts that help the user enable or disable the networking stack using systemd
IMAGE_INSTALL:append = " systemd-network-control-wayland"

# Install a workaround scripts that restart weston after login
IMAGE_INSTALL:append = " profile-startup"

# Install qt6 libraries
IMAGE_INSTALL:append = " packagegroup-qt6 packagegroup-qt6-modules"

ROOTFS_POSTPROCESS_COMMAND += ' sed_service_systemd_quickboot;'

ROOTFS_POSTPROCESS_COMMAND += ' optimize_service_systemd_wayland;'

ROOTFS_POSTPROCESS_COMMAND += ' mask_systemd_networking;'

ROOTFS_POSTPROCESS_COMMAND += ' mask_unused_services;'

ROOTFS_POSTPROCESS_COMMAND += ' off_load_systemd_generators;'

ROOTFS_POSTPROCESS_COMMAND += ' blacklist_modules;'
