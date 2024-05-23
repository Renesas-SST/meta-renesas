inherit systemd
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "mlanconf.service"

FILES:${PN} += "${systemd_unitdir}/system/mlanconf.service"

SRC_URI:append = " \
    file://add_wlan.patch;patchdir=${UNPACKDIR}/nxp-linux-calibration \
    file://switch_regions.sh \
    file://mlanconf.service \
"

do_install:append () {
    # remove switch_modules script as we do not support this feature
    rm -f ${D}/usr/sbin/switch_module.sh
    rm -f ${D}/usr/sbin/switch_regions.sh
    install -m 755 ${UNPACKDIR}/switch_regions.sh ${D}/usr/sbin/switch_regions.sh

    # set murata wifi_mod_para.conf as default
    install -m 644 ${UNPACKDIR}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}${nonarch_base_libdir}/firmware/nxp/wifi_mod_para.conf

    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${UNPACKDIR}/mlanconf.service ${D}/${systemd_unitdir}/system
}
