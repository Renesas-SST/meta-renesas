SUMMARY = "Custom RZ Ubuntu Image"
LICENSE = "MIT"
require include/core-image-renesas-mmp.inc
require include/renesas-qt5-framework.inc
require include/core-image-renesas-base.inc
inherit core-image

IMAGE_INSTALL:append = "\
	v4l-utils \
	v4l2-init \
"

# Packages for Wi-Fi and Bluetooth support
IMAGE_INSTALL:append = " \
    net-tools \
    phytool \
    lwb-fcc-firmware \
    summit-supplicant-lwb \
    iw \
    ethtool \
    iperf3 \
    tcpdump \
    bluez5 \
    bluez5-dev \
    obexftp \
"

# Add QT to rootfs
IMAGE_INSTALL:append = " packagegroup-qt5 packagegroup-qt5-examples kernel-module-uvcvideo"

# Add weston to rootfs
CORE_IMAGE_BASE_INSTALL += "weston"

# compatible machine comes with linux-yocto but not available in this build
# so bring back these parameters
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"

IMAGE_FSTYPES = " tar.bz2"
MACHINEOVERRIDES =. "rz-cmn:"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"
