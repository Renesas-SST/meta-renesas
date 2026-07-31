DESCRIPTION = "OP-TEE regression test suite"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE-BSD;md5=dca16d6efa93b55d0fd662ae5cd6feeb"

PV = "4.10.0+git${SRCPV}"
SRC_URI = "git://github.com/OP-TEE/optee_test.git;branch=master;protocol=https"
SRCREV = "88c93e87a5c172363ee986ded036a25cafcc9d2c"

DEPENDS = "optee-client optee-os openssl"
COMPATIBLE_MACHINE = "rz-cmn"

S = "${WORKDIR}/git"

do_compile() {
    oe_runmake \
        CROSS_COMPILE=${TARGET_PREFIX} \
        CFLAGS64="--sysroot=${STAGING_DIR_TARGET}" \
        TA_DEV_KIT_DIR=${STAGING_DIR_TARGET}${includedir}/optee/export-user_ta \
        OPTEE_CLIENT_EXPORT=${STAGING_DIR_TARGET}${prefix}
}

do_install() {
    oe_runmake install \
        DESTDIR=${D} \
        bindir=${bindir} \
        libdir=${nonarch_libdir} \
        CFLAGS64="--sysroot=${STAGING_DIR_TARGET}" \
        TA_DEV_KIT_DIR=${STAGING_DIR_TARGET}${includedir}/optee/export-user_ta \
        OPTEE_CLIENT_EXPORT=${STAGING_DIR_TARGET}${prefix}
}

FILES:${PN} = "${bindir}/xtest ${nonarch_libdir}/optee_armtz ${libdir}/tee-supplicant/plugins"
