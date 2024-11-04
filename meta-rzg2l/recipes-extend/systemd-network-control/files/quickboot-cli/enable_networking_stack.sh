# This script removes specific systemd service symlinks to restore default behavior.
# It un-masks services for networking, wpa_supplicant, Bluetooth, and dbus-related components.

set -e 

# Config file for track states of network
CONFIG_FILE="$HOME/.network_status_track"

# Function to load the states from the config file
load_states() {
    if [ -f "$CONFIG_FILE" ]; then
        # Read the values from the config file
        source "$CONFIG_FILE"
    else
        # Initialize to false if config file does not exist
        WIFI_ACTIVE=false
        BLUETOOTH_ACTIVE=false
        SSHD_ACTIVE=false
    fi
}

# Function to save the states to the config file
save_states() {
    {
        echo "WIFI_ACTIVE=$WIFI_ACTIVE"
        echo "BLUETOOTH_ACTIVE=$BLUETOOTH_ACTIVE"
        echo "SSHD_ACTIVE=$SSHD_ACTIVE"
    } > "$CONFIG_FILE"
}

# Load the current states
load_states

# Function to remove symlinks for systemd udev services
unmask_udev_services() {
    echo "Removing systemd udev service symlinks..."
    rm -f /etc/systemd/system/systemd-udevd
    rm -f /etc/systemd/system/systemd-udev-trigger.service
    rm -f /etc/systemd/system/systemd-udevd.service
}

# Function to unmask connman service
unmask_connman_service() {
    echo "Unmasking connman service..."
    rm -f /etc/systemd/system/connman.service
}

# Function to unmask systemd network-related services
unmask_network_services() {
    echo "Unmasking systemd network-related services..."
    rm -f /etc/systemd/system/network.target
    rm -f /etc/systemd/system/systemd-network-generator.service
    rm -f /etc/systemd/system/systemd-networkd-wait-online.service
    rm -f /etc/systemd/system/systemd-networkd.service
}

# Function to unmask wpa_supplicant services
unmask_wpa_supplicant_services() {
    echo "Unmasking wpa_supplicant services..."
    rm -f /etc/systemd/system/wpa_supplicant-nl80211@.service
    rm -f /etc/systemd/system/wpa_supplicant-wired@.service
    rm -f /etc/systemd/system/wpa_supplicant.service
    rm -f /etc/systemd/system/wpa_supplicant@.service
}

# Function to unmask Bluetooth services
unmask_bluetooth_services() {
    echo "Unmasking Bluetooth services..."
    rm -f /etc/systemd/system/bluetooth.service
    rm -f /etc/systemd/system/bluetooth.target
}

# Function to unmask dbus-related services
unmask_dbus_services() {
    echo "Unmasking dbus-related services..."
    rm -f /etc/systemd/system/dbus-org.freedesktop.hostname1.service
    rm -f /etc/systemd/system/dbus-org.freedesktop.locale1.service
    rm -f /etc/systemd/system/dbus-org.freedesktop.login1.service
    rm -f /etc/systemd/system/dbus-org.freedesktop.timedate1.service
    rm -f /etc/systemd/system/dbus.service
    rm -f /etc/systemd/system/dbus.socket
    rm -f /etc/systemd/system/dbus.target.wants/dbus.socket
}

unmask_sshd_service() {
    restore_systemd_generators

    echo "Unmask SSHD service..."
    rm -f /etc/systemd/system/sshd.service
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
        WIFI_ACTIVE=true
        unmask_connman_service
        unmask_network_services
        unmask_wpa_supplicant_services
        clear_blacklist
        ;;
    bluetooth)
        BLUETOOTH_ACTIVE=true
        unmask_bluetooth_services
        clear_blacklist
        ;;
    sshd)
        SSHD_ACTIVE=true
        unmask_sshd_service
        ;;
    all)
        WIFI_ACTIVE=true
        BLUETOOTH_ACTIVE=true
        SSHD_ACTIVE=true
        unmask_udev_services
        unmask_connman_service
        unmask_network_services
        unmask_wpa_supplicant_services
        unmask_bluetooth_services
        unmask_dbus_services
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

# Save the updated states
save_states

# Check if SSH is no longer active, and if so, mask the systemd generator
if [ "$SSHD_ACTIVE" == false ]; then
    off_load_systemd_generators
fi

if [ "$BLUETOOTH_ACTIVE" == false ]; then
    blacklist_bluetooth_module
fi

if [ "$WIFI_ACTIVE" == false ]; then
    blacklist_wifi_module
fi

# Check if either Wi-Fi nor Bluetooth is active, if so, unmask udev and dbus
if [ "$WIFI_ACTIVE" == true ] || [ "$BLUETOOTH_ACTIVE" == true ]; then
    unmask_udev_services
    unmask_dbus_services
fi

systemctl daemon-reload

echo "All specified services have been successfully unmasked."
echo "Please reset the board for the changes to take effect or manually restart each service and its dependencies"
