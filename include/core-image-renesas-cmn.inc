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

# Packages for users application development
IMAGE_INSTALL:append = " \
    apt \
    dpkg \
    python3-tkinter \
    python3-numpy \
    python3-pandas \
    python3-pyserial \
    python3-matplotlib \
    python3-pip \
    apt-sources-config \
"

CORE_IMAGE_EXTRA_INSTALL += " packagegroup-tools-bluetooth "
