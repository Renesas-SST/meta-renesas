PACKAGECONFIG:append = " egl kmsro panfrost"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://mesa_add_rzg2l_du_entrypoint.patch \
"
