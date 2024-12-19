DESCRIPTION = "VSP Manager for the RZG2"

LICENSE = "GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
    file://GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://MIT-COPYING;md5=0ebf15a927e436cec699371cd890775c \
"

inherit module
require include/rzg2l-sbc-modules-common.inc

DEPENDS = "linux-yocto"
PN = "kernel-module-vspm"
PR = "r0"

VSPM_DRV_URL = "git://github.com/renesas-rcar/vspm_drv.git"
BRANCH = "rcar_gen3"
SRCREV = "07787fc1168e7fe37c305aca151a6f756f35874f"

SRC_URI = "${VSPM_DRV_URL};branch=${BRANCH};protocol=https"

SRC_URI:append:rzg2l-sbc = " \
        file://0001-Add-ISU-driver.patch \
        file://0002-Add-option-ISU_CSC_RAW.patch \
        file://0003-Add-ISU-to-VSPM.patch \
        file://0004-Modify-Makefile.patch \
        file://0005-remove-work-around-clock-reset-supply.patch \
        file://0006-Support-MUTUAL-mode-for-ISU.patch \
        file://0007-Update-and-fix-some-small-bugs-of-ISU-driver.patch \
        file://0008-Correcting-variable-type.patch \
        file://0009-Wrong-initialize-value-of-clip.patch \
        file://0010-Fix-wrong-output-size-in-setting-case-rs_par-is-NULL.patch \
        file://0011-Fix-error-cannot-detect-NOOUT-in-case-rs_par-NULL.patch \
        file://0012-vspm_main-Update-isu-clock-enable.patch \
        file://0013-vspm-isu-Check-addr-of-1st-plane-in-parameter-for-RP.patch \
        file://0014-rzg2l-sbc-get-interrupt-number.patch \
        file://0015-rzg2l-sbc-vspm-supports-kernel-6.10.patch \
"

S = "${WORKDIR}/git"
VSPM_DRV_DIR = "vspm-module/files/vspm"
B = "${S}/${VSPM_DRV_DIR}/drv"
includedir = "${RENESAS_DATADIR}/include"

# Build VSP Manager kernel module without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

# EXTRA_OEMAKE = "all"

do_install () {
    # Create destination directories
    install -d ${D}/usr/lib/modules/${KERNEL_VERSION}/extra/
    install -d ${D}/${includedir}

    # Install shared library to KERNELSRC(STAGING_KERNEL_DIR) for reference from other modules
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/Module.symvers ${KERNELSRC}/include/vspm.symvers

    # Install kernel module
    install -m 644 ${B}/vspm.ko ${D}/usr/lib/modules/${KERNEL_VERSION}/extra/

    # Install shared header files to KERNELSRC(STAGING_KERNEL_DIR)
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/../include/vspm_public.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/vspm_cmn.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/vsp_drv.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/fdp_drv.h ${KERNELSRC}/include/

    # Install shared header files
    install -m 644 ${B}/../include/vspm_cmn.h ${D}/${includedir}/
    install -m 644 ${B}/../include/vsp_drv.h ${D}/${includedir}/
    install -m 644 ${B}/../include/fdp_drv.h ${D}/${includedir}/
}

do_install:append:rzg2l-sbc () {
    install -m 644 ${B}/../include/isu_drv.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/isu_drv.h ${D}/${includedir}/
}

# Should also clean deploy/licenses directory
# for module when do_clean.
do_clean[cleandirs] += "${LICENSE_DIRECTORY}/${PN}"

PACKAGES = " \
    ${PN} \
    ${PN}-dev \
    ${PN}-dbg \
"

FILES:${PN} = " \
    /usr/lib/modules/${KERNEL_VERSION}/extra/vspm.ko \
"

RPROVIDES:${PN} += "kernel-module-vspm"

# Autoload VSPM
KERNEL_MODULE_AUTOLOAD += "vspm"
