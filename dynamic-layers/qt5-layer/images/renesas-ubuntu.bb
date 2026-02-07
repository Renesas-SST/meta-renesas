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
    kernel-module-nxp-wlan \
    linux-firmware-mt7601u \
    linux-firmware-mt7650 \
    linux-firmware-mt76x2 \
    linux-firmware-ralink \
    linux-firmware-rtl8188 \
    linux-firmware-rtl8192cu \
    linux-firmware-rtl8192su \
    linux-firmware-rtl8723 \
    linux-firmware-rtl8821 \
    linux-firmware-rtl8822 \
    linux-firmware-ath3k \
    linux-firmware-carl9170 \
    linux-firmware-ath9k \
    linux-firmware-bcm43xx \
    linux-firmware-bcm43362 \
    linux-firmware-usb8997 \
"

# Packages for IMDT utils and wireless tools
IMAGE_INSTALL:append = "\
    imdt-can-utils \
    imdt-ethernet-utils \
    imdt-wifi-utils \
    imdt-pico-modem \
    iw \
    murata-binaries \
    wireless-tools \
    hostapd \
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
