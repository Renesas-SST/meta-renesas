# Add files for bootloader flashing on Linux
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://bootloader_flash.py \
    file://Readme.md \
"

FILES:${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/bootloader_flash.py ${D}/util/bootloader_flash.py
    install -m 0644 ${S}/Readme.md ${D}/util/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/bootloader-flasher/linux
    install -m 0644 ${D}/util/bootloader_flash.py ${DEPLOYDIR}/host/tools/bootloader-flasher/linux
    install -m 0644 ${D}/util/Readme.md ${DEPLOYDIR}/host/tools/bootloader-flasher/linux
}

COMPATIBLE_MACHINE = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
