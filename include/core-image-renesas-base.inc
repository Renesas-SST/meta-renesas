# Basic packages/tools
IMAGE_INSTALL:append = " \
    kernel-image \
    kernel-devicetree \
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
"

# Install uEnv.txt to /boot
IMAGE_INSTALL:append:rzg2l-sbc = " uenv"

DEPENDS += " linux-yocto"
