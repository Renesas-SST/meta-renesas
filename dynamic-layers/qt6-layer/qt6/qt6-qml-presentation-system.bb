SUMMARY = "Qt5 qml presentation system"
DESCRIPTION = "Quick tour of Qt 5.0, primarily focusing on its graphical capabilities."
HOMEPAGE = "https://code.qt.io/cgit/qt-labs/"
LICENSE = "LGPL-2.1-only"

# This package actually has no License file. Below is dummy info to build
LIC_FILES_CHKSUM = "file://presentation.pro;md5=fcb836475bffdd2776009a329c13b560"

DEPENDS = "qtdeclarative"

SRCREV = "860804a58bf47eaecdcc1acf81620bb998bf8cbf"
SRC_URI = "git://code.qt.io/qt-labs/qml-presentation-system.git;branch=master"

S = "${WORKDIR}/git"

do_install() {
     install -d ${D}${libdir}/qt6/qml/Qt/labs/presentation
     install -m 644 ${S}/src/* ${D}${libdir}/qt6/qml/Qt/labs/presentation/
}

FILES:${PN} += "${datadir} ${libdir}/*"

