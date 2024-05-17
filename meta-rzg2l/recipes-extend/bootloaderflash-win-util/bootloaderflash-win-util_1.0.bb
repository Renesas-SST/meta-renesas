# Support script for bootloader flashing on Windows
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "trusted-firmware-a u-boot firmware-pack flash-writer"

S = "${WORKDIR}"

SRC_URI = " \
    file://bootloader-windows-script.zip;unpack=0 \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0755 ${S}/bootloader-windows-script.zip ${D}/util/bootloader-windows-script.zip
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -m 0755 ${D}/util/bootloader-windows-script.zip ${DEPLOYDIR}
    cd ${DEPLOYDIR}
    unzip -o bootloader-windows-script.zip
    cp ${DEPLOY_DIR_IMAGE}/Flash_Writer_SCIF_rzpi.mot bootloader-windows-script/images
    cp ${DEPLOY_DIR_IMAGE}/bl2_bp-rzpi.srec bootloader-windows-script/images
    cp ${DEPLOY_DIR_IMAGE}/fip-rzpi.srec bootloader-windows-script/images
    rm -f bootloader-windows-script.zip
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
