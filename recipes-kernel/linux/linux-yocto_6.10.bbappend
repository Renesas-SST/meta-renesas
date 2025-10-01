# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
inherit kernel-devicetree

KBRANCH:rz-cmn  = "styhead/rz-cmn"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default use of yocto git repositories. Uncomment the following to overrride it to use renesas sst git repo.
SRC_URI:rz-cmn = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

# Common config fragments and patches
SRC_URI:append:rz-cmn = " \
	file://common/kernel-common.cfg \
	file://common/panfrost.cfg \
	file://common/usb-serial.cfg \
	file://common/usb-can.cfg \
	file://common/firmware-edid.cfg \
	file://common/nvme.cfg \
	${@bb.utils.contains('DOCKER_SUPPORT', '1', 'file://common/docker.cfg', '', d)} \
	${@bb.utils.contains('DISTRO', 'ubuntu-tiny', 'file://common/docker.cfg', '', d)} \
	${@oe.utils.conditional("OPTIMIZE_KERN", "1", "file://common/optimize.cfg", "", d)} \
"

# RZ/G2L-SBC specific config fragments
SRC_URI:append:rz-cmn =	" \
	file://rzg2l-sbc/laird.cfg \
	file://rzg2l-sbc/touch.cfg \
"

KCONFIG_MODE:rz-cmn = "alldefconfig"
#KMACHINE:rz-cmn ?= "renesas_defconfig"
KBUILD_DEFCONFIG:rz-cmn ?= "renesas_defconfig"

# List of device tree names for rz-cmn
DEVICETREE_NAME:rz-cmn = " \
	rzg2l-sbc \
	r9a07g044l2-smarc \
	r9a07g044l2-smarc-cru-csi-ov5645 \
	r9a07g054l2-smarc \
	r9a07g054l2-smarc-cru-csi-ov5645 \
	r9a09g057h4-evk-ver1 \
	r9a09g057h4-rdk-ver1 \
"

# Supported device tree and device tree overlays
KERNEL_DEVICETREE:rz-cmn = "${@' '.join(['renesas/%s.dtb' % devicetree_name for devicetree_name in d.getVar('DEVICETREE_NAME').split()])}"

KERNEL_DEVICETREE:append:rz-cmn = " \
	renesas/overlays/rzg2l-sbc-1.0-can.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ext-i2c.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ext-spi.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-dsi.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ov5640.dtbo \
	renesas/overlays/rzg2l-evk-1.0-cru-csi-ov5645.dtbo \
	renesas/overlays/rzv2l-evk-1.0-cru-csi-ov5645.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-audio-codec.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-audio-hdmi.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-can.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-ext-spi.dtbo \
"

# Override the dtc flags to support dtbo build in kernel-devicetree.bbclass
KERNEL_DTC_FLAGS = "-@"

# Install overlays folder and kernel images to target/images in build folder
do_deploy:append:rz-cmn(){
	install -d ${DEPLOYDIR}/target/images/linux/dtbs/overlays
	install -m 0644 ${B}/arch/arm64/boot/dts/renesas/overlays/* ${DEPLOYDIR}/target/images/linux/dtbs/overlays

	install -m 0644 ${B}/arch/arm64/boot/Image ${DEPLOYDIR}/target/images/linux/${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin
	ln -sf ${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/linux/Image

	for dtb_name in ${DEVICETREE_NAME}; do
		install -m 0644 ${B}/arch/arm64/boot/dts/renesas/${dtb_name}.dtb ${DEPLOYDIR}/target/images/linux/dtbs/${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext
		ln -sf ${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext ${DEPLOYDIR}/target/images/linux/dtbs/${dtb_name}.dtb
	done
}

SRCREV_machine:rz-cmn ?= "${AUTOREV}"
LINUX_VERSION:rz-cmn ?= "6.10.14"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"
