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

    target_foder="${IMAGE_ROOTFS}/etc/systemd/system/"
    if [ -d "$target_foder" ]; then
        find $target_foder -mindepth 1 \
            -not -name "default.target" \
            -not -path "*getty.target.wants/*" \
            -not -path "*getty.target.wants" \
            -exec rm -rf {} +
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/"
    if [ -d "$target_foder" ]; then
        find $target_foder -mindepth 1 \
            -not -name "libsystemd-shared-244.so" \
            -not -name "systemd" \
            -not -name "systemd-udevd" \
            -not -path "*system/*" \
            -not -path "*system" \
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
           -exec rm -rf {} +
    fi

    target_foder="${IMAGE_ROOTFS}/lib/systemd/system/sysinit.target.wants/"
    if [ -d "$target_foder" ]; then
       find $target_foder -mindepth 1 \
       -not -name "systemd-udev-trigger.service" \
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
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/sysinit.target.wants
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/systemd-udevd.service
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/systemd-udev-trigger.service
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/system/weston@.service
    rm -rf ${IMAGE_ROOTFS}/lib/systemd/systemd-udevd
}
