SUMMARY = "Client for Wi-Fi Protected Access (WPA)"
HOMEPAGE = "http://w1.fi/wpa_supplicant/"
DESCRIPTION = "wpa_supplicant is a WPA Supplicant for Linux, BSD, Mac OS X, and Windows with support for WPA and WPA2 (IEEE 802.11i / RSN). Supplicant is the IEEE 802.1X/WPA component that is used in the client stations. It implements key negotiation with a WPA Authenticator and it controls the roaming and IEEE 802.11 authentication/association of the wlan driver."

# Overwrite the SYSTEMD_SERVICE
SYSTEMD_SERVICE_${PN} = ""

# Overwrite the installation of wpa_supplicant.service when installing on rootfs systemd and dbus
# This action is considered as a work around to support eSDK build when eSDK do_sdk_depends task always
# tries to point out a duplicate error of the wpa_supplicant.service installation in summit-supplicant-lwb and wpa-supplicant recipes
# eventhough the fact is that the conflict is handled in summit-supplicant-lwb recipe.
do_install () {
    install -d ${D}${sbindir}
    install -m 755 wpa_supplicant/wpa_supplicant ${D}${sbindir}
    install -m 755 wpa_supplicant/wpa_cli        ${D}${sbindir}

    install -d ${D}${bindir}
    install -m 755 wpa_supplicant/wpa_passphrase ${D}${bindir}

    install -d ${D}${docdir}/wpa_supplicant
    install -m 644 wpa_supplicant/README ${WORKDIR}/wpa_supplicant.conf ${D}${docdir}/wpa_supplicant

    install -d ${D}${sysconfdir}
    install -m 600 ${WORKDIR}/wpa_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant.conf

    install -d ${D}${sysconfdir}/network/if-pre-up.d/
    install -d ${D}${sysconfdir}/network/if-post-down.d/
    install -d ${D}${sysconfdir}/network/if-down.d/
    install -m 755 ${WORKDIR}/wpa-supplicant.sh ${D}${sysconfdir}/network/if-pre-up.d/wpa-supplicant
    cd ${D}${sysconfdir}/network/ && \
    ln -sf ../if-pre-up.d/wpa-supplicant if-post-down.d/wpa-supplicant

    install -d ${D}/etc/default/volatiles
    install -m 0644 ${WORKDIR}/99_wpa_supplicant ${D}/etc/default/volatiles
}
