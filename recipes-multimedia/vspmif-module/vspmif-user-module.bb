DESCRIPTION = "VSP Manager Interface library for RZG2"
require vspmif.inc

DEPENDS = "kernel-module-vspmif mmngr-user-module"
PN = "vspmif-user-module"
PR = "r0"

S = "${WORKDIR}/git"
VSPMIF_LIB_DIR = "vspm_if-module/files/vspm_if"
B = "${S}/${VSPMIF_LIB_DIR}/if"

EXTRA_OEMAKE = "ARCH=${TARGET_ARCH}"

includedir = "${RENESAS_DATADIR}/include"

WS:aarch64 = ""
WS:virtclass-multilib-lib32 = "32"

SRC_URI:append:rzg2l-sbc = " \
	file://0001-Modify-vspm_public.h-for-ISUM.patch \
	file://0002-Modify-Makefile-for-building-vspm_api_isu.patch \
	file://0003-Add-vspm_api_isu.c-for-ISUM.patch \
	file://0004-Support-libvspm-32bit.patch \
	file://0005-vspm_api_isu-Free-callback-vspmif-data-after-finishi.patch \
"

do_configure() {
    rm -rf ${S}/${VSPMIF_LIB_DIR}/if/libvspm.so*
}

do_compile:prepend() {
    if [ X${WS} = "X32" ]; then
        export VSPM32="1"
    fi
    export VSPM_LEGACY_IF="1"
}

do_install() {
    # Create destination folders
    install -d ${D}/${libdir}
    install -d ${D}/${includedir}

    # Copy shared library
    install -m 755 ${B}/libvspm.so* ${D}/${libdir}/
    cd ${D}/${libdir}/
    ln -sf libvspm.so.1.0.0 libvspm.so.1
    ln -sf libvspm.so.1 libvspm.so

    # Copy shared header files
    install -m 644 ${B}/../include/vspm_public.h ${D}/${includedir}/
    install -m 644 ${B}/../include/fdpm_api.h ${D}/${includedir}/
}

PACKAGES = "\
    ${PN} \
    ${PN}-dev \
    ${PN}-dbg \
"

INSANE_SKIP:${PN} += "libdir"
INSANE_SKIP:${PN}-dev += "libdir"
