# Support script for uload-bootloader-linux
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://uload_bootloader_flash.py \
    file://Readme.md \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/uload_bootloader_flash.py ${D}/util/uload_bootloader_flash.py
    install -m 0644 ${S}/Readme.md ${D}/util/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/uload-bootloader/linux
    install -m 0644 ${D}/util/uload_bootloader_flash.py ${DEPLOYDIR}/host/tools/uload-bootloader/linux
    install -m 0644 ${D}/util/Readme.md ${DEPLOYDIR}/host/tools/uload-bootloader/linux
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
