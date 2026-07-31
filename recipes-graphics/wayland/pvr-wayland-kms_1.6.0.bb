SUMMARY = "Private PowerVR KMS library for Wayland"
LICENSE = "MIT"

COMPATIBLE_MACHINE = "rz-cmn"
PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "libdrm wayland wayland-native virtual/egl"

PV:append = "+git${SRCREV}"

SRC_URI = "git://github.com/renesas-rcar/wayland-kms.git;branch=rcar-gen3;protocol=https"
SRCREV = "15184e5bd3701938a6b30b8f03b471477fc742e8"

LIC_FILES_CHKSUM = "file://wayland-kms.c;beginline=6;endline=24;md5=5cdaac262c876e98e47771f11c7036b5"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

EXTRA_OECONF += "--libdir=${libdir}/pvr"

do_install:append() {
    install -d ${D}${libdir}/pkgconfig
    if [ -f ${D}${libdir}/pvr/pkgconfig/wayland-kms.pc ]; then
        mv ${D}${libdir}/pvr/pkgconfig/wayland-kms.pc ${D}${libdir}/pkgconfig/
        rmdir --ignore-fail-on-non-empty ${D}${libdir}/pvr/pkgconfig || true
        sed -i "s#^libdir=.*#libdir=${libdir}/pvr#" ${D}${libdir}/pkgconfig/wayland-kms.pc
    fi
}

FILES:${PN} = "${libdir}/pvr/libwayland-kms.so*"
FILES:${PN}-dev = " \
    ${includedir}/* \
    ${libdir}/pkgconfig/wayland-kms.pc \
"

INSANE_SKIP:${PN} += "dev-so"
