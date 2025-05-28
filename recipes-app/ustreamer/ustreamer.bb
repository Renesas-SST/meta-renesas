SUMMARY = "µStreamer - Lightweight and fast MJPEG-HTTP streamer"
SECTION = "app"
LICENSE = "GPL-3.0-or-later"
#" GPL-3.0 license"
LIC_FILES_CHKSUM = " \
	file://LICENSE;md5=d32239bcb673463ab874e80d47fae504 \
"

inherit systemd

PV = "6.7"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = " \
	git://github.com/pikvm/ustreamer.git;protocol=https;branch=master \
	file://ustreamer@.service \
"
SRCREV = "v${PV}"
S = "${WORKDIR}/git"

SRC_URI[sha256sum] = "51a8a974d55d5139a86c055df63b99e90e31e9d6af62f69b2decccdb02a29092"

DEPENDS += " libbsd libevent libjpeg-turbo "

do_install() {
	install -m 0755 -d ${D}${bindir}
	install -m 0755 ${S}/src/ustreamer.bin ${D}${bindir}/ustreamer

	install -m 0755 -d ${D}${systemd_unitdir}/system
	install -m 0644 ${UNPACKDIR}/ustreamer@.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_SERVICE_${PN} = "ustreamer@.service"

FILES:${PN} = " \
	${systemd_unitdir}/* \
	${bindir}/* \
"
HOMEPAGE = "https://github.com/pikvm/ustreamer.git"
MAINTAINER = "mdevaev@gmail.com"