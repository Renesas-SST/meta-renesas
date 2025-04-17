# This script removes specific systemd service symlinks to restore default behavior.
# It un-masks services for networking, wpa_supplicant, Bluetooth, and dbus-related components.

set -e 

# Function to remove symlinks for systemd udev services
unmask_udev_services() {
    echo "Removing systemd udev service symlinks..."
    systemctl unmask systemd-udevd
    systemctl unmask systemd-udev-trigger.service
    systemctl unmask systemd-udevd.service

    systemctl enable systemd-udevd
    systemctl enable systemd-udev-trigger.service
    systemctl enable systemd-udevd.service

    systemctl restart systemd-udevd
    systemctl restart systemd-udev-trigger.service
    systemctl restart systemd-udevd.service
}

# Function to unmask connman service
unmask_connman_service() {
    echo "Unmasking connman service..."

    systemctl unmask connman.service
    systemctl enable connman.service
    systemctl restart connman.service
}

# Function to unmask systemd network-related services
unmask_network_services() {
    echo "Unmasking systemd network-related services..."

    systemctl unmask network.target
    systemctl unmask systemd-network-generator.service
    systemctl unmask systemd-networkd-wait-online.service
    systemctl unmask systemd-networkd.service

    systemctl enable network.target
    systemctl enable systemd-network-generator.service
    systemctl enable systemd-networkd-wait-online.service

    systemctl restart systemd-networkd.service
}

# Function to unmask wpa_supplicant services
unmask_wpa_supplicant_services() {
    echo "Unmasking wpa_supplicant services..."
    systemctl unmask wpa_supplicant-nl80211@.service
    systemctl unmask wpa_supplicant-wired@.service
    systemctl unmask wpa_supplicant.service
    systemctl unmask wpa_supplicant@.service

    systemctl enable wpa_supplicant.service
    systemctl restart wpa_supplicant.service
}

# Function to unmask Bluetooth services
unmask_bluetooth_services() {
    echo "Unmasking Bluetooth services..."
    systemctl unmask bluetooth.service
    systemctl unmask bluetooth.target

    systemctl enable bluetooth.service
    systemctl enable bluetooth.target

    systemctl restart bluetooth.service
    systemctl restart bluetooth.target
}

# Function to unmask dbus-related services
unmask_dbus_services() {
    echo "Unmasking dbus-related services..."

    systemctl unmask dbus-org.freedesktop.hostname1.service
    systemctl unmask dbus-org.freedesktop.locale1.service
    systemctl unmask dbus-org.freedesktop.timedate1.service
}

unmask_sshd_service() {
    restore_systemd_generators

    echo "Unmask SSHD service..."

    systemctl unmask sshd.service
    systemctl enable sshd.service
    systemctl restart sshd.service
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

# Function to clear all the blacklist modules
clear_blacklist() {
    # Clear the contents of the blacklist.conf
    echo "" > ${IMAGE_ROOTFS}/etc/modprobe.d/blacklist.conf

    # Load bluetooth and wifi kernel modules
    modprobe brcmfmac
    modprobe btusb
    modprobe bluetooth
}

# Function to un-blacklist the Bluetooth module
unblacklist_bluetooth_module() {
    echo "Removing Bluetooth module from backlist..."
    sed -i '/^\s*blacklist\s\+btusb\s*$/d' /etc/modprobe.d/blacklist.conf
    sed -i '/^\s*blacklist\s\+bluetooth\s*$/d' /etc/modprobe.d/blacklist.conf

    modprobe btusb
    modprobe bluetooth
}

# Function to un-blacklist the Wi-Fi module
unblacklist_wifi_module() {
    echo "Removing WI-FI module from blacklist.conf..."
    sed -i '/^\s*blacklist\s\+brcmfmac\s*$/d' /etc/modprobe.d/blacklist.conf

    echo "Loading wifi kernel modules.."
    modprobe brcmfmac
}

# Function to print usage
print_usage() {
    echo "Usage: $0 [service]"
    echo "Options:"
    echo "  wifi       Enable Wi-Fi related services."
    echo "  bluetooth  Enable Bluetooth services."
    echo "  sshd       Enable SSH/SCP services."
    echo "  all        Enable all network-related services (wifi/bluetooth/sshd)"
    echo "  help       Display this help message."
}

if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

case $1 in
    wifi)
        unmask_dbus_services
        unmask_udev_services
        unmask_connman_service
        unmask_network_services
        unmask_wpa_supplicant_services
        unblacklist_wifi_module
        ;;
    bluetooth)
        unmask_dbus_services
        unmask_udev_services
        unmask_bluetooth_services
        unblacklist_bluetooth_module
        ;;
    sshd)
        unmask_sshd_service
        ;;
    all)
        unmask_dbus_services
        unmask_udev_services
        unmask_connman_service
        unmask_network_services
        unmask_wpa_supplicant_services
        unmask_bluetooth_services
        unmask_sshd_service
        clear_blacklist
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

systemctl daemon-reload

echo "All specified services have been successfully unmasked."

