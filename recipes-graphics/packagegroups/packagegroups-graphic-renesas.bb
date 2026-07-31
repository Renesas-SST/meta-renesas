SUMMARY = "Renesas package group for Weston"
LICENSE = "CLOSED & MIT"

inherit packagegroup

PACKAGES = " \
    packagegroup-wayland-community \
    packagegroup-renesas-graphics \
    packagegroup-graphics-renesas-gles \
    packagegroup-graphics-renesas-wayland \
    packagegroup-graphics-oss-wayland \
    packagegroup-graphics-oss-opencl \
"

RDEPENDS:packagegroup-wayland-community = " \
    wayland \
    weston \
    weston-examples \
    alsa-utils \
    alsa-tools \
"

RDEPENDS:packagegroup-renesas-graphics = " \
    packagegroup-graphics-renesas-gles \
    packagegroup-graphics-renesas-wayland \
    packagegroup-graphics-oss-wayland \
    packagegroup-graphics-oss-opencl \
"

RDEPENDS:packagegroup-graphics-renesas-gles = " \
    gles-user-module \
    pvr-libgbm \
    pvr-wayland-kms \
    pvr-wayland-wsegl \
"

DEPENDS:packagegroup-graphics-renesas-wayland = "virtual/egl virtual/libgles2 virtual/libgbm"

RDEPENDS:packagegroup-graphics-renesas-wayland = " \
    libgbm \
"

RDEPENDS:packagegroup-graphics-oss-wayland = " \
    wayland \
    weston \
    weston-examples \
    alsa-utils \
    alsa-tools \
    libdrm-tests \
"

RDEPENDS:packagegroup-graphics-oss-opencl = " \
    clinfo \
"
