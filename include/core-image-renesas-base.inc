# Basic packages/tools
IMAGE_INSTALL:append = " \
    ustreamer \
    kernel-image \
    kernel-devicetree \
    bash \
    coreutils \
    can-utils \
    i2c-tools \
    v4l-utils \
    v4l2-init \
    spitools \
    python3-smbus \
    python3-smbus2 \
    ethtool \
    iproute2 \
    iperf3 \
    libgpiod \
    libgpiod-tools \
    libgpiod-dev \
"

IMAGE_INSTALL:append:rz-cmn = " uenv"

WKS_FILE = "rz-cmn-image-bootpart-mmc0.wks"

# Rootfs partition space created in Kbytes
IMAGE_ROOTFS_EXTRA_SPACE = "1048576"

# The alignment of the root filesystem image in kilobytes
IMAGE_ROOTFS_ALIGNMENT = "16"

# Move images to boot partition
IMAGE_BOOT_FILES:rz-cmn = " \
    target/images/linux/dtbs/*.dtb;dtb/renesas/ \
    target/images/linux/dtbs/overlays/*;dtb/renesas/overlays/ \
    target/images/linux/Image;Image \
    target/images/linux/Image-preempt_rt;Image-preempt_rt \
    target/images/linux/Image-nonpreempt;Image-nonpreempt \
    target/env/uEnv.txt;uEnv.txt \
    Readme.md;Readme.md \
    target/images/*.bin;uload-bootloader/ \
"

DEPENDS += " linux-yocto uenv platform-gen "

add_bootloader_rootfs() {
    install -d ${IMAGE_ROOTFS}/boot/uload-bootloader
    cp -rf ${DEPLOY_DIR_IMAGE}/target/images/*-platform-settings.bin ${IMAGE_ROOTFS}/boot/uload-bootloader
}

# Clean the output directory after the build
do_release_clean() {   
    rm -f ${DEPLOY_DIR_IMAGE}/bl31*
    rm -f ${DEPLOY_DIR_IMAGE}/bl2*    
    rm -f ${DEPLOY_DIR_IMAGE}/u-boot*
    rm -f ${DEPLOY_DIR_IMAGE}/*initramfs*
    rm -f ${DEPLOY_DIR_IMAGE}/Image*
    rm -f ${DEPLOY_DIR_IMAGE}/*.dtb
    rm -f ${DEPLOY_DIR_IMAGE}/*.dtbo
    rm -f ${DEPLOY_DIR_IMAGE}/modules*
    rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}*
    rm -f ${DEPLOY_DIR_IMAGE}/Readme.md
}

addtask release_clean after do_image_complete before do_populate_lic_deploy
addtask write_image_spdx after create_image_sbom_spdx before do_release_clean
ROOTFS_POSTPROCESS_COMMAND += " add_bootloader_rootfs;"

# Install .env file to host/env
python do_rootfs_wicenv:append () {
    target_dir = os.path.join(depdir, 'host/env')
    os.makedirs(target_dir, exist_ok=True)
    bb.utils.copyfile(os.path.join(outdir, basename) + '.env', os.path.join(target_dir, basename) + '.env')
}

# Install file rootfs.manifest to host/build
python write_image_manifest:append () {
    # Create target dir host/build
    link_name = d.getVar('IMAGE_BASENAME')
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .manifest file to the deploy_dir/host/build folder
    var_get_name = d.getVar('IMAGE_BASENAME') + d.getVar('IMAGE_VERSION_SUFFIX')
    manifest_name_target = os.path.join(deploy_dir, "%s.rootfs.manifest" % var_get_name)
    target_manifest = os.path.join(target_dir, os.path.basename(manifest_name_target))
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
python write_image_test_data:append () {
    # Create the directory deploy_dir/host/build
    link_name = d.getVar('IMAGE_BASENAME')
    target_dir = os.path.join(deploy_dir, 'host/build')
    os.makedirs(target_dir, exist_ok=True)

    # Copy the .testdata.json file to deploy_dir/host/build
    var_get_name = d.getVar('IMAGE_BASENAME') + d.getVar('IMAGE_VERSION_SUFFIX')
    testdata_name_target = os.path.join(deploy_dir, "%s.testdata.json" % var_get_name)
    target_testdata = os.path.join(target_dir, os.path.basename(testdata_name_target))
    os.system(f"cp {testdata_name} {target_testdata}")

    # Create a symbolic link in deploy_dir pointing to the new file in deploy_dir/host/build
    if os.path.exists(target_testdata) and link_name:
        target_testdata_link = os.path.join(target_dir, "%s.testdata.json" % link_name)
    if os.path.lexists(target_testdata_link):
        os.remove(target_testdata_link)
    os.symlink(os.path.basename(target_testdata), target_testdata_link)
}

# Install file .spdx.json to host/build
python do_write_image_spdx() {
    inherit_var = d.getVar('INHERIT')
    deploy_dir_image = d.getVar('DEPLOY_DIR_IMAGE')

    # Create the target directory 'host/build' if it does not exist
    target_dir = os.path.join(deploy_dir_image, 'host', 'build')
    os.makedirs(target_dir, exist_ok=True)

    # Remove all .spdx files in the target directory
    for spdx_file in os.listdir(target_dir):
        if '.spdx' in spdx_file:
            file_to_remove = os.path.join(target_dir, spdx_file)
            if os.path.islink(file_to_remove) or os.path.isfile(file_to_remove):
                os.remove(file_to_remove)

    # Check if 'create-spdx' is included in the INHERIT variable
    if 'create-spdx' in inherit_var:
        # Iterate through all files in the DEPLOY_DIR_IMAGE directory
        for spdx_file in os.listdir(deploy_dir_image):
             # Check if the file name contains '.spdx'
            if '.spdx' in spdx_file:
                source_spdx_file = os.path.join(deploy_dir_image, spdx_file)
                target_spdx_file = os.path.join(target_dir, spdx_file)

                # Copy the .spdx file and symbol link to the target directory
                os.system(f"cp -P {source_spdx_file} {target_spdx_file}")
}

# Move wic file from deploy complete folder to target/images directory
IMAGE_CMD:wic:prepend() {
    target_dir="${IMGDEPLOYDIR}/target/images"

    # Create the target directory if it does not exist
    mkdir -p "${target_dir}"

    # Check if the build artifact for the wic image exists; if not, copy it to the build directory
    if [ ! -f "${DEPLOY_DIR_IMAGE}/Image" ]; then
        cp "${DEPLOY_DIR_IMAGE}/target/images/linux/Image" "${DEPLOY_DIR_IMAGE}/"
    fi

    if [ ! -f "${DEPLOY_DIR_IMAGE}/rzg2l-sbc.dtb" ]; then
        cp "${DEPLOY_DIR_IMAGE}/target/images/linux/dtbs/rzg2l-sbc.dtb" "${DEPLOY_DIR_IMAGE}/"
    fi
}

IMAGE_CMD:wic:append() {
    # Remove existing wic file and move the output to target directory
    rm -f "${target_dir}"/*.wic
    mv "${out}.wic" "${target_dir}/${IMAGE_BASENAME}.wic"
    cp "${target_dir}/${IMAGE_BASENAME}.wic" "${IMGDEPLOYDIR}/${IMAGE_NAME}.wic"
}

# Move tar file from deploy complete folder to target/images/rootfs directory
CONVERSION_CMD:bz2:append() {
    # Define the target directory and file path
    out="${IMGDEPLOYDIR}/${IMAGE_NAME}"
    target_dir="${IMGDEPLOYDIR}/target/images/rootfs"

    # Create the target directory if it does not exist
    mkdir -p "${target_dir}"
    # Remove existing tar file and move the output to target directory
    rm -f "${target_dir}"/*.tar.bz2
    mv "${out}.tar.bz2" "${target_dir}/${IMAGE_BASENAME}.tar.bz2"
}

# Install readme files to host folder
EXTRA_IMAGEDEPENDS += " host-readme "

# Install readme files to target folder
EXTRA_IMAGEDEPENDS += " target-readme "

# Flashing utility
EXTRA_IMAGEDEPENDS += " universal-scripts "

# Readme documentation
EXTRA_IMAGEDEPENDS += " rz-cmn-readme "
EXTRA_IMAGEDEPENDS += " rz-cmn-docs "

IMAGE_INSTALL:append = " kernel-modules"

# Force image rebuild before SDK creation (changes when building multiple images lead to re-deploy but not clean because images are not re-built)
SDK_POSTPROCESS_COMMAND:prepend = " do_release_clean;"
do_release_clean[nostamp] = "1"
