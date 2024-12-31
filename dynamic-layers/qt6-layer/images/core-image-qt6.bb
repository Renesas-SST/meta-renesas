require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-qt6.inc

LICENSE = "MIT"
SUMMARY = "Renesas core image with Qt6 platform support base on core-image-weston"

inherit populate_sdk_qt6 populate_sdk_ext

IMAGE_INSTALL += " packagegroup-qt6 packagegroup-qt6-modules"

IMAGE_INSTALL:remove = " \
                        nativesdk-gstreamer1.0-plugins-base \
                        nativesdk-gstreamer1.0-plugins-bad \
                        nativesdk-gstreamer1.0-plugins-good \
                        nativesdk-gstreamer1.0-plugins-ugly \
"

MACHINE_EXTRA_INSTALL_SDK_HOST ?= ""

TOOLCHAIN_HOST_TASK:append = " \
    nativesdk-gperf \
    nativesdk-cmake \
    nativesdk-make \
    nativesdk-ninja \
    nativesdk-perl-modules \
    ${MACHINE_EXTRA_INSTALL_SDK_HOST} \
    ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "nativesdk-wayland-dev", "", d)} \
    nativesdk-qtbase \
    nativesdk-qtbase-staticdev \
    nativesdk-qtbase-tools \
    nativesdk-qtdeclarative \
    nativesdk-qtdeclarative-staticdev \
    nativesdk-qtdeclarative-tools \
    nativesdk-qtquick3d-tools \
    nativesdk-qtremoteobjects-tools \
    nativesdk-qtscxml-tools \
    nativesdk-qttools-tools \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'nativesdk-qtwayland-tools', '', d)} \
"

TOOLCHAIN_TARGET_TASK:append = " \
    qtbase                          \
    qtbase-plugins                  \
    qtbase-dev                      \
    qtbase-staticdev                \
    qtbase-tools                    \
    qt5compat                       \
    qt5compat-plugins               \
    qt5compat-qmlplugins            \
    liberation-fonts                \
    \
    ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "qtwayland", "", d)} \
    ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "qtwayland-plugins", "", d)} \
    ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "qtwayland-qmlplugins", "", d)} \
    \
    qtdeclarative                   \
    qtdeclarative-qmlplugins        \
    qtdeclarative-tools             \
    \
    qtmultimedia                    \
    qtmultimedia-plugins            \
    qtmultimedia-qmlplugins         \
    \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qt3d', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qt3d-qmlplugins', '', d)} \
    \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtquick3d', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtquick3d-qmlplugins', '', d)} \
    \
    qtsvg                       \
    qtsvg-plugins               \
    qtsvg-qmlplugins            \
    \
    qtwebsockets                \
    qtwebsockets-plugins        \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtwebsockets-qmlplugins', '', d)} \
    \
    qtsensors                   \
    qtsensors-plugins           \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtsensors-qmlplugins', '', d)} \
    qtserialport                \
    qtserialport-plugins        \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtserialport-qmlplugins', '', d)} \
    \
    qtcharts                    \
    qtcharts-plugins            \
    qtcharts-qmlplugins         \
    \
    qtimageformats              \
    qtimageformats-plugins      \
    qtimageformats-qmlplugins   \
    \
    qtquicktimeline             \
    qtquicktimeline-plugins     \
    qtquicktimeline-qmlplugins  \
    \
    qttools-dev                 \
    qttools-tools               \
    qtvirtualkeyboard           \
    qtvirtualkeyboard-plugins   \
    qtvirtualkeyboard-qmlplugins \
    \
    qtremoteobjects             \
    qtremoteobjects-plugins     \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtremoteobjects-qmlplugins', '', d)} \
"
