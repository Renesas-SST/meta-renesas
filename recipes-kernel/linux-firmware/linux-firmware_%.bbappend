#
# Copyright (c) 2024 IMD Technologies
# Copyright (C) 2025 Renesas Electronics
#

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PCIE_FIRMWARE:rz-cmn = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rcar_gen4_pcie.bin;md5sum=293bdf19d8e16d3c4d8179e438db921b;name=rcargen4pcie"
PCIE_FIRMWARE_LICENSE:rz-cmn = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENSES/LICENCE.r8a779g_pcie_phy;name=rcargen4pcielic"

SRC_URI:append = " \
    file://ap1302_ar1335_single_fw.bin \
    file://sdiouartiw416_combo_v0.bin.lf-5.10.72_2.2.0 \
"
SRC_URI:append:rz-cmn = " \
    ${PCIE_FIRMWARE} \
    ${PCIE_FIRMWARE_LICENSE} \
"
SRC_URI[rcargen4pcie.sha256sum] = "cad6315e51397e9e2dd401d79eaa873c7b67290bce381bb97728883cc243e5ff"
SRC_URI[rcargen4pcielic.sha256sum] = "fa0df1c508be531a302823721ae14258ba0481c9b1d717b2d3f2344aa0f66894"

do_install:append() {
    # AP1302 ISP firmware
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 0644 ${UNPACKDIR}/ap1302_ar1335_single_fw.bin ${D}${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin

    # Install NXP Connectivity IW416 firmware
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${UNPACKDIR}/sdiouartiw416_combo_v0.bin.lf-5.10.72_2.2.0 ${D}${nonarch_base_libdir}/firmware/nxp/sdiouartiw416_combo_v0.bin
}

do_install:append:rz-cmn() {
    # R-Car Gen4 PCIe PHY firmware (Sparrow-Hawk/V4H companion SoC)
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 0644 ${UNPACKDIR}/rcar_gen4_pcie.bin ${D}${nonarch_base_libdir}/firmware/rcar_gen4_pcie.bin
    install -m 0644 ${UNPACKDIR}/LICENCE.r8a779g_pcie_phy ${D}${nonarch_base_libdir}/firmware/LICENCE.r8a779g_pcie_phy
}

# universal_flash.py's V4H flow flashes rcar_gen4_pcie.bin directly from
# target/images/ (see rz-utils' flashing README) -- it is a standalone
# firmware blob written to the board, not something read out of the
# rootfs at runtime. The base recipe has no do_deploy task, so add one
# to stage a copy there alongside the SA0/SPL and U-Boot FIT artifacts
# so the flashing tool can find it. rcar_gen4_pcie.bin only exists on
# rz-cmn (see SRC_URI:append:rz-cmn above), so guard the copy itself
# rather than the task definition -- a per-machine :rz-cmn override on
# a task that has no unversioned do_deploy() base isn't picked up by
# bitbake as a shell function.
inherit deploy

do_deploy() {
    if [ -f "${UNPACKDIR}/rcar_gen4_pcie.bin" ]; then
        install -d ${DEPLOYDIR}/target/images
        install -m 0644 ${UNPACKDIR}/rcar_gen4_pcie.bin ${DEPLOYDIR}/target/images/rcar_gen4_pcie.bin
    fi
}

addtask deploy after do_install before do_build

PACKAGES =+ "${PN}-ap1302 ${PN}-sdiouartiw416 ${PN}-rcar-gen4-pcie"

FILES:${PN}-ap1302 = "${nonarch_base_libdir}/firmware/ap1302_ar1335_single_fw.bin"
FILES:${PN}-sdiouartiw416 = "${nonarch_base_libdir}/firmware/nxp/sdiouartiw416_combo_v0.bin"
FILES:${PN}-rcar-gen4-pcie:rz-cmn = "${nonarch_base_libdir}/firmware/rcar_gen4_pcie.bin ${nonarch_base_libdir}/firmware/LICENCE.r8a779g_pcie_phy"
ALLOW_EMPTY:${PN}-rcar-gen4-pcie = "1"
