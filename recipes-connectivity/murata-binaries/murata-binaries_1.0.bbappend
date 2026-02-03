inherit systemd
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_SERVICE:${PN} = "mlanconf.service disable-virtual-interface.service"

FILES:${PN}:append = " \
        ${systemd_unitdir}/system/mlanconf.service \
        ${systemd_unitdir}/system/disable-virtual-interface.service \
        ${sbindir}/disable-virtual-interface.sh \
"

SRC_URI:append = " \
    file://add_wlan.patch;patchdir=${UNPACKDIR}/nxp-linux-calibration \
    file://switch_regions.sh \
    file://mlanconf.service \
    file://disable-virtual-interface.service \
    file://disable-virtual-interface.sh \
"

do_install:append () {
    install -d ${D}${sbindir}
    install -d ${D}${systemd_system_unitdir}
    
    # remove switch_modules script as we do not support this feature
    rm -f ${D}/usr/sbin/switch_module.sh
    rm -f ${D}/usr/sbin/switch_regions.sh
    install -m 755 ${UNPACKDIR}/switch_regions.sh ${D}/usr/sbin/switch_regions.sh
    
    # set murata wifi_mod_para.conf as default
    install -m 644 ${UNPACKDIR}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}${nonarch_base_libdir}/firmware/nxp/wifi_mod_para.conf
    
    # Install systemd services
    install -m 0644 ${UNPACKDIR}/mlanconf.service ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/disable-virtual-interface.service ${D}${systemd_system_unitdir}
    
    # Install disable virtual interface script in sbin (system admin location)
    install -m 0755 ${UNPACKDIR}/disable-virtual-interface.sh ${D}${sbindir}/
}
