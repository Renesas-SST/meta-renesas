# Support script for bootloader flashing on Windows
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://filesystem-windows-script.zip;unpack=0 \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0755 ${S}/filesystem-windows-script.zip ${D}/util/filesystem-windows-script.zip
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -m 0755 ${D}/util/filesystem-windows-script.zip ${DEPLOYDIR}
    cd ${DEPLOYDIR}
    unzip -o filesystem-windows-script.zip
    rm -f filesystem-windows-script.zip
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
