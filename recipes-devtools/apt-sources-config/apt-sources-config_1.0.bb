SUMMARY = "Configuration for APT sources"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
        file://sources.list \
        file://trusted.gpg \
"

do_install() {
    install -d ${D}${sysconfdir}/apt/sources.list.d
    install -m 0644 ${S}/sources.list ${D}/${sysconfdir}/apt/sources.list.d/sources.list

    # Install the GPG key to apt's trusted keyring directory in the rootfs
    # This key will be used by apt to authenticate packages and repositories
    install -d ${D}${sysconfdir}/apt/trusted.gpg.d
    install -m 0644 ${S}/trusted.gpg ${D}/${sysconfdir}/apt/trusted.gpg.d/
}

FILES:${PN} = " \
        ${sysconfdir}/apt/sources.list.d/sources.list \
        ${sysconfdir}/apt/trusted.gpg.d/trusted.gpg \
"
