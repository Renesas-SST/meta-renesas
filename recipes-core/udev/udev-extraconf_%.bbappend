#
# Copyright (c) 2024 IMD Technologies
# Copyright (C) 2025 Renesas Electronics
#

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI:append = " file://ap1302-sensor-rzv2h.conf "

do_install:append() {
    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${UNPACKDIR}/ap1302-sensor-rzv2h.conf ${D}${sysconfdir}/modprobe.d
}

FILES:${PN} += "${sysconfdir}/modprobe.d"
