# Add files for flashing images onto an sd card
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://sd_flash.sh \
    file://Readme.md \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/sd_flash.sh ${D}/util/sd_flash.sh
    install -m 0644 ${S}/Readme.md ${D}/util/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/sd-creator/linux
    install -m 0644 ${D}/util/sd_flash.sh ${DEPLOYDIR}/host/tools/sd-creator/linux
    install -m 0644 ${D}/util/Readme.md ${DEPLOYDIR}/host/tools/sd-creator/linux
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
