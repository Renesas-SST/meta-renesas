DESCRIPTION = "Trusted Firmware-A for Renesas RZ"

require include/rz-optee-config.inc
inherit deploy

DEPENDS:append = " dtc-native"
PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
"
# Set S variable to folder that includes Makefile
S = "${WORKDIR}/git"
UNPACKDIR = "${S}"

SRC_URI:rz-cmn = " \
    git://github.com/Renesas-SST/rz-atf.git;name=rzg2l-sbc;subdir=rzg2l-sbc;branch=styhead/rz-cmn;protocol=https \
    git://github.com/Renesas-SST/rz-atf.git;name=rzg2l-evk;subdir=rzg2l-evk;branch=styhead/rz-cmn;protocol=https \
    git://github.com/Renesas-SST/rz-atf.git;name=rzv2l-evk;subdir=rzv2l-evk;branch=styhead/rz-cmn;protocol=https \
    git://github.com/vudangRVC/rz-atf-sst.git;name=rzv2h-evk;subdir=rzv2h-evk;branch=atf-pass-params-v2h;protocol=https \
"

SRCREV_rzg2l-sbc = "${AUTOREV}"
SRCREV_rzg2l-evk = "${AUTOREV}"
SRCREV_rzv2l-evk = "${AUTOREV}"
SRCREV_rzv2h-evk = "${AUTOREV}"
SRCREV_FORMAT = "rzg2l-sbc_rzg2l-evk_rzv2l-evk_rzv2h-evk"
PV = "v2.9+git"

# Configuration for multi boards
FLASH_ADDRESS_BL2_BP:rz-cmn = "00000"
FLASH_ADDRESS_FIP:rz-cmn = "1D200"

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

TARGETS = "rzg2l-sbc rzg2l-evk rzv2l-evk rzv2h-evk"

do_compile() {
    cd ${S}/rzg2l-sbc
    BUILD_FLAGS="PLAT=g2l BOARD=sbc_1"
    make ${BUILD_FLAGS} bl2_with_dtb  bl31

    cd ${S}/rzg2l-evk
    BUILD_FLAGS="PLAT=g2l BOARD=smarc_pmic_2"
    make ${BUILD_FLAGS} bl2_with_dtb  bl31

    cd ${S}/rzv2l-evk
    BUILD_FLAGS="PLAT=v2l BOARD=smarc_rzv2l"
    make ${BUILD_FLAGS} bl2_with_dtb  bl31

    cd ${S}/rzv2h-evk
    BUILD_FLAGS="PLAT=v2h BOARD=evk_1 ENABLE_STACK_PROTECTOR=default"
    make ${BUILD_FLAGS} bl2 bl31
}

# Install bl2.bin and bl31.bin to boot folder and rename
do_install() {
    install -d ${D}/boot
    for target in ${TARGETS}; do
        if [ ${target} = "rzg2l-sbc" ] || [ ${target} = "rzg2l-evk" ]; then
            PLATFORM="g2l"
        elif [ ${target} = "rzv2l-evk" ]; then
            PLATFORM="v2l"
        elif [ ${target} = "rzv2h-evk" ]; then
            PLATFORM="v2h"
        fi
        install -m 644 ${S}/${target}/build/${PLATFORM}/release/bl2.bin ${D}/boot/bl2-${target}.bin
        install -m 644 ${S}/${target}/build/${PLATFORM}/release/bl31.bin ${D}/boot/bl31-${target}.bin
    done
}

do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}
    install -d ${DEPLOYDIR}/target/images

    for target in ${TARGETS}; do
        if [ ${target} = "rzg2l-sbc" ] || [ ${target} = "rzg2l-evk" ]; then
            PLATFORM="g2l"
        elif [ ${target} = "rzv2l-evk" ]; then
            PLATFORM="v2l"
        elif [ ${target} = "rzv2h-evk" ]; then
            PLATFORM="v2h"
        fi
        # Copy IPL to deploy folder
        install -m 0644 ${S}/${target}/build/${PLATFORM}/release/bl2/bl2.elf ${DEPLOYDIR}/bl2-${target}.elf
        install -m 0644 ${S}/${target}/build/${PLATFORM}/release/bl2.bin ${DEPLOYDIR}/bl2-${target}.bin
        install -m 0644 ${S}/${target}/build/${PLATFORM}/release/bl31/bl31.elf ${DEPLOYDIR}/bl31-${target}.elf
        install -m 0644 ${S}/${target}/build/${PLATFORM}/release/bl31.bin ${DEPLOYDIR}/bl31-${target}.bin

        install -m 0644 ${D}/boot/bl2-${target}.bin ${DEPLOYDIR}/target/images/bl2-${target}.bin
    done
}

addtask deploy after do_install

COMPATIBLE_MACHINE = "rz-cmn"
