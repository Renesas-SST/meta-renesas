FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://weston.sh \
    file://weston.ini \
"

do_install:append() {
    if [ "X${EXT_GFX_BACKEND}" = "X1" ]; then
        sed -e "/^After=/s/$/ dbus.service multi-user.target/" \
            -e "s/\$OPTARGS/--idle-time=0 \$OPTARGS/" \
            -i ${D}/${systemd_system_unitdir}/weston.service
    fi

    # Use own weston.ini file
    install -d ${D}/${sysconfdir}/xdg/weston
    install -m 0755 ${S}/weston.ini ${D}/${sysconfdir}/xdg/weston/weston.ini

    # Set XDG_RUNTIME_DIR to /run/user/$UID (e.g. run/user/0)
    install -d ${D}/${sysconfdir}/profile.d
    install -m 0755 ${S}/weston.sh ${D}/${sysconfdir}/profile.d/weston.sh
}

FILES_${PN}:append = " \
    ${sysconfdir}/profile.d/weston.sh \
"
