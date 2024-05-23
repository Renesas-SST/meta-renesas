#
# Copyright (c) 2024 IMD Technologies
# Copyright (C) 2025 Renesas Electronics
#

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://ap1302_ar1335_single_fw.bin \
    file://sdiouartiw416_combo_v0.bin.lf-5.10.72_2.2.0 \
"

do_install:append() {
    # AP1302 ISP firmware
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 0644 ${UNPACKDIR}/ap1302_ar1335_single_fw.bin ${D}${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin

    # Install NXP Connectivity IW416 firmware
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${UNPACKDIR}/sdiouartiw416_combo_v0.bin.lf-5.10.72_2.2.0 ${D}${nonarch_base_libdir}/firmware/nxp/sdiouartiw416_combo_v0.bin
}

PACKAGES =+ "${PN}-ap1302 ${PN}-sdiouartiw416"

FILES:${PN}-ap1302 = "${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin"
FILES:${PN}-sdiouartiw416 = "${nonarch_base_libdir}/firmware/nxp/sdiouartiw416_combo_v0.bin"
