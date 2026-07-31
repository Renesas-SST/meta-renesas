SUMMARY = "Private PowerVR GBM library"
LICENSE = "MIT"
SECTION = "libs"

COMPATIBLE_MACHINE = "rz-cmn"
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILESEXTRAPATHS:prepend := "${THISDIR}/libgbm:"

DEPENDS = "pvr-wayland-kms udev"

SRC_URI = "git://github.com/renesas-rcar/libgbm;branch=match-mesa-20.0.1;protocol=https \
           file://Add-gbm_bo_get_fd_for_plane.patch \
"

SRCREV = "538889dee7940cbcd8f384ff24436c785181cfdb"

LIC_FILES_CHKSUM = "file://gbm.c;beginline=4;endline=22;md5=5cdaac262c876e98e47771f11c7036b5"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

EXTRA_OECONF += "--libdir=${libdir}/pvr"

do_install:append() {
    rm -rf ${D}${libdir}/pvr/pkgconfig
}

FILES:${PN} = " \
    ${libdir}/pvr/libgbm.so* \
    ${libdir}/pvr/gbm/*.so* \
"
FILES:${PN}-dev = " \
    ${includedir}/gbm/* \
"
FILES:${PN}-dbg += "${libdir}/pvr/gbm/.debug/*"

PRIVATE_LIBS:${PN} = "libgbm.so.1"
INSANE_SKIP:${PN} += "dev-so"
