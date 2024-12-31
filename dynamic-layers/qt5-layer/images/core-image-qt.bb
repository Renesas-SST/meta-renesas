require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
require include/core-image-renesas-sbc.inc
require include/core-image-renesas-qt.inc

SUMMARY = "Renesas core image with Qt5 platform support base on core-image-weston"

IMAGE_INSTALL:append = " packagegroup-qt5 packagegroup-qt5-examples "
IMAGE_INSTALL:append = " \
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
                       qtdemo-extrafiles \
"

QT_DEV_TOOLS = " \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-tools \
"

QT_TOOLS = " \
    qtbase \
    qtbase-plugins \
"

FONTS = " \
    fontconfig \
    fontconfig-utils \
    ttf-bitstream-vera \
	ttf-dejavu-sans \
	ttf-dejavu-sans-mono \
	ttf-dejavu-sans-condensed \
	ttf-dejavu-serif \
	ttf-dejavu-serif-condensed \
	ttf-dejavu-common \
	ttf-ipag \
	ttf-ipagp \
	ttf-ipam \
	ttf-ipamp \
	ttf-takao-gothic \
	ttf-takao-mincho \
	ttf-takao-pgothic \
	ttf-takao-pmincho \
    liberation-fonts \
"

TSLIB = " \
    tslib \
    tslib-calibrate \
    tslib-conf \
"

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_TOOLS} \
    ${TSLIB} \
"

export SOURCE_DIR="${THISDIR}/environment-setup"

### For add demo icon to weston toolbar
weston_icon() {
    cat ${SOURCE_DIR}/weston-demo.ini >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
}

ROOTFS_POSTPROCESS_COMMAND += 'weston_icon;'

