DESCRIPTION = "Memory Manager Kernel module for Renesas RZG2"
RENESAS_DATADIR ?= "/usr/local"
require mmngr_drv.inc

DEPENDS = "linux-yocto"
PN = "kernel-module-mmngr"
PR = "r0"

S = "${WORKDIR}/git"
MMNGR_DRV_DIR = "mmngr_drv/mmngr/mmngr-module/files/mmngr"
B = "${S}/${MMNGR_DRV_DIR}/drv"

SRC_URI:append = " \
    file://0001-Add-physical-address-translating-feature.patch \
    file://0002-mmngr_drv-mmngr-Add-checking-NULL-vma-in-mm_cnv_addr.patch \
    file://0003-mmngr-Get-start-address-of-MMP-area-from-DT.patch \
    file://0004-Do-not-parse-and-init-lossy-mem-area-for-RZ-G2L-Seri.patch \
    file://0005-mmngr_drv-mmngr-Update-PA-VA-mapping-table-for-HiHop.patch \
    file://0006-mmngr-change-address-setting-for-H3N-Swap-mode.patch \
    file://0001-Reduce-MM_OMXBUF_SIZE-for-omx.patch \
    file://0002-Fix-ioctl-MM_IOC_VTOP-hang-up.patch \
    file://0003-mmngr_drv-mmngr-module-drv-Update-physical-convert-f.patch \
    file://0004-mmngr-lock-mm-read-before-finding-VMA.patch \
    file://0005-rzg2l-sbc-mmngr-supports-linux-6.10.patch \
"

MMNGR_CFG ?= "MMNGR_SALVATORX"
MMNGR_CFG_ek874 = "MMNGR_EBISU"

includedir = "${RENESAS_DATADIR}/include"
SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_INCDIR}"

# Build Memory Manager kernel module without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

do_compile:prepend() {
    export MMNGR_CONFIG=${MMNGR_CFG}
    export MMNGR_SSP_CONFIG="MMNGR_SSP_DISABLE"
    export MMNGR_IPMMU_MMU_CONFIG="IPMMU_MMU_DISABLE"

    install -d ${INCSHARED}
}

do_install() {
    # Create destination directories
    install -d ${D}/usr/lib/modules/${KERNEL_VERSION}/extra/
    install -d ${D}/${includedir}

    # Install shared library to KERNELSRC(STAGING_KERNEL_DIR) for reference from other modules
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/Module.symvers ${KERNELSRC}/include/mmngr.symvers

    # Install kernel module
    install -m 644 ${B}/mmngr.ko ${D}/usr/lib/modules/${KERNEL_VERSION}/extra/

    # Install shared header files to KERNELSRC(STAGING_KERNEL_DIR)
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/../include/mmngr_public.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/mmngr_private.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/mmngr_public_cmn.h ${KERNELSRC}/include/
    install -m 644 ${B}/../include/mmngr_private_cmn.h ${KERNELSRC}/include/

    # Install shared header file to ${includedir}
    install -m 644 ${B}/../include/mmngr_public_cmn.h ${D}/${includedir}/
    install -m 644 ${B}/../include/mmngr_private_cmn.h ${D}/${includedir}/
}

PACKAGES = "\
    ${PN} \
    ${PN}-dev \
    ${PN}-dbg \
"

FILES:${PN} = " \
    /usr/lib/modules/${KERNEL_VERSION}/extra/mmngr.ko \
"

RPROVIDES:${PN} += "kernel-module-mmngr"

KERNEL_MODULE_AUTOLOAD += "mmngr"
