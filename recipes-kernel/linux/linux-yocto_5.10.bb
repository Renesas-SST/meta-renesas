LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"

SRC_URI:rzg2l-sbc = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

# Tell the kernel class to install the DTBs in the same directory structure as the kernel.
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

# Kernel is 5.10
inherit kernel
inherit kernel-devicetree
require recipes-kernel/linux/linux-yocto.inc

KBRANCH:rzg2l-sbc  = "dunfell/rz-sbc"

# Use the following to specify an in-tree defconfig.
KBUILD_DEFCONFIG:rzg2l-sbc = "defconfig"

SRCREV_machine:rzg2l-sbc ?= "${AUTOREV}"

# Override KCONFIG_MODE to '--alldefconfig' from the default '--allnoconfig'
KCONFIG_MODE:rzg2l-sbc = "alldefconfig"

LINUX_VERSION:rzg2l-sbc = "5.10.184"

# Supported device tree and device tree overlays
KERNEL_DEVICETREE:rzg2l-sbc = " \
        renesas/rzpi.dtb \
"

KERNEL_DEVICETREE:append:rzg2l-sbc = " \
        renesas/overlays/rzpi-can.dtbo \
        renesas/overlays/rzpi-ext-i2c.dtbo \
        renesas/overlays/rzpi-ext-spi.dtbo \
        renesas/overlays/rzpi-dsi.dtbo \
        renesas/overlays/rzpi-ov5640.dtbo \
"

# Override the dtc flags to support dtbo build in kernel-devicetree.bbclass
KERNEL_DTC_FLAGS = "-@"

# Install overlays folder and kernel images to target/images in build folder
do_deploy:append:rzg2l-sbc(){
    install -d ${DEPLOYDIR}/target/images/dtbs/overlays
    install -m 0644 ${B}/arch/arm64/boot/dts/renesas/overlays/* ${DEPLOYDIR}/target/images/dtbs/overlays

    install -m 0644 ${B}/arch/arm64/boot/Image ${DEPLOYDIR}/target/images/${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin
    ln -sf ${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/Image

    install -m 0644 ${B}/arch/arm64/boot/dts/renesas/rzpi.dtb ${DEPLOYDIR}/target/images/dtbs/rzpi-${KERNEL_DTB_NAME}.$dtb_ext
    ln -sf rzpi-${KERNEL_DTB_NAME}.$dtb_ext ${DEPLOYDIR}/target/images/dtbs/rzpi.dtb
}

PV = "${LINUX_VERSION}+git"
PACKAGE_ARCH = "${MACHINE_ARCH}"
