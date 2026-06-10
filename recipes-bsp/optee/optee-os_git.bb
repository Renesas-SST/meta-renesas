DESCRIPTION = "OP-TEE OS for Renesas RZ CMN"
LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "python3-cryptography-native python3-pyelftools-native"

require include/rz-optee-config.inc
inherit deploy python3native

PV = "4.10.0+git${SRCPV}"
BRANCH = "styhead/rz-cmn"
SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/Renesas-SST/rz_optee_os.git;branch=${BRANCH};protocol=https"

COMPATIBLE_MACHINE = "rz-cmn"
S = "${WORKDIR}/git"

PLATFORM = "rz"
PLATFORM_V4H = "rcar_gen4"
LSI_V4H = "V4H"

LD[unexport] = "1"
LDFLAGS[unexport] = "1"
libdir[unexport] = "1"

export CROSS_COMPILE64 = "${TARGET_PREFIX}"
CFLAGS:prepend = "--sysroot=${STAGING_DIR_HOST} "

RZ_SCE = "${@oe.utils.conditional('ENABLE_RZ_SCE', '1', 'y', 'n', d)}"

# Common make flags for RZ CMN (G2L/V2L, V2H) flavors
OPTEE_COMMON_FLAGS = " \
    PLATFORM=${PLATFORM} \
    CFG_ARM64_core=y \
    CFG_REE_FS=y \
    CFG_RPMB_FS=n \
    CFG_CRYPTO_WITH_CE=n \
    CFG_RZ_SCE=${RZ_SCE} \
    CROSS_COMPILE64=${TARGET_PREFIX} \
"

do_compile() {
    export PATH="${STAGING_BINDIR_NATIVE}/python3-native:${PATH}"
    export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

    # Build G2L/V2L flavor (CFG_DT=y: NS DTB injection via U-Boot)
    oe_runmake ${OPTEE_COMMON_FLAGS} \
        PLATFORM_FLAVOR=g2l_smarc_2 \
        CFG_DT=y \
        O=${S}/out-g2l

    # Build V2H flavor (CFG_DT=n: static DT node in kernel)
    oe_runmake ${OPTEE_COMMON_FLAGS} \
        PLATFORM_FLAVOR=v2h_evk_1 \
        CFG_DT=n \
        O=${S}/out-v2h

    # Build V4H flavor (plat-rcar_gen4, LSI=V4H, CFG_DT=n: BL31 does not pass DTB)
    oe_runmake -C ${S} \
        PLATFORM=${PLATFORM_V4H} \
        LSI=${LSI_V4H} \
        CFG_ARM64_core=y \
        CFG_DT=n \
        CROSS_COMPILE64=${TARGET_PREFIX} \
        O=${S}/out-v4h
}

do_install() {
    install -d ${D}/boot

    install -m 0644 ${S}/out-g2l/core/tee-raw.bin          ${D}/boot/tee-${MACHINE}-g2l.bin
    install -m 0644 ${S}/out-v2h/core/tee-raw.bin          ${D}/boot/tee-${MACHINE}-v2h.bin
    install -m 0644 ${S}/out-v4h/core/tee-raw.bin                 ${D}/boot/tee-${MACHINE}-v4h.bin

    install -d ${D}${includedir}/optee/export-user_ta
    cp -aR ${S}/out-g2l/export-ta_arm64/* ${D}${includedir}/optee/export-user_ta/
}

do_deploy() {
    install -d ${DEPLOYDIR}/target/images/atf

    install -m 0644 ${D}/boot/tee-${MACHINE}-g2l.bin ${DEPLOYDIR}/target/images/atf/tee-${MACHINE}-g2l.bin
    install -m 0644 ${D}/boot/tee-${MACHINE}-v2h.bin ${DEPLOYDIR}/target/images/atf/tee-${MACHINE}-v2h.bin
    install -m 0644 ${D}/boot/tee-${MACHINE}-v4h.bin ${DEPLOYDIR}/target/images/atf/tee-${MACHINE}-v4h.bin
}

addtask deploy after do_install

FILES:${PN} = "/boot"
SYSROOT_DIRS += "/boot"
FILES:${PN}-dev = "${includedir}/optee"
INSANE_SKIP:${PN}-dev = "staticdev buildpaths"
INSANE_SKIP:${PN} = "buildpaths"
