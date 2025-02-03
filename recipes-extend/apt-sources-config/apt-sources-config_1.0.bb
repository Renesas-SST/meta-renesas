SUMMARY = "Configuration for APT sources"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
        file://sources.list \
"

do_install() {
        install -d ${D}${sysconfdir}/apt/sources.list.d
        install -m 0644 ${S}/sources.list ${D}/${sysconfdir}/apt/sources.list.d/sources.list
}

FILES:${PN} = " \
        ${sysconfdir}/apt/sources.list.d/sources.list \"
