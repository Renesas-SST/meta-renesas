LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rzg2l-sbc|rz-cmn)$"

# Kernel is 5.10
inherit kernel
require recipes-kernel/linux/linux-yocto.inc

SRC_URI:rz-cmn = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"
SRC_URI:append:rz-cmn =	"\
					file://sii.cfg		\
					file://laird.cfg	\
					file://touch.cfg	\
				"

KBRANCH:rz-cmn  = "dunfell/rz-sbc"



KCONFIG_MODE:rz-cmn ?= "alldefconfig"
# Use the following to specify an in-tree defconfig.
# KBUILD_DEFCONFIG:multi-boards = "rzpi"

SRCREV_machine:rz-cmn ?= "${AUTOREV}"

LINUX_VERSION:rz-cmn = "5.10.184"
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
