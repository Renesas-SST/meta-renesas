SUMMARY = "Generate platform binary settings using binmake"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://platform_info.json"
PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "binmake-native"

S = "${WORKDIR}/sources-unpack"

inherit deploy

# Create platform info file
do_compile () {
    for target in ${SUPPORT_TARGETS}; do
        binmake --input=${S}/platform_info.json \
                --board=${target} \
                --output=${S}/${target}-platform-settings.bin
    done
}

# Install platform info images to deploy folder
do_deploy () {
    # Create deploy folder
    install -d ${DEPLOYDIR}/target/images
    install -m 0644 ${S}/*.bin ${DEPLOYDIR}/target/images/
}

addtask deploy after do_compile before do_build

COMPATIBLE_MACHINE = "rz-cmn"
