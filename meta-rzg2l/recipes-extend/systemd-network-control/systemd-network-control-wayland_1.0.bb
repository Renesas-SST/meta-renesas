SUMMARY = "Recipe to install a script that controls the network stack using systemd for quickboot wayland target"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://quickboot-wayland/disable_networking_stack.sh \
    file://quickboot-wayland/enable_networking_stack.sh \
"

do_install() {
    install -d ${D}/home/root/network-management

    install -m 0755 ${WORKDIR}/quickboot-wayland/disable_networking_stack.sh ${D}/home/root/network-management
    install -m 0755 ${WORKDIR}/quickboot-wayland/enable_networking_stack.sh ${D}/home/root/network-management
}

FILES_${PN} += " \
    /home/root/network-management/disable_networking_stack.sh \
    /home/root/network-management/enable_networking_stack.sh \
"
