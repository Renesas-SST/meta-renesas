# TODO add license
DESCRIPTION = "All Demos Packages for Qt5"

LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
	packagegroup-qt5 \
	packagegroup-qt5-examples \
"

ALLOW_EMPTY:${PN} = "1"

# Requires Wayland to work
QT5_WAYLAND_PACKAGES = " \
	qtwayland \
	qtwayland-plugins \
	qtwayland-tools \
"

#
#
RDEPENDS:${PN} = " \
	${@bb.utils.contains("DISTRO_FEATURES", "wayland", "${QT5_WAYLAND_PACKAGES}", "", d)} \
	qtbase \
	qtbase-plugins \
	qtbase-tools \
	qtquickcontrols2 \
	qtquickcontrols \
	qtdeclarative \
	qtdeclarative-tools \
	qtdeclarative-qmlplugins \
	qtmultimedia \
	qtmultimedia-plugins \
	qtmultimedia-qmlplugins \
	qtsvg \
	qtsvg-plugins \
	qtsensors \
	qtimageformats \
	qtimageformats-plugins \
	qtsystems \
	qtsystems-tools \
	qtsystems-qmlplugins \
	qt3d \
	qt3d-qmlplugins \
	qtgraphicaleffects-qmlplugins \
	qtconnectivity-qmlplugins \
	qtlocation-plugins \
	qtlocation-qmlplugins \
	cinematicexperience \
	qtserialbus \
	qttools \
	qttools-tools \
	qtscript \
	qtserialport \
	qt5-qml-presentation-system \
"

RDEPENDS:${PN}-examples += " \
	${PN} \
"
