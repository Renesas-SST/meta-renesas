SUMMARY = "OpenMAX IL plugins for GStreamer"
DESCRIPTION = "Wraps available OpenMAX IL components and makes them available as standard GStreamer elements."
HOMEPAGE = "http://gstreamer.freedesktop.org/"
SECTION = "multimedia"

LICENSE = "LGPL-2.1-or-later"
LICENSE_FLAGS = "commercial"

SRC_URI = " \
    git://github.com/renesas-rcar/gst-omx.git;branch=RCAR-GEN3e/1.18.5;protocol=https \
    file://0001-Support-Bypass-mode.patch \
    file://0002-Fix-error-Resolution-do-not-match-in-running-case-fi.patch \
    file://0003-Add-lossy-compress-option-and-bypass-property.patch \
    file://0004-gst-pipeline-cannot-corectly-decode-with-vspmfilter-.patch \
    file://gstomx-rzg2l.conf \
"

SRCREV = "37b5482c37a0c6f58160180cfd443313cc3f6628"

DEPENDS = "gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-bad virtual/libomxil"

inherit meson pkgconfig upstream-version-is-even

LIC_FILES_CHKSUM = " \
    file://COPYING;md5=4fbd65380cdd255951079008b364516c \
    file://omx/gstomx.h;beginline=1;endline=22;md5=4b2e62aace379166f9181a8571a14882 \
"

S = "${WORKDIR}/git"

CONFIGUREOPT_DEPTRACK:append = " --with-omx-target=rcar"

SRCREV_FORMAT = "base_common"

require include/rzg2l-sbc-path-common.inc

DEPENDS += "omx-user-module mmngrbuf-user-module"

GSTREAMER_1_0_OMX_TARGET = "rcar"
GSTREAMER_1_0_OMX_CORE_NAME = "${libdir}/libomxr_core.so"
EXTRA_OEMESON += "-Dheader_path=${STAGING_DIR_TARGET}/usr/local/include"
EXTRA_OEMESON += "-Dtarget=${GSTREAMER_1_0_OMX_TARGET}"

do_configure:prepend() {
    cd ${S}
    install -m 0644 ${UNPACKDIR}/gstomx-rzg2l.conf ${S}/config/rcar/gstomx.conf
    sed -i 's,@RENESAS_DATADIR@,${RENESAS_DATADIR},g' ${S}/config/rcar/gstomx.conf
    cd ${B}
}

set_omx_core_name() {
	sed -i -e "s;^core-name=.*;core-name=${GSTREAMER_1_0_OMX_CORE_NAME};" "${D}${sysconfdir}/xdg/gstomx.conf"
}
do_install[postfuncs] += " set_omx_core_name "

FILES:${PN} += "${libdir}/gstreamer-1.0/*.so"
FILES:${PN}-staticdev += "${libdir}/gstreamer-1.0/*.a"

VIRTUAL-RUNTIME_libomxil ?= "libomxil"
RDEPENDS:${PN} = "${VIRTUAL-RUNTIME_libomxil}"

RDEPENDS:${PN}:append = " omx-user-module"
RDEPENDS:${PN}:remove = "libomxil"
