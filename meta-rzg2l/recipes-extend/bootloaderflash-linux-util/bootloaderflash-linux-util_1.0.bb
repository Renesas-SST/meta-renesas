# Support script for bootloader flashing on Linux
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://bootloader_flash.py \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/bootloader_flash.py ${D}/util/bootloader_flash.py
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -m 0644 ${D}/util/bootloader_flash.py ${DEPLOYDIR}
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
