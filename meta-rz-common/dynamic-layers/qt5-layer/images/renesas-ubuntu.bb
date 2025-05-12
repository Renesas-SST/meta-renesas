SUMMARY = "Custom RZPi Image"
LICENSE = "MIT"
require include/core-image-renesas-mmp.inc
require include/core-image-renesas-qt.inc
require include/core-image-renesas-base.inc
inherit core-image

IMAGE_INSTALL_append = "\
	v4l-utils \
	v4l2-init \
"
# Packages for Wi-Fi and BT support for sbc
IMAGE_INSTALL_append = " \
	lwb-fcc-firmware \
	kernel-module-lwb5p-backports-summit \
	summit-supplicant-lwb \
"

# Add QT to rootfs
IMAGE_INSTALL_append = " packagegroup-qt5 packagegroup-qt5-examples kernel-module-uvcvideo"

# Add weston to rootfs
CORE_IMAGE_BASE_INSTALL += "weston"

# compatible machine comes with linux-yocto but not available in this build
# so bring back these parameters
COMPATIBLE_MACHINE = "(rzpi)"

IMAGE_FSTYPES = " tar.bz2"
# bootloader for rzsbc
DEPENDS += " firmware-pack"
MACHINEOVERRIDES =. "rzg2l:"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"
