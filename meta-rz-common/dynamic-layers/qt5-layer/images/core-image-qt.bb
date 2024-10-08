require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-qt.inc

SUMMARY = "Renesas core image with Qt5 platform support base on core-image-weston"

# Allow QT_DEMO (default): all QT5 Demos are built, included and available on Weston desktop.
QT_DEMO = "1"

IMAGE_INSTALL_append = " packagegroup-qt5 packagegroup-qt5-examples "
IMAGE_INSTALL_append = " \
                       kernel-module-uvcvideo \
                       qt5-launch-demo \
                       qt5everywheredemo \
                       cinematicexperience \
                       qtsmarthome \
                       qt5nmapper \
                       qt5nmapcarousedemo \
                       qt5ledscreen \
                       quitbattery \
                       quitindicators \
                       qtwebkit-examples-examples \
                       qtdemo-extrafiles \
"
