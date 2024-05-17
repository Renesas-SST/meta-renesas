# Basic packages
IMAGE_INSTALL_append = " \
    bonnie++ \
    util-linux \
    busybox \
    libusb1 \
    pciutils \
    iproute2 \
    i2c-tools \
    can-utils \
    ethtool \
    iperf3 \
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
    alsa-utils \
    libdrm \
    libdrm-tests \
    yavta \
    kernel-module-uvcvideo \
    watchdog \
    audio-init \
"

# Installation for Wifi/Bluetooth packages
IMAGE_INSTALL_append_rzg2h = " \
    linux-firmware-ti-connectivity-license \
    linux-firmware-wl18xx \
    init-ifupdown \
    wlconf \
    init-wl18xx \
    iw \
    wpa-supplicant \
    kernel-module-wlcore-sdio \
    bt-fw \
    obexftp \
    bluez-alsa \
"

# Additional tools for support Tool develop
IMAGE_INSTALL_append = " \
    ckermit \
    connman \
    connman-client \
    connman-tools \
    connman-tests \
    connman-wait-online \
    lttng-modules \
    lttng-tools \
    lttng-ust \
    tcf-agent \
"

# Additional tools for support testing Realtime characteristic in system
IMAGE_INSTALL_append = " \
	${@oe.utils.conditional("IS_RT_BSP", "1", " rt-tests ", " ",d)} \
"

# Additional configurations for RZ SBC
IMAGE_INSTALL_append = " \
    uenv \
    uload-bootloader \
    spitools \
    python3-smbus \
    python3-smbus2 \
"

WKS_FILE = "rzg2l-sbc-image-bootpart-mmc0.wks"

# Rootfs partition space created in Kbytes
IMAGE_ROOTFS_EXTRA_SPACE = "1048576"

# The alignment of the root filesystem image in kilobytes
IMAGE_ROOTFS_ALIGNMENT = "16"

add_overlays_rootfs() {
    install -d ${IMAGE_ROOTFS}/boot/overlays
    cp ${DEPLOY_DIR_IMAGE}/overlays/* ${IMAGE_ROOTFS}/boot/overlays
}

add_bootloader_rootfs() {
    install -d ${IMAGE_ROOTFS}/boot/uload-bootloader
    cp -rf ${DEPLOY_DIR_IMAGE}/uload-bootloader/* ${IMAGE_ROOTFS}/boot/uload-bootloader
}

deploy_package() {
    rm -f ${DEPLOY_DIR_IMAGE}/bl31*
    rm -f ${DEPLOY_DIR_IMAGE}/*_esd-*
    rm -f ${DEPLOY_DIR_IMAGE}/*pmic*
    rm -f ${DEPLOY_DIR_IMAGE}/*PMIC*
    rm -f ${DEPLOY_DIR_IMAGE}/*.elf
    rm -f ${DEPLOY_DIR_IMAGE}/Image-rzpi*
    rm -f ${DEPLOY_DIR_IMAGE}/rzpi-rzpi*
    rm -f ${DEPLOY_DIR_IMAGE}/modules*
    rm -f ${DEPLOY_DIR_IMAGE}/u-boot*

    # Remove overlays document readme.txt from output folder
    rm -f ${DEPLOY_DIR_IMAGE}/readme.txt
}

# Package the wic file for filesystem flashing on Windows
do_release() {
    cp -rf ${DEPLOY_DIR_IMAGE}/*.rootfs.wic ${DEPLOY_DIR_IMAGE}/filesystem-windows-script/images/core-image-qt-rzpi.wic
}

addtask release after do_image_complete before do_populate_lic_deploy

DEPENDS += " firmware-pack linux-renesas"
ROOTFS_POSTPROCESS_COMMAND += " add_overlays_rootfs; add_bootloader_rootfs; deploy_package;"
