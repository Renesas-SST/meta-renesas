# Support script for SD card flashing on Windows
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
    cd ${D}/util/
    unzip -o filesystem-windows-script.zip
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/sd-creator/windows/tools
    install -m 0755 ${D}/util/filesystem-windows-script/config.ini ${DEPLOYDIR}/host/tools/sd-creator/windows
    install -m 0755 ${D}/util/filesystem-windows-script/flash_filesystem.bat ${DEPLOYDIR}/host/tools/sd-creator/windows
    install -m 0755 ${D}/util/filesystem-windows-script/Readme.md ${DEPLOYDIR}/host/tools/sd-creator/windows 
    install -m 0755 ${D}/util/filesystem-windows-script/tools/* ${DEPLOYDIR}/host/tools/sd-creator/windows/tools
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
