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
