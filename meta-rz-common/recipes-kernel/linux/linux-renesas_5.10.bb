DESCRIPTION = "Linux kernel for the RZG2 based board"

require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"
COMPATIBLE_MACHINE_rzg2l = "(smarc-rzg2l|rzg2l-dev|smarc-rzg2lc|rzg2lc-dev|smarc-rzg2ul|rzg2ul-dev|smarc-rzv2l|rzv2l-dev)"
COMPATIBLE_MACHINE_rzg2h = "(ek874|hihope-rzg2n|hihope-rzg2m|hihope-rzg2h)"
COMPATIBLE_MACHINE_rzfive = "(smarc-rzfive|rzfive-dev)"

KERNEL_URL = " \
    git://github.com/renesas-rz/rz_linux-cip.git"
BRANCH = "${@oe.utils.conditional("IS_RT_BSP", "1", "rz-5.10-cip36-rt14", "rz-5.10-cip36",d)}"
SRCREV = "${@oe.utils.conditional("IS_RT_BSP", "1", "acfae3a7012408c0ba27b11ae351e7a84979709d", "da00d905f64c22eb81658467a8fb213d7779ff23",d)}"

SRC_URI = "${KERNEL_URL};protocol=https;nocheckout=1;branch=${BRANCH}"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LINUX_VERSION ?= "${@oe.utils.conditional("IS_RT_BSP", "1", "5.10.184-cip36-rt14", "5.10.184-cip36",d)}"

PV = "${LINUX_VERSION}+git${SRCPV}"
PR = "r1"

SRC_URI_append = "\
  file://touch.cfg \
"

KBUILD_DEFCONFIG = "defconfig"
KBUILD_DEFCONFIG_rzfive = "renesas_defconfig"
KCONFIG_MODE = "alldefconfig"

do_kernel_metadata_af_patch() {
	# need to recall do_kernel_metadata after do_patch for some patches applied to defconfig
	rm -f ${WORKDIR}/defconfig
	do_kernel_metadata
}

do_deploy_append() {
	for dtbf in ${KERNEL_DEVICETREE}; do
		dtb=`normalize_dtb "$dtbf"`
		dtb_ext=${dtb##*.}
		dtb_base_name=`basename $dtb .$dtb_ext`
		for type in ${KERNEL_IMAGETYPE_FOR_MAKE}; do
			ln -sf $dtb_base_name-${KERNEL_DTB_NAME}.$dtb_ext $deployDir/$type-$dtb_base_name.$dtb_ext
		done
	done
}

addtask do_kernel_metadata_af_patch after do_patch before do_kernel_configme

# Fix race condition, which can causes configs in defconfig file be ignored
do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}binutils:do_populate_sysroot"
do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}gcc:do_populate_sysroot"
do_kernel_configme[depends] += "bc-native:do_populate_sysroot bison-native:do_populate_sysroot"

# Fix error: openssl/bio.h: No such file or directory
DEPENDS += "openssl-native"
