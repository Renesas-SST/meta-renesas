SUMMARY = "Installs and deploys a README.md file with information about RZG2L-SBC usage, \
           build process, and environment setup."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
	file://README.md \
"
COMPATIBLE_MACHINE = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES:${PN} += "/docs"

do_install () {
    install -d ${D}/docs
    install -m 0644 ${S}/README.md ${D}/docs/README.md
}

do_deploy () {
    install -m 0644 ${D}/docs/README.md ${DEPLOYDIR}
}

inherit deploy
addtask deploy after do_install
