#
# Copyright (c) 2024 IMD Technologies
# Copyright (C) 2025 Renesas Electronics
#

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://ap1302_ar1335_single_fw.bin \
"

do_install:append() {
    # AP1302 ISP firmware
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 0644 ${UNPACKDIR}/ap1302_ar1335_single_fw.bin ${D}${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin
}

PACKAGES =+ "${PN}-ap1302"

FILES:${PN}-ap1302 = " \
    ${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin \
"
