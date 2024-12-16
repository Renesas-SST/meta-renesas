# Add Readme file to the sd-creator directory in the build folder

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://Readme.md \
"

FILES:${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/Readme.md ${D}/util/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/sd-creator/
    install -m 0644 ${D}/util/Readme.md ${DEPLOYDIR}/host/tools/sd-creator
}

COMPATIBLE_MACHINE = "(rzg2l-sbc)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
