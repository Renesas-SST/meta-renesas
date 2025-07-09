# core-image-renesas-quickboot.inc
#
# This include file defines the general quick boot configuration for Renesas
# platforms. It provides a customizable setup optimized for fast booting
# across various Renesas hardware.
#

# Install loadable modules that are off-loaded from the system boot
IMAGE_INSTALL:append = " ${@oe.utils.conditional("OPTIMIZE_KERN", "1", " \
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

sed_service_systemd_quickboot() {
    echo "sed service"
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

    target_file="${IMAGE_ROOTFS}/etc/systemd/system/serial-getty@.service"
    if [ -f "$target_file" ]; then
        sed -i '/^[^#]/ s/^/#/' $target_file
    fi
}

# Optimize service quick boot wayland
optimize_service_systemd_wayland() {
    target_folder="${IMAGE_ROOTFS}/etc/systemd/"
    if [ -d "$target_folder" ]; then
        find $target_folder -mindepth 1 \
            -not -path "*system/*" \
            -not -path "*system" \
            -exec rm -rf {} +
    fi

    target_folder="${IMAGE_ROOTFS}/etc/systemd/system/"
    if [ -d "$target_folder" ]; then
        rm -rf $target_folder/"sysinit.target.wants"
        rm -rf $target_folder/"dbus-org.freedesktop.resolve1.service"
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

    target_folder="${IMAGE_ROOTFS}/lib/systemd/system/"
    if [ -d "$target_folder" ]; then
        rm -rf $target_folder/acpid.service
        rm -rf $target_folder/alsa-restore.service
        rm -rf $target_folder/alsa-state.service
        rm -rf $target_folder/autovt@.service
        rm -rf $target_folder/avahi-daemon.service
        rm -rf $target_folder/avahi-daemon.socket
        rm -rf $target_folder/blockdev@.target
        rm -rf $target_folder/boot-complete.target
        rm -rf $target_folder/busybox-klogd.service
        rm -rf $target_folder/busybox-syslog.service
        rm -rf $target_folder/capsule.slice
        rm -rf $target_folder/capsule@.service
        rm -rf $target_folder/console-kit-daemon.service
        rm -rf $target_folder/console-kit-log-system-restart.service
        rm -rf $target_folder/console-kit-log-system-start.service
        rm -rf $target_folder/console-kit-log-system-stop.service
        rm -rf $target_folder/container-getty@.service
        rm -rf $target_folder/ctrl-alt-del.target
        rm -rf $target_folder/debug-shell.service
        rm -rf $target_folder/dnf-automatic-download.service
        rm -rf $target_folder/dnf-automatic-download.timer
        rm -rf $target_folder/dnf-automatic-install.service
        rm -rf $target_folder/dnf-automatic-install.timer
        rm -rf $target_folder/dnf-automatic-notifyonly.service
        rm -rf $target_folder/dnf-automatic-notifyonly.timer
        rm -rf $target_folder/dnf-automatic.service
        rm -rf $target_folder/dnf-automatic.timer
        rm -rf $target_folder/dnf-makecache.service
        rm -rf $target_folder/dnf-makecache.timer
        rm -rf $target_folder/emergency.service
        rm -rf $target_folder/emergency.target
        rm -rf $target_folder/exit.target
        rm -rf $target_folder/factory-reset.target
        rm -rf $target_folder/final.target
        rm -rf $target_folder/first-boot-complete.target
        rm -rf $target_folder/halt.target
        rm -rf $target_folder/halt.target.wants
        rm -rf $target_folder/hibernate.target
        rm -rf $target_folder/hybrid-sleep.target
        rm -rf $target_folder/initrd-cleanup.service
        rm -rf $target_folder/initrd-fs.target
        rm -rf $target_folder/initrd-parse-etc.service
        rm -rf $target_folder/initrd-root-device.target
        rm -rf $target_folder/initrd-root-fs.target
        rm -rf $target_folder/initrd-switch-root.service
        rm -rf $target_folder/initrd-switch-root.target
        rm -rf $target_folder/initrd-udevadm-cleanup-db.service
        rm -rf $target_folder/initrd-usr-fs.target
        rm -rf $target_folder/initrd.target
        rm -rf $target_folder/initrd.target.wants
        rm -rf $target_folder/ip6tables.service
        rm -rf $target_folder/iptables.service
        rm -rf $target_folder/kexec.target
        rm -rf $target_folder/kexec.target.wants
        rm -rf $target_folder/kmod-static-nodes.service
        rm -rf $target_folder/ldconfig.service
        rm -rf $target_folder/local-fs-pre.target
        rm -rf $target_folder/local-fs.target
        rm -rf $target_folder/local-fs.target.wants
        rm -rf $target_folder/lttng-sessiond.service
        rm -rf $target_folder/modprobe@.service
        rm -rf $target_folder/neard.service
        rm -rf $target_folder/nfs-mountd.service
        rm -rf $target_folder/nfs-server.service
        rm -rf $target_folder/nfs-statd.service
        rm -rf $target_folder/nss-lookup.target
        rm -rf $target_folder/nss-user-lookup.target
        rm -rf $target_folder/ofono.service
        rm -rf $target_folder/pam_namespace.service
        rm -rf $target_folder/paths.target
        rm -rf $target_folder/poweroff.target
        rm -rf $target_folder/poweroff.target.wants
        rm -rf $target_folder/printer.target
        rm -rf $target_folder/proc-fs-nfsd.mount
        rm -rf $target_folder/psplash-start.service
        rm -rf $target_folder/psplash-systemd.service
        rm -rf $target_folder/quotaon-root.service
        rm -rf $target_folder/quotaon@.service
        rm -rf $target_folder/rc-local.service
        rm -rf $target_folder/reboot.target
        rm -rf $target_folder/reboot.target.wants
        rm -rf $target_folder/remote-fs-pre.target
        rm -rf $target_folder/remote-fs.target
        rm -rf $target_folder/rescue.service
        rm -rf $target_folder/rescue.target
        rm -rf $target_folder/rescue.target.wants
        rm -rf $target_folder/rpcbind.service
        rm -rf $target_folder/rpcbind.service.d
        rm -rf $target_folder/rpcbind.socket
        rm -rf $target_folder/rpcbind.target
        rm -rf $target_folder/runlevel0.target
        rm -rf $target_folder/runlevel1.target
        rm -rf $target_folder/runlevel1.target.wants
        rm -rf $target_folder/runlevel2.target
        rm -rf $target_folder/runlevel2.target.wants
        rm -rf $target_folder/runlevel3.target
        rm -rf $target_folder/runlevel3.target.wants
        rm -rf $target_folder/runlevel4.target
        rm -rf $target_folder/runlevel4.target.wants
        rm -rf $target_folder/runlevel5.target
        rm -rf $target_folder/runlevel5.target.wants
        rm -rf $target_folder/runlevel6.target
        rm -rf $target_folder/slices.target
        rm -rf $target_folder/smartcard.target
        rm -rf $target_folder/sockets.target
        rm -rf $target_folder/sockets.target.wants
        rm -rf $target_folder/sound.target
        rm -rf $target_folder/sound.target.wants
        rm -rf $target_folder/suspend-then-hibernate.target
        rm -rf $target_folder/suspend.target
        rm -rf $target_folder/swap.target
        rm -rf $target_folder/sys-fs-fuse-connections.mount
        rm -rf $target_folder/sys-kernel-config.mount
        rm -rf $target_folder/sys-kernel-debug.mount
        rm -rf $target_folder/sys-kernel-tracing.mount
        rm -rf $target_folder/sys-power.target
        rm -rf $target_folder/system-update-cleanup.service
        rm -rf $target_folder/system-update-pre.target
        rm -rf $target_folder/system-update.target
        rm -rf $target_folder/tcf-agent.service
        rm -rf $target_folder/time-set.target
        rm -rf $target_folder/time-sync.target
        rm -rf $target_folder/timers.target
        rm -rf $target_folder/timers.target.wants
        rm -rf $target_folder/tmp.mount
        rm -rf $target_folder/tpm2.target
        rm -rf $target_folder/umount.target
        rm -rf $target_folder/usb-gadget.target
        rm -rf $target_folder/dev-hugepages.mount
        rm -rf $target_folder/dev-mqueue.mount
        rm -rf $target_folder/shutdown.target
        rm -rf $target_folder/sigpwr.target
        rm -rf $target_folder/sleep.target
        rm -rf $target_folder/soft-reboot.target
        rm -rf $target_folder/storage-target-mode.target
        rm -rf $target_folder/syslog.socket
        rm -rf $target_folder/systemd-backlight@.service
        rm -rf $target_folder/systemd-battery-check.service
        rm -rf $target_folder/systemd-boot-check-no-failures.service
        rm -rf $target_folder/systemd-creds.socket
        rm -rf $target_folder/systemd-creds@.service
        rm -rf $target_folder/systemd-exit.service
        rm -rf $target_folder/systemd-fsck-root.service
        rm -rf $target_folder/systemd-fsck@.service
        rm -rf $target_folder/systemd-growfs-root.service
        rm -rf $target_folder/systemd-growfs@.service
        rm -rf $target_folder/systemd-halt.service
        rm -rf $target_folder/systemd-hibernate-resume.service
        rm -rf $target_folder/systemd-hibernate.service
        rm -rf $target_folder/systemd-hostnamed.service
        rm -rf $target_folder/systemd-hostnamed.socket
        rm -rf $target_folder/systemd-hwdb-update.service
        rm -rf $target_folder/systemd-hybrid-sleep.service
        rm -rf $target_folder/systemd-initctl.service
        rm -rf $target_folder/systemd-initctl.socket
        rm -rf $target_folder/systemd-journal-catalog-update.service
        rm -rf $target_folder/systemd-journal-flush.service
        rm -rf $target_folder/systemd-kexec.service
        rm -rf $target_folder/systemd-localed.service
        rm -rf $target_folder/systemd-machine-id-commit.service
        rm -rf $target_folder/systemd-mountfsd.service
        rm -rf $target_folder/systemd-mountfsd.socket
        rm -rf $target_folder/systemd-nsresourced.service
        rm -rf $target_folder/systemd-nsresourced.socket
        rm -rf $target_folder/systemd-poweroff.service
        rm -rf $target_folder/systemd-quotacheck@.service
        rm -rf $target_folder/systemd-random-seed.service
        rm -rf $target_folder/systemd-reboot.service
        rm -rf $target_folder/systemd-remount-fs.service
        rm -rf $target_folder/systemd-rfkill.service
        rm -rf $target_folder/systemd-rfkill.socket
        rm -rf $target_folder/systemd-soft-reboot.service
        rm -rf $target_folder/systemd-storagetm.service
        rm -rf $target_folder/systemd-suspend-then-hibernate.service
        rm -rf $target_folder/systemd-suspend.service
        rm -rf $target_folder/systemd-sysctl.service
        rm -rf $target_folder/systemd-sysusers.service
        rm -rf $target_folder/systemd-time-wait-sync.service
        rm -rf $target_folder/systemd-timedated.service
        rm -rf $target_folder/systemd-vconsole-setup.service
        rm -rf $target_folder/systemd-volatile-root.service
        rm -rf $target_folder/systemd-update-utmp-runlevel.service
        rm -rf $target_folder/systemd-update-utmp.service
        rm -rf $target_folder/systemd-userdbd.service
        rm -rf $target_folder/systemd-userdbd.socket
        rm -rf $target_folder/systemd-ask-password*
        rm -rf $target_folder/systemd-quotacheck-root.service
        rm -rf $target_folder/systemd-udev-load-credentials.service
        rm -rf $target_folder/var-*
    fi

    target_folder="${IMAGE_ROOTFS}/lib/systemd/system/multi-user.target.wants/"
    if [ -d "$target_folder" ]; then
       find $target_folder -mindepth 1 \
       -not -name "getty.target" \
       -not -name "systemd-user-sessions.service" \
       -not -name "dbus.service" \
       -not -name "systemd-logind.service" \
       -exec rm -rf {} +
    fi
}

# Optimize service quick boot cli
optimize_service_systemd_cli() {
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/default.target
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/weston.socket
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/weston.service
}

# Creates symlinks to /dev/null for systemd udev-related services
mask_systemd_udev() {
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system/

    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udev-settle.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udev-trigger.service
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd-control.socket
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd-kernel.socket
    ln -sf /dev/null ${IMAGE_ROOTFS}/etc/systemd/system/systemd-udevd.service
}

# Creates symlinks to /dev/null for networking-related services
mask_systemd_networking() {
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system 
    mkdir -p ${IMAGE_ROOTFS}/etc/systemd/system/dbus.target.wants/

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

