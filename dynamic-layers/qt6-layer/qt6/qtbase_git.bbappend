PACKAGECONFIG_GL = "gles2 eglfs"

PACKAGECONFIG += " \
    cups \
    fontconfig \
    glib \
    harfbuzz \
    icu \
    libinput \
    sql-sqlite \
    tslib \
    xkbcommon \
    gbm \
    kms \
    examples \
    "

QT_QPA_DEFAULT_PLATFORM ?= "wayland"
QT_QPA_EGLFS_INTEGRATION ?= ""
