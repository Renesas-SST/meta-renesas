PACKAGECONFIG:append = " ${@oe.utils.conditional('RZ_FEATURE_PANFROST', '1', 'egl kmsro panfrost', '', d)}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    ${@oe.utils.conditional('RZ_FEATURE_PANFROST', '1', 'file://mesa_add_rzg2l_du_entrypoint.patch', '', d)} \
"
