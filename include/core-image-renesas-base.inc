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

WKS_FILE = "rzg2l-sbc-image-bootpart-mmc0.wks"

# Rootfs partition space created in Kbytes
IMAGE_ROOTFS_EXTRA_SPACE = "1048576"

# The alignment of the root filesystem image in kilobytes
IMAGE_ROOTFS_ALIGNMENT = "16"

DEPENDS += " linux-yocto"
