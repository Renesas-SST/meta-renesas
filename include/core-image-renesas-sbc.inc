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

CORE_IMAGE_EXTRA_INSTALL += " packagegroup-tools-bluetooth "
