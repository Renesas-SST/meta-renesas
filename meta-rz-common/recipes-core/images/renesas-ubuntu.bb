SUMMARY = "Custom RZPi Image"
LICENSE = "MIT"
require include/core-image-renesas-mmp.inc
require include/core-image-renesas-qt.inc
inherit core-image

IMAGE_INSTALL_append = "\
	v4l-utils \
	v4l2-init \
"
# Packages for Wi-Fi and BT support for sbc
IMAGE_INSTALL_append = " \
	lwb-fcc-firmware \
	kernel-module-lwb5p-backports-summit \
	summit-supplicant-lwb \
"

# Add QT to rootfs
IMAGE_INSTALL_append = " packagegroup-qt5 packagegroup-qt5-examples kernel-module-uvcvideo"

# Add weston to rootfs
CORE_IMAGE_BASE_INSTALL += "weston"

# compatible machine comes with linux-yocto but not available in this build
# so bring back these parameters
COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"
COMPATIBLE_MACHINE = "^(aarch64|rzg2l-sbc)$"

IMAGE_FSTYPES = " tar.bz2"
# bootloader for rzsbc
DEPENDS += " firmware-pack"
MACHINEOVERRIDES =. "rzg2l:"

######### bootloader clean up ##########
add_overlays_rootfs() {
	install -d ${IMAGE_ROOTFS}/boot/overlays
	cp -r ${DEPLOY_DIR_IMAGE}/target/images/dtbs/* ${IMAGE_ROOTFS}/boot
}

add_bootloader_rootfs() {
	install -d ${IMAGE_ROOTFS}/boot/uload-bootloader
	cp -rf ${DEPLOY_DIR_IMAGE}/target/images/bl2_bp-rzpi.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
	cp -rf ${DEPLOY_DIR_IMAGE}/target/images/fip-rzpi.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
}

deploy_package() {
	rm -f ${DEPLOY_DIR_IMAGE}/bl31*
	rm -f ${DEPLOY_DIR_IMAGE}/*_esd-*
	rm -f ${DEPLOY_DIR_IMAGE}/*pmic*
	rm -f ${DEPLOY_DIR_IMAGE}/*PMIC*
	rm -f ${DEPLOY_DIR_IMAGE}/*.elf
	rm -f ${DEPLOY_DIR_IMAGE}/Image-rzpi*
	rm -f ${DEPLOY_DIR_IMAGE}/rzpi-rzpi*
	rm -f ${DEPLOY_DIR_IMAGE}/modules*
	rm -f ${DEPLOY_DIR_IMAGE}/u-boot*

	# Remove overlays document readme.txt from output folder
	rm -f ${DEPLOY_DIR_IMAGE}/readme.txt
}

# Clean the output directory after the build
do_release_clean() {
	rm -f ${DEPLOY_DIR_IMAGE}/Image*
	rm -f ${DEPLOY_DIR_IMAGE}/rzpi*
	rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}*
	rm -f ${DEPLOY_DIR_IMAGE}/fip-rzpi*
	rm -f ${DEPLOY_DIR_IMAGE}/bl2*
}

addtask release_clean after do_image_complete before do_populate_lic_deploy

ROOTFS_POSTPROCESS_COMMAND += " add_overlays_rootfs; add_bootloader_rootfs; deploy_package;"
# Move tar file from deploy complete folder to target/images/rootfs directory
CONVERSION_CMD_bz2_append() {
	# Define the target directory and file path
	out="${IMGDEPLOYDIR}/${IMAGE_NAME}"
	target_dir="${IMGDEPLOYDIR}/target/images/rootfs"

	# Create the target directory if it does not exist
	mkdir -p "${target_dir}"

	# Remove existing tar file and move the output to target directory
	rm -f "${target_dir}"/*.tar.bz2
	#mv "${out}${IMAGE_NAME_SUFFIX}.tar.bz2" "${target_dir}/${IMAGE_LINK_NAME}.tar.bz2"
	mv "${out}${IMAGE_NAME_SUFFIX}.tar.bz2" "${target_dir}/core-image-qt-rzpi.tar.bz2"
}
###################################

# Remove unused rootfs types
IMAGE_FSTYPES_remove = " tar.gz ext4 "

# Linux bootloader flashing utility
EXTRA_IMAGEDEPENDS += " bootloader-flasher-linux "

# Windows bootloader flashing utility
EXTRA_IMAGEDEPENDS += " bootloader-flasher-win "

# Windows bootloader flashing readme
EXTRA_IMAGEDEPENDS += " bootloader-flasher-readme "

# Linux sd-creator-linux
EXTRA_IMAGEDEPENDS += " sd-creator-linux "

# Windows sd-creator-win
EXTRA_IMAGEDEPENDS += " sd-creator-win "

# sd-creator-readme
EXTRA_IMAGEDEPENDS += " sd-creator-readme "

# Linux uload-bootloader-linux
EXTRA_IMAGEDEPENDS += " uload-bootloader-linux "

# Windows uload-bootloader-win
EXTRA_IMAGEDEPENDS += " uload-bootloader-win "

# uload-bootloader-readme
EXTRA_IMAGEDEPENDS += " uload-bootloader-readme "

# uEnv.txt
IMAGE_INSTALL_append = " uenv "

# host-readme
EXTRA_IMAGEDEPENDS += " host-readme "

# target-readme
EXTRA_IMAGEDEPENDS += " target-readme "

# Readme documentation
EXTRA_IMAGEDEPENDS += " readme "
EXTRA_IMAGEDEPENDS += " rzpi-docs "

# Environment setup, support building kernel modules with kernel src in SDK
export KERNELSRC="$SDKTARGETSYSROOT/usr/src/kernel"
export KERNELDIR="$SDKTARGETSYSROOT/usr/src/kernel"
export HOST_EXTRACFLAGS="-I${OECORE_NATIVE_SYSROOT}/usr/include/ -L${OECORE_NATIVE_SYSROOT}/usr/lib"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"
