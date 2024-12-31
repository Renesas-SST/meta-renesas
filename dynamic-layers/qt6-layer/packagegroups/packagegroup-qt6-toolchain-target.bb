# Copyright (C) 2014 O.S. Systems Software LTDA.

DESCRIPTION = "Target packages for Qt5 SDK"
LICENSE = "MIT"

PACKAGE_ARCH = "${TUNE_PKGARCH}"
inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

# Requires Wayland to work
USE_WAYLAND = " \
    qtwayland-dev \
    qtwayland-mkspecs \
    qtwayland-plugins \
"

RDEPENDS:${PN} += " \
    qtbase-tools \
    qtdeclarative-tools \
    packagegroup-core-standalone-sdk-target \
    qtbase-dev \
    qtbase-plugins \
    qtbase-staticdev \
    qtbase-tools \
    "
