# Add files for loading bootloader from U-Boot
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "firmware-pack"

S = "${WORKDIR}"

SRC_URI = " \
    file://uload-readme.txt \
    file://uload_bootloader_flash.py \
    file://uload-bootloader-windows-script.zip;unpack=0 \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/uload-readme.txt ${D}/util/uload-readme.txt
    install -m 0644 ${S}/uload_bootloader_flash.py ${D}/util/uload_bootloader_flash.py
    install -m 0755 ${S}/uload-bootloader-windows-script.zip ${D}/util/uload-bootloader-windows-script.zip
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/uload-bootloader
    install -m 0644 ${D}/util/uload-readme.txt ${DEPLOYDIR}/uload-bootloader
    install -m 0644 ${D}/util/uload_bootloader_flash.py ${DEPLOYDIR}/uload-bootloader
    install -m 0644 ${DEPLOY_DIR_IMAGE}/bl2_bp-rzpi.bin ${DEPLOYDIR}/uload-bootloader
    install -m 0644 ${DEPLOY_DIR_IMAGE}/fip-rzpi.bin ${DEPLOYDIR}/uload-bootloader
    install -m 0755 ${D}/util/uload-bootloader-windows-script.zip ${DEPLOYDIR}/uload-bootloader
    cd ${DEPLOYDIR}/uload-bootloader
    unzip -o uload-bootloader-windows-script.zip
    rm -f uload-bootloader-windows-script.zip
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
