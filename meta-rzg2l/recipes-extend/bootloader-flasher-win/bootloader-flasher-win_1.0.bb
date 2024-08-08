# Support script for bootloader flashing on Windows
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "trusted-firmware-a u-boot firmware-pack flash-writer"

S = "${WORKDIR}"

SRC_URI = " \
    file://bootloader-windows-script.zip;unpack=0 \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0755 ${S}/bootloader-windows-script.zip ${D}/util/bootloader-windows-script.zip
    cd ${D}/util/
    unzip -o bootloader-windows-script.zip
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/host/tools/bootloader-flasher/windows/tools
    install -m 0755 ${D}/util/bootloader-windows-script/config.ini ${DEPLOYDIR}/host/tools/bootloader-flasher/windows
    install -m 0755 ${D}/util/bootloader-windows-script/flash_bootloader.bat ${DEPLOYDIR}/host/tools/bootloader-flasher/windows
    install -m 0755 ${D}/util/bootloader-windows-script/Readme.md ${DEPLOYDIR}/host/tools/bootloader-flasher/windows
    install -m 0755 ${D}/util/bootloader-windows-script/tools/* ${DEPLOYDIR}/host/tools/bootloader-flasher/windows/tools
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
