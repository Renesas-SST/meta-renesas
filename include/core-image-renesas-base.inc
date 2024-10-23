# Basic packages/tools
IMAGE_INSTALL:append = " \
    bash \
    coreutils \
    can-utils \
    i2c-tools \
    spitools \
    python3-smbus \
    python3-smbus2 \
    ethtool \
    iproute2 \
    iperf3 \
    libgpiod \
    libgpiod-tools \
    libgpiod-dev \
"

DEPENDS += " linux-yocto"
