SUMMARY = "Recipe to install a profile file for quickboot wayland target"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://profile \
"

do_install() {
    install -d ${D}/home/root/
    install -m 0755 ${S}/profile ${D}/home/root/.profile
}

FILES:${PN} += " \
    /home/root/.profile \
"
