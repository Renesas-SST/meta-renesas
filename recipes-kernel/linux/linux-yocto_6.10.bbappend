
# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"
COMPATIBLE_MACHINE = "^(aarch64|rzg2l-sbc)$"

# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
#require recipes-kernel/linux/linux-yocto-inc
inherit kernel-devicetree

KBRANCH:rzg2l-sbc  = "v6.10/standard/base"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default use of yocto git repositories. Uncomment the following to overrride it to use renesas sst git repo.
# SRC_URI:rzg2l-sbc = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

SRC_URI:append:rzg2l-sbc =	"\
					file://sii.cfg		\
					file://laird.cfg	\
					file://touch.cfg	\
					file://peripherals.cfg	\
					file://da7219.cfg \
					file://drm_panel.cfg \
					file://ov5640.cfg \
					file://panfrost.cfg \
				"
# Apply patches for novtech board
SRC_URI:append:rzg2l-sbc = "\
                    file://dts-patches/0001-arm64-dts-renesas-Refactor-RZ-SBC-device-tree-and-re.patch \
                    file://dts-patches/0002-arm64-dts-rzpi-restore-power-domains-property.patch \
                    file://dts-patches/0003-arm64-rzpi-support-audio-for-RZ-G2L-SBC.patch \
                    file://dts-patches/0004-media-rzg2l-cru-add-WA-to-retry-CRU-initialization-w.patch \
                    file://dts-patches/0005-clk-renesas-add-WDT2-clocks-and-reset-support-for-r9.patch \
                    file://dts-patches/0006-drivers-gpu-panel-add-waveshare-panel-support-for-RZ.patch \
                    file://dts-patches/0007-drivers-rcar-du-rzg2l-add-clock-calculation-logic-fo.patch \
                "

KERNEL_FEATURES:append = " sii.cfg laird.cfg touch.cfg peripherals.cfg da7219.cfg drm_panel.cfg ov5640.cfg panfrost.cfg"

KCONFIG_MODE:rzg2l-sbc = "alldefconfig"
#KMACHINE:rzg2l-sbc ?= "rzg2l-sbc"
KBUILD_DEFCONFIG:rzg2l-sbc ?= "defconfig"

# Use the following to specify an in-tree defconfig.
# KBUILD_DEFCONFIG:rzg2l-sbc = "rzpi"

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

SRCREV_machine:rzg2l-sbc ?= "${AUTOREV}"
LINUX_VERSION:rzg2l-sbc ?= "6.10.14"
