# This script creates symlinks to /dev/null for various systemd services
# to prevent them from being enabled. It includes services related to udev,
# networking, wpa_supplicant, Bluetooth, and dbus.

set -e

# Function to disable and mask systemd udev services
mask_systemd_udev() {
    echo "Disabling and masking systemd udev services..."

    systemctl stop systemd-udevd
    systemctl stop systemd-udev-trigger.service
    systemctl stop systemd-udevd.service

    systemctl disable systemd-udevd
    systemctl disable systemd-udev-trigger.service
    systemctl disable systemd-udevd.service

    systemctl mask systemd-udevd
    systemctl mask systemd-udev-trigger.service
    systemctl mask systemd-udevd.service
}

# Function to disable and mask systemd connman and wpa supplicant
mask_systemd_wifi_related() {
    echo "Disabling and masking systemd connman and wpa supplicant services..."

    # Disable and mask connman service
    systemctl stop connman.service
    systemctl disable connman.service
    systemctl mask connman.service

    # Mask wpa_supplicant services
    systemctl stop wpa_supplicant.service

    systemctl disable wpa_supplicant-wired@.service
    systemctl disable wpa_supplicant.service
    systemctl disable wpa_supplicant@.service

    systemctl mask wpa_supplicant-nl80211@.service
    systemctl mask wpa_supplicant-wired@.service
    systemctl mask wpa_supplicant.service
    systemctl mask wpa_supplicant@.service
}

# Function to disable and mask systemd network-related services
mask_systemd_network_service() {
    # Disable and Mask systemd network-related services
    echo "Masking network-related services..."

    systemctl stop network.target
    systemctl stop systemd-network-generator.service
    systemctl stop systemd-networkd-wait-online.service
    systemctl stop systemd-networkd.service

    systemctl disable network.target
    systemctl disable systemd-network-generator.service
    systemctl disable systemd-networkd-wait-online.service
    systemctl disable systemd-networkd.service

    systemctl mask network.target
    systemctl mask systemd-network-generator.service
    systemctl mask systemd-networkd-wait-online.service
    systemctl mask systemd-networkd.service
}

# Function to disable and mask bluetooth services
mask_systemd_bluetooth() {
    # Disable and mask Bluetooth services
    echo "Disabling and masking systemd bluetooth services..."

    systemctl stop bluetooth.service
    systemctl stop bluetooth.target

    systemctl disable bluetooth.service
    systemctl disable bluetooth.target

    systemctl mask bluetooth.service
    systemctl mask bluetooth.target
}

# Function to disable and mask dbus services
mask_systemd_dbus() {
    echo "Disabling and masking systemd dbus services..."

    systemctl mask dbus-org.freedesktop.hostname1.service
    systemctl mask dbus-org.freedesktop.locale1.service
    systemctl mask dbus-org.freedesktop.timedate1.service
}

mask_sshd_service() {
    echo "Masking systemd sshd services..."

    off_load_systemd_generators

    systemctl stop sshd.service
    systemctl disable sshd.service
    systemctl mask sshd.service
}

restore_systemd_generators() {
    if [ -d "/lib/systemd/system-generators-off-load" ]; then
        mv ${IMAGE_ROOTFS}/lib/systemd/system-generators-off-load ${IMAGE_ROOTFS}/lib/systemd/system-generators
    fi
}

off_load_systemd_generators() {
    if [ -d "/lib/systemd/system-generators" ]; then
        mv ${IMAGE_ROOTFS}/lib/systemd/system-generators ${IMAGE_ROOTFS}/lib/systemd/system-generators-off-load
    fi
}

# Blacklist modules
blacklist_modules() {
    if [ -f /etc/modprobe.d/blacklist.conf.bk ]; then
        cp /etc/modprobe.d/blacklist.conf.bk /etc/modprobe.d/blacklist.conf
        echo "Restored blacklist.conf from backup."
    else
        echo "Backup file not found. Cannot restore blacklist.conf."
    fi
}

# Function to blacklist the Bluetooth module
blacklist_bluetooth_module() {
    echo "Blacklisting Bluetooth module..."
    echo "blacklist btusb" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
    echo "blacklist bluetooth" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
}

# Function to blacklist the Wi-Fi module
blacklist_wifi_module() {
    echo "Blacklisting WI-FI module..."
    echo "blacklist brcmfmac" >> ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf
}

# Function to print usage
print_usage() {
    echo "Usage: $0 [service]"
    echo "Options:"
    echo "  wifi       Disable Wi-Fi related services."
    echo "  bluetooth  Disable Bluetooth services."
    echo "  sshd       Disable SSH/SCP services."
    echo "  all        Disable all network-related services (wifi/bluetooth/sshd)"
    echo "  help       Display this help message."
}

if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

# udev and dbus are needed for wifi and bluetooth to be working correctly.
case $1 in
    wifi)
        mask_systemd_wifi_related
        mask_systemd_network_service
        blacklist_wifi_module
        ;;
    bluetooth)
        mask_systemd_bluetooth
        blacklist_bluetooth_module
        ;;
    sshd)
        mask_sshd_service
        ;;
    all)
        mask_systemd_udev
        mask_systemd_wifi_related
        mask_systemd_network_service
        mask_systemd_dbus
        mask_systemd_bluetooth
        mask_sshd_service
        blacklist_modules
        ;;
    help)
        print_usage
        ;;
    *)
        echo "Error: Invalid argument '$1'."
        print_usage
        exit 1
        ;;
esac

# Check if neither Wi-Fi nor Bluetooth is active, and mask udev and dbus if so
if ! systemctl is-active --quiet connman.service && ! systemctl is-active --quiet bluetooth.service; then
    mask_systemd_dbus
    mask_systemd_udev
fi

systemctl daemon-reload

echo "All specified systemd services have been successfully masked."

