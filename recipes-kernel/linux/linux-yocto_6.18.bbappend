# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
inherit kernel-devicetree
inherit renesas-kernel-variants

KBRANCH  = "styhead/rz-cmn"
KBRANCH_RT = "styhead/rz-cmn-rt"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default: use the Renesas-SST Git repository.
# Comment out the following entries to use the Yocto Git repositories instead.
# This may conflict with the current setup.
SRC_URI:rz-cmn = " \
  git://github.com/Renesas-SST/linux-rz.git;name=nonrt;branch=${KBRANCH};protocol=https;destsuffix=git-nonrt \
  git://github.com/Renesas-SST/linux-rz.git;name=rt;branch=${KBRANCH_RT};protocol=https;destsuffix=git-rt \
"

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

S = "${UNPACKDIR}/git-nonrt"

####################################################################
# Variant metadata describing tree locations, config fragments, etc.
####################################################################
RENESAS_KERNEL_VARIANTS:rz-cmn = "preempt_rt nonpreempt"

# Non-preempt variant: from the same non-RT tree as base
RENESAS_KERNEL_VARIANT_nonpreempt_SRCTREE:rz-cmn  = "${UNPACKDIR}/git-nonrt"
# Let TREE default to ${WORKDIR}/git-nonpreempt (set by the class)
RENESAS_KERNEL_VARIANT_nonpreempt_PRETTY:rz-cmn   = "non-preempt"
RENESAS_KERNEL_VARIANT_nonpreempt_CONFIG:rz-cmn = "${THISDIR}/rz-cmn/common/nonpreempt.cfg"
RENESAS_KERNEL_VARIANT_nonpreempt_IMAGE:rz-cmn    = "Image-nonpreempt-${KERNEL_ARTIFACT_NAME}.bin"
RENESAS_KERNEL_VARIANT_nonpreempt_SYMLINK:rz-cmn  = "Image-nonpreempt"
RENESAS_KERNEL_VARIANT_nonpreempt_MODULES:rz-cmn  = "${PN}-modules-nonpreempt"

# PREEMPT_RT variant: from RT branch
RENESAS_KERNEL_VARIANT_preempt_rt_SRCTREE:rz-cmn  = "${UNPACKDIR}/git-rt"
# Let TREE default to ${WORKDIR}/git-preempt_rt
RENESAS_KERNEL_VARIANT_preempt_rt_PRETTY:rz-cmn   = "PREEMPT_RT"
RENESAS_KERNEL_VARIANT_preempt_rt_CONFIG:rz-cmn = "${THISDIR}/rz-cmn/common/preempt-rt.cfg"
RENESAS_KERNEL_VARIANT_preempt_rt_IMAGE:rz-cmn    = "Image-preempt_rt-${KERNEL_ARTIFACT_NAME}.bin"
RENESAS_KERNEL_VARIANT_preempt_rt_SYMLINK:rz-cmn  = "Image-preempt_rt"
RENESAS_KERNEL_VARIANT_preempt_rt_MODULES:rz-cmn  = "${PN}-modules-preempt-rt"

####################################################################
# Package RT/non-preempt images and modules.
####################################################################
PACKAGES:append:rz-cmn = " ${PN}-modules-preempt-rt ${PN}-modules-nonpreempt"
FILES:${PN}-modules-preempt-rt:rz-cmn = " \
    ${nonarch_base_libdir}/modules/*rt*/modules.* \
    ${nonarch_base_libdir}/modules/*rt*/kernel/** \
"
FILES:${PN}-modules-nonpreempt:rz-cmn = " \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/modules.* \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/kernel/** \
"
FILES:${KERNEL_PACKAGE_NAME}-image:append:rz-cmn = " \
    /${KERNEL_IMAGEDEST}/Image-preempt_rt* \
    /${KERNEL_IMAGEDEST}/Image-nonpreempt* \
"

####################################################################
# Assign kernel task.
####################################################################

do_compile_preempt_rt() {
    renesas_kernel_compile_variant preempt_rt
}

do_compile_nonpreempt() {
    renesas_kernel_compile_variant nonpreempt
}

addtask compile_preempt_rt after do_compile before do_install
addtask compile_nonpreempt after do_compile before do_install

KCONFIG_MODE:rz-cmn = "alldefconfig"
#KMACHINE:rz-cmn ?= "renesas_defconfig"
KBUILD_DEFCONFIG:rz-cmn ?= "renesas_defconfig"

# List of device tree names for rz-cmn
DEVICETREE_NAME:rz-cmn = " \
	rzg2l-sbc \
	rzg2l-evk \
	rzv2l-evk \
	rzv2h-evk-ver1 \
	rzv2h-rdk-ver1 \
	rs-g2l100 \
	imdt-v2h-sbc \
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
	renesas/overlays/rzv2h-rdk-1.0-can.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-ext-spi.dtbo \
	renesas/overlays/imdt-v2h-sbc-1.0-dsi.dtbo \
	renesas/overlays/imdt-v2h-sbc-1.0-cru-csi22-ar1335.dtbo \
	renesas/overlays/imdt-v2h-sbc-1.0-cru-csi23-ar1335.dtbo \
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
SRCREV_nonrt:rz-cmn ?= "${AUTOREV}"
SRCREV_rt:rz-cmn ?= "${AUTOREV}"
SRCREV_FORMAT = "nonrt_rt"

LINUX_VERSION:rz-cmn ?= "6.18.20"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"

EXTRA_OEMAKE += "${PARALLEL_MAKE}"
