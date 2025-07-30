SUMMARY = "audio initialization script"
DESCRIPTION = "This script initializes audio settings on system startup."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
	file://audio-init.sh \
"

do_install() {
	install -d ${D}/${sysconfdir}/profile.d
	install -m 0755 ${UNPACKDIR}/audio-init.sh ${D}/${sysconfdir}/profile.d
}

RDEPENDS:${PN} += "bash"

COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
