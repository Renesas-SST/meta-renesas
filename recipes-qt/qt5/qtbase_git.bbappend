do_install:append:class-target() {
    sed -i -e 's|${S}||g' ${B}/tests/auto/dbus/qdbusabstractinterface/qdbusabstractinterface/pinger_interface.cpp
    sed -i -e 's|${S}||g' ${B}/tests/auto/dbus/qdbusabstractinterface/qdbusabstractinterface/pinger_interface.h
}

# switch to GLES 2 support
PACKAGECONFIG_GL = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'gles2', '', d)}"

DEP = " mtdev libxkbcommon freetype fontconfig libinput libproxy"

RDEPENDS:${PN} += "${DEP}"
RDEPENDS:${PN}-plugins += "${DEP}"
RDEPENDS:${PN}-examples += "${DEP}"

# add necessary packages
PACKAGECONFIG:append = " fontconfig sql-sqlite sql-sqlite openssl icu accessibility examples sm linuxfb gles2 glib gif"

# Select wayland as the default platform abstraction plugin for Qt
CONF_ADD_X11 = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', ' -qpa xcb -xcb -xcb-xlib -system-xcb -eglfs', '', d)}"
CONF_ADD_WAYLAND = "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' -qpa wayland -no-xcb', '', d)}"

PACKAGECONFIG_CONFARGS:append += "\
	-no-kms \
	-no-gbm \
	-no-evdev \
	-no-kms \
	-no-sse2 \
	-no-sse3 \
	${CONF_ADD_WAYLAND} \
"

# nis option is not supported anymore, disable it here
PACKAGECONFIG[nis] = ""

PACKAGECONFIG_GL:append = " eglfs gbm kms "

QT_CONFIG_FLAGS += "--no-feature-getentropy"
QT_CONFIG_FLAGS += "-no-qpa-platform-guard ${@bb.utils.contains('DISTRO_FEATURES', 'ld-is-gold', '-use-gold-linker', '-no-use-gold-linker', d)}"
PACKAGECONFIG_X11 = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xcb glib xkbcommon', 'xkbcommon', d)}"
OPENSSL_LINKING_MODE = "-linked"

DEPENDS += "gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-bad"

