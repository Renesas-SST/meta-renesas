DESCRIPTION = "Trusted Firmware-A for Renesas RZ, including BL31 for the Sparrow-Hawk (V4H) companion SoC built alongside rz-cmn"

require include/rz-optee-config.inc
inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "MIT & BSD-3-Clause"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
    file://${WORKDIR}/git/sparrowhawk/license.rst;md5=1dd070c98a281d18d9eefd938729b031 \
"
# Set S variable to folder that includes Makefile
S = "${WORKDIR}/git/cmn"
DEPENDS:append = " dtc-native xxd-native"

# Trusted Firmware-A source code repository
SRC_URI:rz-cmn = " \
    git://github.com/Renesas-SST/rz-atf.git;name=machine;branch=${BRANCH};protocol=https;destsuffix=git/cmn \
"
BRANCH:rz-cmn = "styhead/rz-cmn"
SRCREV_machine:rz-cmn = "${AUTOREV}"
PV = "v2.14+git"

# Configuration for rz-cmn board
PLATFORM:rz-cmn = "cmn"
EXTRA_FLAGS:rz-cmn = "BOARD=rz_cmn"
BL2_METHODS:rz-cmn = "esd xspi emmc"

FILES:${PN} = "/boot "
# Add the /boot directory to the target's sysroot
SYSROOT_DIRS += "/boot"

SEC_FLAGS = " \
    ${@oe.utils.conditional("ENABLE_SPD_OPTEE", "1", " SPD=opteed", "",d)} \
"

EXTRA_FLAGS:append = "${SEC_FLAGS}"

FILESEXTRAPATHS:append := "${THISDIR}/files"

ECC_FLAGS = " DDR_ECC_ENABLE=1 "
ECC_FLAGS += "${@oe.utils.conditional("ECC_MODE", "ERR_DETECT", "DDR_ECC_DETECT=1", "",d)}"
ECC_FLAGS += "${@oe.utils.conditional("ECC_MODE", "ERR_DETECT_CORRECT", "DDR_ECC_DETECT_CORRECT=1", "",d)}"
EXTRA_FLAGS:append = "${@oe.utils.conditional("USE_ECC", "1", " ${ECC_FLAGS} ", "",d)}"

# requires CROSS_COMPILE set by hand as there is no configure script
export CROSS_COMPILE="${TARGET_PREFIX}"

# Let the Makefile handle setting up the CFLAGS and LDFLAGS as it is a standalone application
CFLAGS[unexport] = "1"
LDFLAGS[unexport] = "1"
AS[unexport] = "1"
LD[unexport] = "1"

# Make args with option ${EXTRA_OEMAKE}
# Builds:
#   - all BL2 variants (xSPI, eMMC, eSD) via the `bl2-all` target
#   - BL31
#   - FCONF device trees (dtbs)
EXTRA_OEMAKE = "PLAT=${PLATFORM} ${EXTRA_FLAGS} LD=${TARGET_PREFIX}ld.bfd bl2-all bl31 dtbs"

# Install bl2.bin and bl31.bin to boot folder and rename.
# The Sparrow-Hawk BL31 is always installed, independent of ENABLE_V4H_DIRECT_OPTEE.
# Its SPD flavor (none vs opteed) matches whichever one do_compile:append built.
do_install() {
    install -d ${D}/boot/fdts

    for method in ${BL2_METHODS}; do
        install -m 644 ${S}/build/${PLATFORM}/release/bl2-${method}.bin ${D}/boot/bl2-${method}-${MACHINE}.bin
    done
    install -m 644 ${S}/build/${PLATFORM}/release/bl31.bin ${D}/boot/bl31-${MACHINE}.bin
    install -m 644 ${S}/build/${PLATFORM}/release/fdts/*.dtb ${D}/boot/fdts
    install -m 0644 \
        ${SPARROWHAWK_S}/build/${SPARROWHAWK_PLATFORM}/release/bl31.bin \
        ${D}/boot/bl31-sparrow-hawk.bin
}

# Deploy bin file to deploy dir
do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}/target/images/atf/fdts
    install -d ${DEPLOYDIR}/target/boot

    # Copy bl2, bl31 and fdts to deploy folder
    for method in ${BL2_METHODS}; do
        install -m 0644 ${D}/boot/bl2-${method}-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl2-${method}-${MACHINE}.bin
    done
    install -m 0644 ${D}/boot/bl31-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl31-${MACHINE}.bin
    install -m 0644 ${D}/boot/fdts/*.dtb ${DEPLOYDIR}/target/images/atf/fdts
    install -m 0644 ${D}/boot/bl31-sparrow-hawk.bin \
        ${DEPLOYDIR}/target/boot/bl31-sparrow-hawk.bin
}

addtask deploy after do_install

COMPATIBLE_MACHINE = "rz-cmn"

#==============================================================================
# Sparrow-Hawk (V4H) companion SoC support
# BL31 is built from a second checkout of upstream ARM Trusted Firmware-A
# (v2.14 release) and staged through /boot for the rootfs payload package.
#==============================================================================
SRC_URI:append:rz-cmn = " \
    git://github.com/ARM-software/arm-trusted-firmware.git;name=sparrowhawk;branch=${SPARROWHAWK_BRANCH};protocol=https;destsuffix=git/sparrowhawk \
    file://0001-rcar4-fix-opteed-runtime-setup-build.patch;patchdir=../sparrowhawk \
"
SPARROWHAWK_BRANCH = "master"
SRCREV_sparrowhawk = "${AUTOREV}"
SRCREV_FORMAT = "machine_sparrowhawk"

SPARROWHAWK_S = "${WORKDIR}/git/sparrowhawk"
SPARROWHAWK_PLATFORM = "rcar_gen4"
SPARROWHAWK_OPT = "LSI=V4H CTX_INCLUDE_AARCH32_REGS=0 MBEDTLS_COMMON_MK=1 PTP_NONSECURE_ACCESS=1 LOG_LEVEL=20 DEBUG=0 ENABLE_ASSERTIONS=0 E=0"

# Same pattern as SEC_FLAGS/ENABLE_SPD_OPTEE above for the cmn platform:
# one build, SPD picked by the enable flag. BL31 for Sparrow-Hawk is always
# built and installed either way (do_install/do_deploy are unconditional);
# only the SPD flavor of that single binary changes.
SPARROWHAWK_SPD = "${@oe.utils.conditional('ENABLE_V4H_DIRECT_OPTEE', '1', 'opteed', 'none', d)}"

# Build BL31 for the Sparrow-Hawk (V4H) companion SoC after the main build.
# Uses ${MAKE} directly (not oe_runmake) since oe_runmake always injects
# EXTRA_OEMAKE, which is set above for the cmn platform's PLAT/targets
# and would conflict with the sparrowhawk platform/targets here.
do_compile:append() {
    cd ${SPARROWHAWK_S}
    ${MAKE} distclean
    ${MAKE} bl31 PLAT=${SPARROWHAWK_PLATFORM} SPD=${SPARROWHAWK_SPD} MBEDTLS_COMMON_MK=1 ${SPARROWHAWK_OPT}
}
