# Install loadable modules that are off-loaded from the system boot
IMAGE_INSTALL_append = " ${@oe.utils.conditional("OPTIMIZE_KERN", "1", " \
       kernel-module-ov5640 \
       kernel-module-rzsbc-ft5406 \
       kernel-module-panel-toshiba-tc358762 \
       kernel-module-rzsbc-mcu \
       kernel-module-hid-multitouch \
       kernel-module-panel-ilitek-ili9881c \
       kernel-module-uinput \
       kernel-module-evdev \
       kernel-module-uvcvideo \
       kernel-module-usbtouchscreen \
       kernel-module-mousedev \
       kernel-module-u-ether \
       kernel-module-u-serial \
       kernel-module-rcar-canfd \
       ", "", d)}"

# Modify service  quick boot
sed_service_sytemd_quickboot() {
    target_file="${IMAGE_ROOTFS}/lib/systemd/system/basic.target"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/getty-pre.target"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/getty.target"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/getty@.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/graphical.target"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/multi-user.target"
    if [ -f "$target_file" ]; then
         sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/sysinit.target"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/systemd-udev-settle.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/systemd-user-sessions.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/lib/systemd/system/user@.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi

    target_file="${IMAGE_ROOTFS}/etc/systemd/system/serial-getty@.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi
}

# Optimize service quick boot wayland
optimize_service_sytemd_wayland() {
    target_foder="${IMAGE_ROOTFS}/etc/systemd/"
    if [ -d "$target_foder" ]; then
        find $target_foder -mindepth 1 \
            -not -path "*system/*" \
            -not -path "*system" \
            -exec rm -rf {} +
    fi

    target_folder="${IMAGE_ROOTFS}/etc/systemd/system/"
    if [ -d "$target_folder" ]; then
        rm -rf $target_folder/"dbus-org.freedesktop.resolve1.service"
        rm -rf $target_folder/"sysinit.target.wants"
        rm -rf $target_folder/"dbus-1.service"
        rm -rf $target_folder/"dbus-org.freedesktop.timesync1.service"
        rm -rf $target_folder/"dbus-org.freedesktop.network1.service"
        rm -rf $target_folder/"banner.service"
        rm -rf $target_folder/"ctrl-alt-del.target"
        rm -rf $target_folder/"mountall.service"
        rm -rf $target_folder/"populate-volatile.service"
        rm -rf $target_folder/"hostname.service"
        rm -rf $target_folder/"mountnfs.service"
        rm -rf $target_folder/"read-only-rootfs-hook.service"
        rm -rf $target_folder/"syslog.service"
        rm -rf $target_folder/"bootmisc.service"
        rm -rf $target_folder/"dbus-org.bluez.service"
        rm -rf $target_folder/"hwclock.service"
        rm -rf $target_folder/"rmnologin.service"
        rm -rf $target_folder/"systemd-random-seed.service.wants"
        rm -rf $target_folder/"checkfs.service"
        rm -rf $target_folder/"dbus-org.freedesktop.Avahi.service"
        rm -rf $target_folder/"devpts.service"
        rm -rf $target_folder/"local-fs.target.wants"
        rm -rf $target_folder/"timers.target.wants"
        rm -rf $target_folder/"checkroot.service"
        rm -rf $target_folder/"dmesg.service"
        rm -rf $target_folder/"modutils.service"
        rm -rf $target_folder/"sysfs.service"
        rm -rf $target_folder/"urandom.service"
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/"
    if [ -d "$target_foder" ]; then
        find $target_foder -mindepth 1 \
            -not -path "*systemd-sysv-install" \
            -not -name "libsystemd-shared-244.so" \
            -not -name "systemd" \
            -not -name "systemd-udevd" \
            -not -path "*system/*" \
            -not -path "*system" \
            -not -path "*network*" \
            -not -path "*system-generators*" \
            -exec rm -rf {} +
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/system/"
    if [ -d "$target_foder" ]; then
        find $target_foder -mindepth 1 \
           -not -name "basic.target" \
           -not -name "default.target" \
           -not -name "getty-pre.target" \
           -not -name "getty.target" \
           -not -name "getty@.service" \
           -not -name "graphical.target" \
           -not -name "multi-user.target" \
           -not -name "serial-getty@.service" \
           -not -name "sysinit.target" \
           -not -name "systemd-udev-trigger.service" \
           -not -name "systemd-udevd.service" \
           -not -name "weston@.service" \
           -not -path "*sysinit.target.wants/*" \
           -not -path "*sysinit.target.wants" \
           -not -path "*multi-user.target.wants/*" \
           -not -path "*multi-user.target.wants" \
           -not -name "connman.service" \
           -not -name "*network*.service" \
           -not -name "network.target" \
           -not -name "wpa_supplicant*" \
           -not -name "dbus*" \
           -not -name "bluetooth*" \
           -exec rm -rf {} +
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/system/sysinit.target.wants/"
    if [ -d "$target_foder" ]; then
       find $target_foder -mindepth 1 \
       -not -name "systemd-udev-trigger.service" \
       -not -name "systemd-journald.service" \
       -exec rm -rf {} +
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/system/multi-user.target.wants/"
    if [ -d "$target_foder" ]; then
       find $target_foder -mindepth 1 \
       -not -name "getty.target" \
       -exec rm -rf {} +
    fi
}

# Optimize service quick boot cli
optimize_service_sytemd_cli() {
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/default.target
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/weston@.service
}

# Creates symlinks to /dev/null for systemd udev-related services
mask_systemd_udev() {
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system/

    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udev-trigger.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udev-trigger.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd.service
}

# Creates symlinks to /dev/null for networking-related services
mask_systemd_networking() {
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system 
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system/dbus.target.wants/

    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/connman.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/network.target
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-network-generator.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-networkd-wait-online.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/systemd-networkd.service

    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant-nl80211@.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant-wired@.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant@.service

    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/bluetooth.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/bluetooth.target

    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.hostname1.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.locale1.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.login1.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.timedate1.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus.socket
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus.target.wants/dbus.socket

    # Create symlink
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/connman.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/network.target
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-network-generator.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-networkd-wait-online.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-networkd.service

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant-nl80211@.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant-wired@.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/wpa_supplicant@.service

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/bluetooth.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/bluetooth.target

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.hostname1.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.locale1.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.login1.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus-org.freedesktop.timedate1.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus.socket
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus.target.wants/dbus.socket
}

blacklist_modules() {
    mkdir -p ${IMAGE_ROOTFS}/etc/modprobe.d/

    if [ ! -f ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf ]; then
        touch ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
    fi

    # Append blacklist entries
    echo "blacklist btusb" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
    echo "blacklist bluetooth" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
    echo "blacklist brcmfmac" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf

    # Create a backup for blacklist modules
    cp ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf.bk
}

mask_unused_services() {
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/avahi-daemon.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/dbus-1.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/hwclock.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/mountnfs.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/ntpd.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/ofono.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/rmnologin.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/rng-tools.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/rpcbind.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/syslog.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/tcf-agent.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/sshd.service
    rm -f ${IMAGE_ROOTFS}/etc/systemd/system/getty@tty1.service

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/avahi-daemon.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/dbus-1.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/hwclock.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/mountnfs.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/ntpd.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/ofono.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/rmnologin.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/rng-tools.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/rpcbind.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/syslog.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/tcf-agent.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/sshd.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/getty@tty1.service
}

off_load_systemd_generators() {
    mv ${IMAGE_ROOTFS}/lib/systemd/system-generators ${IMAGE_ROOTFS}/lib/systemd/system-generators-off-load
}
