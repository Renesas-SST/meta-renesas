SUMMARY = "GStreamer 1.0 package groups"
LICENSE = "MIT"

DEPENDS = "gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    ${@bb.utils.contains("USE_OMX_COMMON", "1", "gstreamer1.0-omx", "", d)}"

LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
"

PR = "r0"

inherit packagegroup

PACKAGES = " \
    packagegroup-gstreamer1.0-plugins \
    packagegroup-gstreamer1.0-plugins-base \
    packagegroup-gstreamer1.0-plugins-audio \
    packagegroup-gstreamer1.0-plugins-video \
    packagegroup-gstreamer1.0-plugins-debug \
    packagegroup-gstreamer1.0-plugins-bad \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins = " \
    packagegroup-gstreamer1.0-plugins-base \
    packagegroup-gstreamer1.0-plugins-bad \
    packagegroup-gstreamer1.0-plugins-audio \
    packagegroup-gstreamer1.0-plugins-video \
    packagegroup-gstreamer1.0-plugins-debug \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
	${@bb.utils.contains("USE_OMX_COMMON", "1", "gstreamer1.0-omx", "", d)} \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins-base = " \
    gstreamer1.0-meta-base \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins-audio = " \
    gstreamer1.0-meta-audio \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins-video = " \
    gstreamer1.0-meta-video \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
        'gstreamer1.0-plugins-bad-waylandsink', '', d)} \
    gstreamer1.0-plugins-ugly-asf \
    gstreamer1.0-libav \
    gstreamer1.0-rtsp-server \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins-debug = " \
    gstreamer1.0-meta-debug \
"

RDEPENDS:packagegroup-gstreamer1.0-plugins-bad = " \
    gstreamer1.0-plugins-bad-faac \
    gstreamer1.0-plugins-bad-faad \
"
