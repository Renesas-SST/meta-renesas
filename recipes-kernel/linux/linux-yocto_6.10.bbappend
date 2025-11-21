# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
inherit kernel-devicetree
inherit renesas-kernel-variants

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

# Pull in the RT patch artifact along with the per-variant config fragments
# so they are available during do_compile_*.
SRC_URI:append:rz-cmn = " \
    file://common/0008-realtime-kernel-patch.patch;apply=no \
    file://common/preempt-rt.cfg \
    file://common/nonpreempt.cfg \
    file://common/base-preempt.cfg \
"

####################################################################
# Variant metadata describing tree locations, config fragments, etc.
####################################################################
SRT:rz-cmn ?= "${WORKDIR}/git-preempt-rt"
SNP:rz-cmn ?= "${WORKDIR}/git-nonpreempt"
RENESAS_KERNEL_VARIANTS:rz-cmn = "preempt_rt nonpreempt"

RENESAS_KERNEL_VARIANT_preempt_rt_TREE:rz-cmn = "${SRT}"
RENESAS_KERNEL_VARIANT_preempt_rt_PRETTY:rz-cmn = "PREEMPT_RT"
RENESAS_KERNEL_VARIANT_preempt_rt_PATCH:rz-cmn = "${WORKDIR}/sources-unpack/common/0008-realtime-kernel-patch.patch"
RENESAS_KERNEL_VARIANT_preempt_rt_CONFIG:rz-cmn = "${WORKDIR}/sources-unpack/common/preempt-rt.cfg"
RENESAS_KERNEL_VARIANT_preempt_rt_IMAGE:rz-cmn = "${KERNEL_IMAGETYPE}-preempt_rt-${KERNEL_ARTIFACT_NAME}.bin"
RENESAS_KERNEL_VARIANT_preempt_rt_SYMLINK:rz-cmn = "Image-preempt_rt"
RENESAS_KERNEL_VARIANT_preempt_rt_MODULES:rz-cmn = "${PN}-modules-preempt-rt"

RENESAS_KERNEL_VARIANT_nonpreempt_TREE:rz-cmn = "${SNP}"
RENESAS_KERNEL_VARIANT_nonpreempt_PRETTY:rz-cmn = "non-preempt"
RENESAS_KERNEL_VARIANT_nonpreempt_PATCH:rz-cmn = ""
RENESAS_KERNEL_VARIANT_nonpreempt_CONFIG:rz-cmn = "${WORKDIR}/sources-unpack/common/nonpreempt.cfg"
RENESAS_KERNEL_VARIANT_nonpreempt_IMAGE:rz-cmn = "${KERNEL_IMAGETYPE}-nonpreempt-${KERNEL_ARTIFACT_NAME}.bin"
RENESAS_KERNEL_VARIANT_nonpreempt_SYMLINK:rz-cmn = "Image-nonpreempt"
RENESAS_KERNEL_VARIANT_nonpreempt_MODULES:rz-cmn = "${PN}-modules-nonpreempt"

####################################################################
# Package RT/non-preempt modules.
####################################################################
PACKAGES:append:rz-cmn = " ${PN}-modules-preempt-rt ${PN}-modules-nonpreempt"
FILES:${PN}-modules-preempt-rt:rz-cmn = " \
    ${nonarch_base_libdir}/modules/*-rt*/modules.* \
    ${nonarch_base_libdir}/modules/*-rt*/kernel/** \
"
FILES:${PN}-modules-nonpreempt:rz-cmn = " \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/modules.* \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/kernel/** \
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

KERNEL_FEATURES:append = " sii.cfg laird.cfg touch.cfg peripherals.cfg da7219.cfg drm_panel.cfg ov5640.cfg panfrost.cfg kernel-common.cfg base-preempt.cfg ${@oe.utils.conditional('OPTIMIZE_KERN', '1', ' optimize.cfg', '', d)}"

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

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"

EXTRA_OEMAKE += "${PARALLEL_MAKE}"
