
# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"

# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
inherit kernel-devicetree

KBRANCH:rz-cmn  = "v6.10/standard/base"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default use of yocto git repositories. Uncomment the following to overrride it to use renesas sst git repo.
# SRC_URI:rz-cmn = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

# Common config fragments
SRC_URI:append:rz-cmn = "\
	file://common/kernel-common.cfg \
	file://common/renesas_defconfig \
	file://common/panfrost.cfg \
	${@bb.utils.contains('DOCKER_SUPPORT', '1', 'file://common/docker.cfg', '', d)} \
	${@bb.utils.contains('DISTRO', 'ubuntu-tiny', 'file://common/docker.cfg', '', d)} \
	${@oe.utils.conditional("OPTIMIZE_KERN", "1", "file://common/optimize.cfg", "", d)} \
"

# RZ/G2L-SBC specific config fragments
SRC_URI:append:rz-cmn =	"\
	file://rzg2l-sbc/sii.cfg \
	file://rzg2l-sbc/laird.cfg \
	file://rzg2l-sbc/touch.cfg \
	file://rzg2l-sbc/peripherals.cfg \
	file://rzg2l-sbc/da7219.cfg \
	file://rzg2l-sbc/drm_panel.cfg \
	file://rzg2l-sbc/ov5640.cfg \
"

# RZ/V2L-EVK specific config fragments
SRC_URI:append:rz-cmn =	"\
	file://rzv2l-evk/wm8978.cfg \
"

# RZG2L-SBC patches
SRC_URI:append:rz-cmn = "\
	file://rzg2l-sbc/0001-arm64-dts-renesas-Refactor-RZ-SBC-device-tree-and-re.patch \
	file://rzg2l-sbc/0002-arm64-dts-rzpi-restore-power-domains-property.patch \
	file://rzg2l-sbc/0003-arm64-rzpi-support-audio-for-RZ-G2L-SBC.patch \
	file://rzg2l-sbc/0004-media-rzg2l-cru-add-WA-to-retry-CRU-initialization-w.patch \
	file://rzg2l-sbc/0005-clk-renesas-add-WDT2-clocks-and-reset-support-for-r9.patch \
	file://rzg2l-sbc/0006-drivers-gpu-panel-add-waveshare-panel-support-for-RZ.patch \
	file://rzg2l-sbc/0007-drivers-rcar-du-rzg2l-add-clock-calculation-logic-fo.patch \
	file://rzg2l-sbc/0008-rzg2l-sbc-Add-vcp4-module-to-device-tree.patch \
	file://rzg2l-sbc/0009-rzg2l-sbc-Support-more-fourcc-format-for-CRU.patch \
	file://rzg2l-sbc/0010-rz-sbc-rename-rzpi-to-rzg2l-sbc-across-all-files-10.patch \
	file://rzg2l-sbc/0011-rzg2l-sbc-Prevent-disable-eth0-before-eth1.patch \
"

# RZ/V2H-EVK patches
SRC_URI:append:rz-cmn =	"\
	file://rzv2h-evk/0001-rzv2h-evk-Support-RZV2H-EVK.patch \
"

KERNEL_FEATURES:append = " sii.cfg laird.cfg touch.cfg peripherals.cfg da7219.cfg drm_panel.cfg ov5640.cfg panfrost.cfg kernel-common.cfg ${@oe.utils.conditional('OPTIMIZE_KERN', '1', ' optimize.cfg', '', d)}"

KCONFIG_MODE:rz-cmn = "alldefconfig"
KMACHINE:rz-cmn ?= "renesas_defconfig"
#KBUILD_DEFCONFIG:rz-cmn ?= "defconfig"

# List of device tree names for rz-cmn
DEVICETREE_NAME:rz-cmn = "rzg2l-sbc r9a07g044l2-smarc r9a07g054l2-smarc r9a09g057h4-evk-ver1"

# Supported device tree and device tree overlays
KERNEL_DEVICETREE:rz-cmn = "${@' '.join(['renesas/%s.dtb' % devicetree_name for devicetree_name in d.getVar('DEVICETREE_NAME').split()])}"

KERNEL_DEVICETREE:append:rz-cmn = " \
	renesas/overlays/rzg2l-sbc-can.dtbo \
	renesas/overlays/rzg2l-sbc-ext-i2c.dtbo \
	renesas/overlays/rzg2l-sbc-ext-spi.dtbo \
	renesas/overlays/rzg2l-sbc-dsi.dtbo \
	renesas/overlays/rzg2l-sbc-ov5640.dtbo \
"

# Override the dtc flags to support dtbo build in kernel-devicetree.bbclass
KERNEL_DTC_FLAGS = "-@"

# Install overlays folder and kernel images to target/images in build folder
do_deploy:append:rz-cmn(){
	install -d ${DEPLOYDIR}/target/images/dtbs/overlays
	install -m 0644 ${B}/arch/arm64/boot/dts/renesas/overlays/* ${DEPLOYDIR}/target/images/dtbs/overlays

	install -m 0644 ${B}/arch/arm64/boot/Image ${DEPLOYDIR}/target/images/${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin
	ln -sf ${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/Image

	for dtb_name in ${DEVICETREE_NAME}; do
	install -m 0644 ${B}/arch/arm64/boot/dts/renesas/${dtb_name}.dtb ${DEPLOYDIR}/target/images/dtbs/${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext
	ln -sf ${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext ${DEPLOYDIR}/target/images/dtbs/${dtb_name}.dtb
	done
}

SRCREV_machine:rz-cmn ?= "${AUTOREV}"
LINUX_VERSION:rz-cmn ?= "6.10.14"
