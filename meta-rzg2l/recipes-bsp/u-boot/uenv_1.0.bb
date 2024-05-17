# U-Boot environment for RZ SBC board
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://rzpi-uEnv.txt \
    file://readme.txt \
"

FILES_${PN} += "/boot"

do_install () {
    install -d ${D}/boot
    install -m 0644 ${S}/rzpi-uEnv.txt ${D}/boot/uEnv.txt
    install -m 0644 ${S}/readme.txt ${D}/boot/readme.txt
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -m 0644 ${D}/boot/uEnv.txt ${DEPLOYDIR}
    install -m 0644 ${D}/boot/readme.txt ${DEPLOYDIR}
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
