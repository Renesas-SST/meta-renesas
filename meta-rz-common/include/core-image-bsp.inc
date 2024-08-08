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
    cp ${DEPLOY_DIR_IMAGE}/target/images/dtbs/overlays/* ${IMAGE_ROOTFS}/boot/overlays
}

add_bootloader_rootfs() {
    install -d ${IMAGE_ROOTFS}/boot/uload-bootloader
    cp -rf ${DEPLOY_DIR_IMAGE}/target/images/bl2_bp-rzpi.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
    cp -rf ${DEPLOY_DIR_IMAGE}/target/images/fip-rzpi.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
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

# Clean the output directory after the build
do_release_clean() {    
    rm -f ${DEPLOY_DIR_IMAGE}/Image*
    rm -f ${DEPLOY_DIR_IMAGE}/rzpi*
    rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}*
    rm -f ${DEPLOY_DIR_IMAGE}/fip-rzpi*
    rm -f ${DEPLOY_DIR_IMAGE}/bl2*
}

addtask release_clean after do_image_complete before do_populate_lic_deploy

ROOTFS_POSTPROCESS_COMMAND += " add_overlays_rootfs; add_bootloader_rootfs; deploy_package;"

DEPENDS += " firmware-pack linux-renesas"

# Install core-image-qt.env to target/env
python do_rootfs_wicenv_append () {
    target_dir = os.path.join(depdir, 'target/env')
    os.makedirs(target_dir, exist_ok=True)
    bb.utils.copyfile(os.path.join(outdir, basename) + '.env', os.path.join(target_dir, basename) + '.env')
}

# Install file rootfs.manifest to host/build
python write_image_manifest_append () {
    # Create target dir host/build
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .manifest file to the deploy_dir/host/build folder
    target_manifest = os.path.join(target_dir, os.path.basename(manifest_name))
    os.system(f"cp {manifest_name} {target_manifest}")

    # Create a symbolic link to the new manifest file in the deploy directory
    if os.path.exists(target_manifest) and link_name:
        target_manifest_link = os.path.join(target_dir, link_name + ".manifest")
        if target_manifest_link != target_manifest:
            if os.path.lexists(target_manifest_link):
                os.remove(target_manifest_link)
            os.symlink(os.path.basename(target_manifest), target_manifest_link)
}

# Install file testdata.json to host/build
python write_image_test_data_append () {
    # Create the directory deploy_dir/host/build
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .testdata.json file to deploy_dir/host/build
    target_testdata = os.path.join(target_dir, os.path.basename(testdata_name))
    os.system(f"cp {testdata_name} {target_testdata}")

    # Create a symbolic link in deploy_dir pointing to the new file in deploy_dir/host/build
    if os.path.exists(target_testdata) and link_name:
        target_testdata_link = os.path.join(target_dir, "%s.testdata.json" % link_name)
    if os.path.lexists(target_testdata_link):
        os.remove(target_testdata_link)
    os.symlink(os.path.basename(target_testdata), target_testdata_link)
}

# Move wic file from deploy complete folder to target/images directory
IMAGE_CMD_wic_prepend() {
    target_dir="${IMGDEPLOYDIR}/target/images"

    # Create the target directory if it does not exist
    mkdir -p "${target_dir}"

    # Check if the build artifact for the wic image exists; if not, copy it to the build directory
    if [ ! -f "${DEPLOY_DIR_IMAGE}/Image" ]; then
        cp "${DEPLOY_DIR_IMAGE}/target/images/Image" "${DEPLOY_DIR_IMAGE}/"
    fi

    if [ ! -f "${DEPLOY_DIR_IMAGE}/rzpi.dtb" ]; then
        cp "${DEPLOY_DIR_IMAGE}/target/images/dtbs/rzpi.dtb" "${DEPLOY_DIR_IMAGE}/"
    fi
}

IMAGE_CMD_wic_append() {
    # Remove existing wic file and move the output to target directory
    rm -f "${target_dir}"/*.wic
    mv "$out${IMAGE_NAME_SUFFIX}.wic" "${target_dir}/${IMAGE_LINK_NAME}.wic"
}

# Move tar file from deploy complete folder to target/images/rootfs directory
CONVERSION_CMD_bz2_append() {
    # Define the target directory and file path
    out="${IMGDEPLOYDIR}/${IMAGE_NAME}"
    target_dir="${IMGDEPLOYDIR}/target/images/rootfs"

    # Create the target directory if it does not exist
    mkdir -p "${target_dir}"

    # Remove existing tar file and move the output to target directory
    rm -f "${target_dir}"/*.tar.bz2
    mv "${out}${IMAGE_NAME_SUFFIX}.tar.bz2" "${target_dir}/${IMAGE_LINK_NAME}.tar.bz2"
}
