
# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"
COMPATIBLE_MACHINE = "^(aarch64|rzg2l-sbc)$"

#inherit kernel
#require recipes-kernel/linux/linux-yocto-inc

KBRANCH:rzg2l-sbc  = "v6.10/standard/base"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default use of yocto git repositories. Uncomment the following to overrride it to use renesas sst git repo.
# SRC_URI:rzg2l-sbc = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

SRC_URI:append:rzg2l-sbc =	"\
					file://sii.cfg		\
					file://laird.cfg	\
					file://touch.cfg	\
					file://peripherals.cfg	\
				"

KERNEL_FEATURES:append = " sii.cfg laird.cfg touch.cfg peripherals.cfg"

KCONFIG_MODE:rzg2l-sbc = "alldefconfig"
#KMACHINE:rzg2l-sbc ?= "rzg2l-sbc"
KBUILD_DEFCONFIG:rzg2l-sbc ?= "defconfig"

# Use the following to specify an in-tree defconfig.
# KBUILD_DEFCONFIG:rzg2l-sbc = "rzpi"

SRCREV_machine:rzg2l-sbc ?= "${AUTOREV}"

LINUX_VERSION:rzg2l-sbc = "6.10.14"
