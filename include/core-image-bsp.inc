# Basic packages
IMAGE_INSTALL:append = " \
    bonnie++ \
    util-linux \
    busybox \
    libusb1 \
    pciutils \
    usbutils \
    mtd-utils \
    dosfstools \
    e2fsprogs-badblocks \
    e2fsprogs-dumpe2fs \
    e2fsprogs-e2fsck \
    e2fsprogs-e2scrub \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    e2fsprogs-tune2fs \
    minicom \
    memtester \
    yavta \
    watchdog \
    alsa-utils \
    audio-init \
"

# Additional tools for support Tool develop
IMAGE_INSTALL:append = " \
    ckermit \
    connman \
    connman-client \
    connman-tools \
    connman-tests \
    connman-wait-online \
    tcf-agent \
"

# Camera stack: libcamera with R-Car Gen4 ISP / rkisp1 pipelines
IMAGE_INSTALL:append = " \
    libpisp \
    libcamera \
    libcamera-gst \
    libcamera-pycamera \
"

# QoS stack: qos.ko driver, libqos library and qos_tp test tool
IMAGE_INSTALL:append = " \
    kernel-module-qos \
    qosif-user-module \
    qosif-tp-user-module \
"
