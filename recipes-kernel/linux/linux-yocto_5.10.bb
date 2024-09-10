LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"

SRC_URI:rzg2l-sbc = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

# Kernel is 5.10
inherit kernel
require recipes-kernel/linux/linux-yocto.inc

KBRANCH:rzg2l-sbc  = "dunfell/rz-sbc"

#KMACHINE:rzg2l-sbc ?= "defconfig"

# Use the following to specify an in-tree defconfig.
KBUILD_DEFCONFIG:rzg2l-sbc = "defconfig"

SRCREV_machine:rzg2l-sbc ?= "${AUTOREV}"

# Override KCONFIG_MODE to '--alldefconfig' from the default '--allnoconfig'
KCONFIG_MODE:rzg2l-sbc = "alldefconfig"

LINUX_VERSION:rzg2l-sbc = "5.10.184"
#LINUX_VERSION_EXTENSION:append = "-custom"

# Supported device tree and device tree overlays
KERNEL_DEVICETREE = " \
        renesas/rzpi.dtb \
"
KERNEL_DEVICETREE_OVERLAY = " \
        renesas/overlays/rzpi-can.dtbo \
        renesas/overlays/rzpi-ext-i2c.dtbo \
        renesas/overlays/rzpi-ext-spi.dtbo \
        renesas/overlays/rzpi-dsi.dtbo \
        renesas/overlays/rzpi-ov5640.dtbo \
"

IMAGE_BOOT_FILES = " Image rzpi.dtb"

# Support DTB Overlay files
IMAGE_BOOT_FILES += " overlays/*;overlays/"

PV = "${LINUX_VERSION}+git"
PACKAGE_ARCH = "${MACHINE_ARCH}"
