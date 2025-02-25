SUMMARY = "Custom RZPi Image"
LICENSE = "MIT"
require include/core-image-renesas-mmp.inc
require include/core-image-renesas-qt.inc
inherit core-image

IMAGE_INSTALL:append = "\
	v4l-utils \
	v4l2-init \
"
# Packages for Wi-Fi and BT support for sbc
IMAGE_INSTALL:append = " \
	lwb-fcc-firmware \
	summit-supplicant-lwb \
"
IMAGE_INSTALL:append:rzg2l-sbc = " uenv"
# Add QT to rootfs
python () {
	qt6_support = d.getVar('QT6_SUPPORT')
	if qt6_support == '0':
		d.appendVar('IMAGE_INSTALL', ' packagegroup-qt5 packagegroup-qt5-examples kernel-module-uvcvideo')
	else:
		d.appendVar('IMAGE_INSTALL', ' packagegroup-qt6 kernel-module-uvcvideo')
}

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
# The alignment of the root filesystem image in kilobytes
IMAGE_ROOTFS_ALIGNMENT = "16"

# Move images to boot partition
IMAGE_BOOT_FILES:rzg2l-sbc = " \
	target/images/dtbs/rzpi.dtb;dtb/renesas/rzpi.dtb \
	target/images/dtbs/overlays/*;dtb/renesas/overlays/ \
	target/images/Image;Image \
	target/env/uEnv.txt;uEnv.txt \
	Readme.md;Readme.md \
	target/images/fip-${MACHINE}.bin;uload-bootloader/fip-${MACHINE}.bin \
	target/images/bl2_bp-${MACHINE}.bin;uload-bootloader/bl2_bp-${MACHINE}.bin  \
"

DEPENDS += " linux-yocto uenv firmware-pack"

######### bootloader clean up ##########
add_overlays_rootfs() {
	install -d ${IMAGE_ROOTFS}/boot/dtb/renesas
	cp -r ${DEPLOY_DIR_IMAGE}/target/images/dtbs/* ${IMAGE_ROOTFS}/boot/dtb/renesas
}

add_bootloader_rootfs() {
	install -d ${IMAGE_ROOTFS}/boot/uload-bootloader
	cp -rf ${DEPLOY_DIR_IMAGE}/target/images/bl2_bp-rzg2l-sbc.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
	cp -rf ${DEPLOY_DIR_IMAGE}/target/images/fip-rzg2l-sbc.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
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
	rm -f ${DEPLOY_DIR_IMAGE}/bl31*
	rm -f ${DEPLOY_DIR_IMAGE}/bl2*
	rm -f ${DEPLOY_DIR_IMAGE}/u-boot*
	rm -f ${DEPLOY_DIR_IMAGE}/*initramfs*
	rm -f ${DEPLOY_DIR_IMAGE}/Image*
	rm -f ${DEPLOY_DIR_IMAGE}/rzpi*
	rm -f ${DEPLOY_DIR_IMAGE}/modules*
	rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}*
	rm -f ${DEPLOY_DIR_IMAGE}/Readme.md
}

addtask release_clean after do_image_complete before do_populate_lic_deploy

ROOTFS_POSTPROCESS_COMMAND += " add_overlays_rootfs; add_bootloader_rootfs; deploy_package;"
# Move tar file from deploy complete folder to target/images/rootfs directory

CONVERSION_CMD:bz2:prepend() {
	target_dir="${IMGDEPLOYDIR}/target/images"

	# Create the target directory if it does not exist
	mkdir -p "${target_dir}"

	# Check if the build artifact for the wic image exists; if not, copy it to the build directory
	if [ ! -f "${DEPLOY_DIR_IMAGE}/Image" ]; then
		cp "${DEPLOY_DIR_IMAGE}/target/images/Image" "${DEPLOY_DIR_IMAGE}/"
	fi

	if [ ! -f "${DEPLOY_DIR_IMAGE}/rzpi.dtb" ]; then
		cp "${DEPLOY_DIR_IMAGE}/target/images/dtbs/rzpi.dtb" "${DEPLOY_DIR_IMAGE}/"
	fi
}

CONVERSION_CMD:bz2:append() {
	# Define the target directory and file path
	out="${IMGDEPLOYDIR}/${IMAGE_NAME}"
	target_dir="${IMGDEPLOYDIR}/target/images/rootfs"

	# Create the target directory if it does not exist
	mkdir -p "${target_dir}"

	# Remove existing tar file and move the output to target directory
	rm -f "${target_dir}"/*.tar.bz2
	#mv "${out}.tar.bz2" "${target_dir}/${IMAGE_LINK_NAME}.tar.bz2"
	mv "${out}.tar.bz2" "${target_dir}/renesas-ubuntu.tar.bz2"
}
###################################

# Remove unused rootfs types
IMAGE_FSTYPES:remove = " tar.gz ext4 "

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

# host-readme
EXTRA_IMAGEDEPENDS += " host-readme "

# target-readme
EXTRA_IMAGEDEPENDS += " target-readme "

# Readme documentation
EXTRA_IMAGEDEPENDS += " rzg2l-sbc-readme "
EXTRA_IMAGEDEPENDS += " rzg2l-sbc-docs "

# Environment setup, support building kernel modules with kernel src in SDK
export KERNELSRC="$SDKTARGETSYSROOT/usr/src/kernel"
export KERNELDIR="$SDKTARGETSYSROOT/usr/src/kernel"
export HOST_EXTRACFLAGS="-I${OECORE_NATIVE_SYSROOT}/usr/include/ -L${OECORE_NATIVE_SYSROOT}/usr/lib"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"
