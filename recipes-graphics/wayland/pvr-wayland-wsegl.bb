SUMMARY = "Private PowerVR Wayland WSEGL library"
SECTION = "libs"
LICENSE = "MIT"

COMPATIBLE_MACHINE = "rz-cmn"
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILESEXTRAPATHS:prepend := "${THISDIR}/wayland-wsegl:"

DEPENDS = "pvr-libgbm pvr-wayland-kms gles-user-module libdrm wayland wayland-native wayland-protocols virtual/egl"

SRC_URI = "git://github.com/renesas-rcar/wayland-wsegl.git;branch=rcar_gen5;protocol=https"
SRC_URI:append = " file://0001-Fix-include-path.patch"
SRCREV = "ef1e31db2b99bc3fe53d37e1dc8159d478505972"

LIC_FILES_CHKSUM = "file://src/waylandws.h;beginline=1;endline=22;md5=ebf7ec97b867b0329acbb2c4190fd7a9"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

EXTRA_OECONF += "--libdir=${libdir}/pvr"
CFLAGS:append = " -I${STAGING_INCDIR}/gbm -I${STAGING_INCDIR}/pvr"
LDFLAGS:append = " -L${STAGING_LIBDIR}/pvr"

FILES:${PN} = "${libdir}/pvr/libpvrWAYLAND_WSEGL.so*"
RDEPENDS:${PN} += "gles-user-module pvr-libgbm pvr-wayland-kms"
INSANE_SKIP:${PN} += "dev-so"
