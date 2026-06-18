SUMMARY = "Apply Yocto/Debian APT compatibility bridge on first boot"
DESCRIPTION = "Installs compatibility scripts and a systemd oneshot service to generate and apply the Yocto/Debian APT bridge automatically on first boot."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = " \
    file://apply-compat.sh \
    file://gen-bridge.sh \
    file://yocto-apt-compat.service \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/apply-compat.sh ${D}${sbindir}/apply-compat.sh
    install -m 0755 ${UNPACKDIR}/gen-bridge.sh ${D}${sbindir}/gen-bridge.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/yocto-apt-compat.service \
        ${D}${systemd_system_unitdir}/yocto-apt-compat.service
}

SYSTEMD_SERVICE:${PN} = "yocto-apt-compat.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} += " \
    dpkg \
    apt \
"

FILES:${PN} += " \
    ${sbindir}/apply-compat.sh \
    ${sbindir}/gen-bridge.sh \
    ${systemd_system_unitdir}/yocto-apt-compat.service \
"
