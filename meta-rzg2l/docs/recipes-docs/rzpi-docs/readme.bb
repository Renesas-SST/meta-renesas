SUMMARY = "Support script for bootloader flashing on Windows"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
	file://README.md \
"
COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += ""
AKKOW_EMPTY_${PN} = "1"

do_deploy () {
	install -d ${DEPLOY_DIR_IMAGE}
	install -m 0755 ${S}/README.md ${DEPLOY_DIR_IMAGE}
}

addtask deploy after do_install
