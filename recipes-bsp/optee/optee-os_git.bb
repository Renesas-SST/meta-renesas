DESCRIPTION = "OP-TEE OS for Renesas RZ CMN"
LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "python3-cryptography-native python3-pyelftools-native"

require include/rz-optee-config.inc
inherit deploy python3native

PV = "4.8.0+git${SRCPV}"
BRANCH = "4.8.0/rz"
SRCREV = "82a5cd3b26ed319e8fa72b305462a78417d68daa"

SRC_URI = "git://github.com/renesas-rz/rzg_optee-os.git;branch=${BRANCH};protocol=https"

COMPATIBLE_MACHINE = "rz-cmn"
S = "${WORKDIR}/git"

PLATFORM = "rz"
OPTEE_PLATFORM_FLAVOR ?= "g2l_smarc_2"

LD[unexport] = "1"
LDFLAGS[unexport] = "1"
libdir[unexport] = "1"

export CROSS_COMPILE64 = "${TARGET_PREFIX}"
CFLAGS:prepend = "--sysroot=${STAGING_DIR_HOST} "

RZ_SCE = "${@oe.utils.conditional('ENABLE_RZ_SCE', '1', 'y', 'n', d)}"

do_compile:prepend() {
    export PATH="${STAGING_BINDIR_NATIVE}/python3-native:${PATH}"
    export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
}

EXTRA_OEMAKE = " \
    PLATFORM=${PLATFORM} \
    PLATFORM_FLAVOR=${OPTEE_PLATFORM_FLAVOR} \
    CFG_ARM64_core=y \
    CFG_REE_FS=y \
    CFG_RPMB_FS=n \
    CFG_CRYPTO_WITH_CE=n \
    CFG_RZ_SCE=${RZ_SCE} \
    CROSS_COMPILE64=${TARGET_PREFIX} \
"

do_install() {
    install -d ${D}/boot
    install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee.elf ${D}/boot/tee-${MACHINE}.elf
    install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee-raw.bin ${D}/boot/tee-${MACHINE}.bin

    install -d ${D}${includedir}/optee/export-user_ta
    cp -aR ${S}/out/arm-plat-${PLATFORM}/export-ta_arm64/* ${D}${includedir}/optee/export-user_ta/
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${D}/boot/tee-${MACHINE}.elf ${DEPLOYDIR}/tee-${MACHINE}.elf
    install -m 0644 ${D}/boot/tee-${MACHINE}.bin ${DEPLOYDIR}/tee-${MACHINE}.bin
}

addtask deploy after do_install

FILES:${PN} = "/boot"
SYSROOT_DIRS += "/boot"
FILES:${PN}-dev = "${includedir}/optee"
INSANE_SKIP:${PN}-dev = "staticdev"
