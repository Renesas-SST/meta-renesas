# U-Boot environment for RZ SBC board
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://uEnv.txt \
    file://Readme.md \
"

FILES_${PN} += "/boot"

do_install () {
    install -d ${D}/boot
    install -m 0644 ${S}/uEnv.txt ${D}/boot/uEnv.txt
    install -m 0644 ${S}/Readme.md ${D}/boot/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/target/env
    install -m 0644 ${D}/boot/uEnv.txt ${DEPLOYDIR}/target/env
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
