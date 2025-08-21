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

SRC_URI:rz-cmn = " \
    git://github.com/Renesas-SST/rz-atf.git;name=machine;branch=${BRANCH};protocol=https \
"

BRANCH:rz-cmn = "styhead/rz-cmn"
SRCREV_machine:rz-cmn = "${AUTOREV}"
PV = "v2.9+git"

# Configuration for rz-cmn board
PLATFORM:rz-cmn = "cmn"
EXTRA_FLAGS:rz-cmn = "BOARD=rz_cmn"

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
EXTRA_OEMAKE="PLAT=${PLATFORM} ${EXTRA_FLAGS} bl2 bl31 dtbs"

# Install bl2.bin and bl31.bin to boot folder and rename
do_install() {
    install -d ${D}/boot
    install -d ${D}/boot/fdts
    install -m 644 ${S}/build/${PLATFORM}/release/bl2.bin ${D}/boot/bl2-${MACHINE}.bin
    install -m 644 ${S}/build/${PLATFORM}/release/bl31.bin ${D}/boot/bl31-${MACHINE}.bin
    install -m 644 ${S}/build/${PLATFORM}/release/fdts/*.dtb ${D}/boot/
}

do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}

    # Copy IPL to deploy folder
    install -m 0644 ${S}/build/${PLATFORM}/release/bl2/bl2.elf ${DEPLOYDIR}/bl2-${MACHINE}.elf
    install -m 0644 ${S}/build/${PLATFORM}/release/bl2.bin ${DEPLOYDIR}/bl2-${MACHINE}.bin
    install -m 0644 ${S}/build/${PLATFORM}/release/bl31/bl31.elf ${DEPLOYDIR}/bl31-${MACHINE}.elf
    install -m 0644 ${S}/build/${PLATFORM}/release/bl31.bin ${DEPLOYDIR}/bl31-${MACHINE}.bin

    install -d ${DEPLOYDIR}/target/images/atf/fdts
    install -m 0644 ${D}/boot/bl2-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl2-${MACHINE}.bin
    install -m 0644 ${D}/boot/bl31-${MACHINE}.bin ${DEPLOYDIR}/target/images/atf/bl31-${MACHINE}.bin
    install -m 0644 ${D}/boot/*.dtb ${DEPLOYDIR}/target/images/atf/fdts
}

addtask deploy after do_install

COMPATIBLE_MACHINE = "rz-cmn"
