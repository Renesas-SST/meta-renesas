#
# Copyright (c) 2022 IMD Technologies
# Copyright (C) 2025 Renesas Electronics
#

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
   file://hostapd.conf \
   file://hostapd.service \
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
   install -d ${D}${sysconfdir}
   install -m 600 ${UNPACKDIR}/hostapd.conf ${D}${sysconfdir}

   install -d ${D}${systemd_system_unitdir}
   install -m 0644 ${UNPACKDIR}/hostapd.service ${D}${systemd_system_unitdir}
}
