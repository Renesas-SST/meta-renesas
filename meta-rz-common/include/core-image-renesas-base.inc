# Basic packages
IMAGE_INSTALL_append = " \
    kernel-image \
    kernel-devicetree \
    bash \
    v4l-utils \
    v4l2-init \
    i2c-tools \
    spitools \
    coreutils \
"

update_issue() {
    # Set BSP version
    BSP_VERSION="3.0.5"

    # Set SoC and Board info
    case "${MACHINE}" in
    smarc-rzg2l)
      BSP_SOC="RZG2L"
      BSP_BOARD="RZG2L-SMARC-EVK"
      ;;
    rzg2l-dev)
      BSP_SOC="RZG2L"
      BSP_BOARD="RZG2L-DEV"
      ;;
    smarc-rzg2lc)
      BSP_SOC="RZG2LC"
      BSP_BOARD="RZG2LC-SMARC-EVK"
      ;;
    rzg2lc-dev)
      BSP_SOC="RZG2LC"
      BSP_BOARD="RZG2LC-DEV"
      ;;
    smarc-rzg2ul)
      BSP_SOC="RZG2UL"
      BSP_BOARD="RZG2UL-SMARC-EVK"
      ;;
    rzg2ul-dev)
      BSP_SOC="RZG2UL"
      BSP_BOARD="RZG2UL-DEV"
      ;;
    smarc-rzv2l)
      BSP_SOC="RZV2L"
      BSP_BOARD="RZV2L-SMARC-EVK"
      ;;
    rzv2l-dev)
      BSP_SOC="RZV2L"
      BSP_BOARD="RZV2L-DEV"
      ;;
    smarc-rzfive)
      BSP_SOC="RZFive"
      BSP_BOARD="RZFive-SMARC-EVK"
      ;;
    rzfive-dev)
      BSP_SOC="RZFive"
      BSP_BOARD="RZFive-DEV"
      ;;
    rzv2m)
      BSP_SOC="RZV2M"
      BSP_BOARD="RZV2M Evaluation Board Kit"
      ;;
    rzv2ma)
      BSP_SOC="RZV2MA"
      BSP_BOARD="RZV2MA Evaluation Board Kit"
      ;;
    hihope-rzg2h)
      BSP_SOC="RZG2H"
      BSP_BOARD="HIHOPE-RZG2H"
      ;;
    hihope-rzg2m)
      BSP_SOC="RZG2M"
      BSP_BOARD="HIHOPE-RZG2M"
      ;;
    hihope-rzg2n)
      BSP_SOC="RZG2N"
      BSP_BOARD="HIHOPE-RZG2N"
      ;;
    ek874)
      BSP_SOC="RZG2E"
      BSP_BOARD="EK874"
      ;;
    iwg20m-g1m)
      BSP_SOC="RZG1M"
      BSP_BOARD="iWave RZ/G1M-PF Development Kit"
      ;;
    skrzg1m)
      BSP_SOC="RZG1M"
      BSP_BOARD="RZG1M-SK"
      ;;
    iwg20m-g1n)
      BSP_SOC="RZG1N"
      BSP_BOARD="iWave RZ/G1N-PF Development Kit"
      ;;
    iwg21m)
      BSP_SOC="RZG1H"
      BSP_BOARD="iWave RZ/G1H-PF Development Kit"
      ;;
    iwg22m)
      BSP_SOC="RZG1E"
      BSP_BOARD="iWave RZ/G1E-PF Development Kit"
      ;;
    skrzg1e)
      BSP_SOC="RZG1E"
      BSP_BOARD="RZG1E-SK"
      ;;
    iwg23s)
      BSP_SOC="RZG1C"
      BSP_BOARD="iWave RZ/G1C-PF Development Kit"
      ;;
    esac

    # Make issue file
    echo "BSP: ${BSP_SOC}/${BSP_BOARD}/${BSP_VERSION}" >> ${IMAGE_ROOTFS}/etc/issue
    echo "LSI: ${BSP_SOC}" >> ${IMAGE_ROOTFS}/etc/issue
    echo "Version: ${BSP_VERSION}" >> ${IMAGE_ROOTFS}/etc/issue
}

ROOTFS_POSTPROCESS_COMMAND += " update_issue; "

# Renesas Basic packages for 32bit
BASIC_32BIT_PKGS = " \
    lib32-coreutils \
    lib32-libstdc++ \
"

# Support secure environment
IMAGE_INSTALL_append = " \
    optee-client \
"

BASIC_32BIT_PKGS_append_rzg2h = " \
    lib32-optee-client \
"

# Installation for 32bit packages
IMAGE_INSTALL_append = " \
    ${@oe.utils.conditional("USE_32BIT_PKGS", "1", "${BASIC_32BIT_PKGS}", "", d)} \
"

# Qos user packages only supports 64bit.
QOS_USER_PKGS = ""
QOS_USER_PKGS_aarch64 = " \
    qosif-user-module \
    qosif-tp-user-module \
"

# Installation for QoS packages
IMAGE_INSTALL_append_rzg2h = " \
    kernel-module-qos \
    ${QOS_USER_PKGS} \
"

# Support Docker Engine
IMAGE_INSTALL_append = " \
    packagegroup-docker \
"

# Remove since RZG1 don't support LTTNG
IMAGE_INSTALL_remove_rzg1 = " \
  lttng-tools \
  lttng-modules \
  lttng-ust \
"

# Environment setup, support building kernel modules with kernel src in SDK
export KERNELSRC="$SDKTARGETSYSROOT/usr/src/kernel"
export KERNELDIR="$SDKTARGETSYSROOT/usr/src/kernel"
export HOST_EXTRACFLAGS="-I${OECORE_NATIVE_SYSROOT}/usr/include/ -L${OECORE_NATIVE_SYSROOT}/usr/lib"

# WKS setup
WKS_FILE = "rzg2l-sbc-image-bootpart-mmc0.wks"

# Rootfs partition space created in Kbytes
IMAGE_ROOTFS_EXTRA_SPACE = "1048576"

# The alignment of the root filesystem image in kilobytes
IMAGE_ROOTFS_ALIGNMENT = "16"

add_overlays_rootfs() {
    install -d ${IMAGE_ROOTFS}/boot/overlays
    cp ${DEPLOY_DIR_IMAGE}/target/images/dtbs/overlays/* ${IMAGE_ROOTFS}/boot/overlays
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

DEPENDS += " firmware-pack linux-renesas"

# Install core-image.env to host/env
python do_rootfs_wicenv_append () {
    target_dir = os.path.join(depdir, 'host/env')
    os.makedirs(target_dir, exist_ok=True)
    bb.utils.copyfile(os.path.join(outdir, basename) + '.env', os.path.join(target_dir, basename) + '.env')
}

# Install file rootfs.manifest to host/build
python write_image_manifest_append () {
    # Create target dir host/build
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .manifest file to the deploy_dir/host/build folder
    target_manifest = os.path.join(target_dir, os.path.basename(manifest_name))
    os.system(f"cp {manifest_name} {target_manifest}")

    # Create a symbolic link to the new manifest file in the deploy directory
    if os.path.exists(target_manifest) and link_name:
        target_manifest_link = os.path.join(target_dir, link_name + ".manifest")
        if target_manifest_link != target_manifest:
            if os.path.lexists(target_manifest_link):
                os.remove(target_manifest_link)
            os.symlink(os.path.basename(target_manifest), target_manifest_link)
}

# Install file testdata.json to host/build
python write_image_test_data_append () {
    # Create the directory deploy_dir/host/build
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .testdata.json file to deploy_dir/host/build
    target_testdata = os.path.join(target_dir, os.path.basename(testdata_name))
    os.system(f"cp {testdata_name} {target_testdata}")

    # Create a symbolic link in deploy_dir pointing to the new file in deploy_dir/host/build
    if os.path.exists(target_testdata) and link_name:
        target_testdata_link = os.path.join(target_dir, "%s.testdata.json" % link_name)
    if os.path.lexists(target_testdata_link):
        os.remove(target_testdata_link)
    os.symlink(os.path.basename(target_testdata), target_testdata_link)
}

# Move wic file from deploy complete folder to target/images directory
IMAGE_CMD_wic_prepend() {
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

IMAGE_CMD_wic_append() {
    # Remove existing wic file and move the output to target directory
    rm -f "${target_dir}"/*.wic
    mv "$out${IMAGE_NAME_SUFFIX}.wic" "${target_dir}/${IMAGE_LINK_NAME}.wic"
}

# Move tar file from deploy complete folder to target/images/rootfs directory
CONVERSION_CMD_bz2_append() {
    # Define the target directory and file path
    out="${IMGDEPLOYDIR}/${IMAGE_NAME}"
    target_dir="${IMGDEPLOYDIR}/target/images/rootfs"

    # Create the target directory if it does not exist
    mkdir -p "${target_dir}"

    # Remove existing tar file and move the output to target directory
    rm -f "${target_dir}"/*.tar.bz2
    mv "${out}${IMAGE_NAME_SUFFIX}.tar.bz2" "${target_dir}/${IMAGE_LINK_NAME}.tar.bz2"
}

# Support wic image
IMAGE_FSTYPES_append = " wic "

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