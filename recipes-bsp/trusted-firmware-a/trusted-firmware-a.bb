DESCRIPTION = "Trusted Firmware-A for Renesas RZ"

require include/rzg2l-optee-config.inc
inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
"

S = "${WORKDIR}/git"

SRC_URI:rzg2l-sbc = " \
    git://github.com/Renesas-SST/rz-atf.git;name=machine;branch=${BRANCH};protocol=https \
"

BRANCH:rzg2l-sbc = "scarthgap/rz-sbc"
SRCREV_machine:rzg2l-sbc = "${AUTOREV}"
PV = "v2.9+git"

PLATFORM:rzg2l-sbc = "g2l"
EXTRA_FLAGS:rzg2l-sbc = "BOARD=sbc_1"
PMIC_EXTRA_FLAGS:rzg2l-sbc = "BOARD=smarc_pmic_2"
FLASH_ADDRESS_BL2_BP:rzg2l-sbc = "00000"
FLASH_ADDRESS_FIP:rzg2l-sbc = "1D200"

PMIC_BUILD_DIR = "${S}/build_pmic"

FILES:${PN} = "/boot "
SYSROOT_DIRS += "/boot"

SEC_FLAGS = " \
    ${@oe.utils.conditional("ENABLE_SPD_OPTEE", "1", " SPD=opteed", "",d)} \
"
EXTRA_FLAGS:append = "${SEC_FLAGS}"
PMIC_EXTRA_FLAGS:append = "${SEC_FLAGS}"

FILESEXTRAPATHS:append := "${THISDIR}/files"

ECC_FLAGS = " DDR_ECC_ENABLE=1 "
ECC_FLAGS += "${@oe.utils.conditional("ECC_MODE", "ERR_DETECT", "DDR_ECC_DETECT=1", "",d)}"
ECC_FLAGS += "${@oe.utils.conditional("ECC_MODE", "ERR_DETECT_CORRECT", "DDR_ECC_DETECT_CORRECT=1", "",d)}"
EXTRA_FLAGS:append = "${@oe.utils.conditional("USE_ECC", "1", " ${ECC_FLAGS} ", "",d)}"
PMIC_EXTRA_FLAGS:append = "${@oe.utils.conditional("USE_ECC", "1", " ${ECC_FLAGS} ", "",d)}"

# requires CROSS_COMPILE set by hand as there is no configure script
export CROSS_COMPILE="${TARGET_PREFIX}"

# Let the Makefile handle setting up the CFLAGS and LDFLAGS as it is a standalone application
CFLAGS[unexport] = "1"
LDFLAGS[unexport] = "1"
AS[unexport] = "1"
LD[unexport] = "1"

do_compile() {
    oe_runmake PLAT=${PLATFORM} ${EXTRA_FLAGS} bl2 bl31

    if [ "${PMIC_SUPPORT}" = "1" ]; then
        oe_runmake PLAT=${PLATFORM} ${PMIC_EXTRA_FLAGS} BUILD_PLAT=${PMIC_BUILD_DIR} bl2 bl31
    fi
}

do_install() {
    install -d ${D}/boot
    install -m 644 ${S}/build/${PLATFORM}/release/bl2.bin ${D}/boot/bl2-${MACHINE}.bin
    install -m 644 ${S}/build/${PLATFORM}/release/bl31.bin ${D}/boot/bl31-${MACHINE}.bin

    if [ "${PMIC_SUPPORT}" = "1" ]; then
        install -m 0644 ${PMIC_BUILD_DIR}/bl2.bin ${D}/boot/bl2-${MACHINE}_pmic.bin
        install -m 0644 ${PMIC_BUILD_DIR}/bl31.bin ${D}/boot/bl31-${MACHINE}_pmic.bin
    fi
}

do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}

    # Copy IPL to deploy folder
    install -m 0644 ${S}/build/${PLATFORM}/release/bl2/bl2.elf ${DEPLOYDIR}/bl2-${MACHINE}.elf
    install -m 0644 ${S}/build/${PLATFORM}/release/bl2.bin ${DEPLOYDIR}/bl2-${MACHINE}.bin
    install -m 0644 ${S}/build/${PLATFORM}/release/bl31/bl31.elf ${DEPLOYDIR}/bl31-${MACHINE}.elf
    install -m 0644 ${S}/build/${PLATFORM}/release/bl31.bin ${DEPLOYDIR}/bl31-${MACHINE}.bin

    install -d ${DEPLOYDIR}/target/images
    install -m 0644 ${D}/boot/bl2-${MACHINE}.bin ${DEPLOYDIR}/target/images/bl2-${MACHINE}.bin

    if [ "${PMIC_SUPPORT}" = "1" ]; then
        install -m 0644 ${PMIC_BUILD_DIR}/bl2.bin ${DEPLOYDIR}/bl2-${MACHINE}_pmic.bin
        install -m 0644 ${PMIC_BUILD_DIR}/bl31.bin ${DEPLOYDIR}/bl31-${MACHINE}_pmic.bin
    fi
}


COMPATIBLE_MACHINE = "rzg2l-sbc"

