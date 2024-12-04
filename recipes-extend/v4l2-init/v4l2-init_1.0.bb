SUMMARY = "V4L2 initialization script"
DESCRIPTION = "This script initializes V4L2 settings on system startup."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
	file://v4l2-init.sh \
"

do_install() {
	install -d ${D}/home/root
	install -m 0755 ${UNPACKDIR}/v4l2-init.sh ${D}/home/root
}

FILES:${PN} += " \
    /home/root/v4l2-init.sh \
"

RDEPENDS_${PN} += "bash"

COMPATIBLE_MACHINE:rzg2l-sbc = "(rzg2l-sbc)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
