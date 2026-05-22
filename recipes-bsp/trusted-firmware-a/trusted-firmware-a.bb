DESCRIPTION = "Trusted Firmware-A for Renesas RZ"

require include/rz-optee-config.inc
inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
"
# Set S variable to folder that includes Makefile
S = "${WORKDIR}/git"
DEPENDS:append = " dtc-native xxd-native"

# Trusted Firmware-A source code repository
# [dev] PR #26: vudangRVC/rz-atf-sst lts-v2.14.1-optee
SRC_URI:rz-cmn = " \
    git://github.com/vudangRVC/rz-atf-sst.git;name=machine;branch=${BRANCH};protocol=https \
"
BRANCH:rz-cmn = "lts-v2.14.1-optee"
SRCREV_machine:rz-cmn = "${AUTOREV}"
PV = "v2.9+git"

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

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

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

# ENABLE_PIE=1 (set by rz platform) requires ld.bfd for --no-dynamic-linker / --emit-relocs.
# TF-A bl2-all sub-makes pass LD=${LD} down; provide it explicitly so toolchain.mk
# detects gnu-ld (not gnu-gcc) and uses direct ld flags instead of -Xlinker wrappers.
TF_LD = "${TARGET_PREFIX}ld.bfd"

# Common make flags shared by all targets
TFA_MAKE_FLAGS = "PLAT=${PLATFORM} ${EXTRA_FLAGS} LD=${TF_LD}"

# bl2-all calls `make clean` between each BL2 variant, which wipes bl31.bin and dtbs.
# Build bl31 + dtbs first, save them to a staging dir, then build bl2-all, then restore.
do_compile() {
    # Build BL31 and FDTs first — before bl2-all wipes them with make clean
    oe_runmake ${TFA_MAKE_FLAGS} bl31 dtbs

    # Stage bl31 + fdts so bl2-all's make clean cannot delete them
    mkdir -p ${S}/build-staged
    cp ${S}/build/${PLATFORM}/release/bl31.bin ${S}/build-staged/bl31.bin
    cp -r ${S}/build/${PLATFORM}/release/fdts   ${S}/build-staged/fdts

    # Build all BL2 storage variants (calls make clean internally)
    oe_runmake ${TFA_MAKE_FLAGS} bl2-all

    # Restore bl31 + fdts after bl2-all's clean passes
    cp ${S}/build-staged/bl31.bin ${S}/build/${PLATFORM}/release/bl31.bin
    mkdir -p ${S}/build/${PLATFORM}/release/fdts
    cp -r ${S}/build-staged/fdts/. ${S}/build/${PLATFORM}/release/fdts/
}

# Install bl2.bin and bl31.bin to boot folder and rename
do_install() {
    install -d ${D}/boot/fdts

    for method in ${BL2_METHODS}; do
        install -m 644 ${S}/build/${PLATFORM}/release/bl2-${method}.bin ${D}/boot/bl2-${method}-${MACHINE}.bin
    done
    install -m 644 ${S}/build/${PLATFORM}/release/bl31.bin ${D}/boot/bl31-${MACHINE}.bin
    install -m 644 ${S}/build/${PLATFORM}/release/fdts/*.dtb ${D}/boot/fdts
}

# Deploy bin file to deploy dir
do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}/target/images/atf/fdts

    # Copy bl2, bl31 and fdts to deploy folder
    for method in ${BL2_METHODS}; do
        install -m 0644 ${D}/boot/bl2-${method}-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl2-${method}-${MACHINE}.bin
    done
    install -m 0644 ${D}/boot/bl31-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl31-${MACHINE}.bin
    install -m 0644 ${D}/boot/fdts/*.dtb ${DEPLOYDIR}/target/images/atf/fdts
}

addtask deploy after do_install

COMPATIBLE_MACHINE = "rz-cmn"
