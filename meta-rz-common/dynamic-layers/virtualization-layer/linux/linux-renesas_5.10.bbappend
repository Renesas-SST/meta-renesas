FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'docker', 'file://docker.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO', 'ubuntu-tiny', 'file://docker.cfg', '', d)} \
"
