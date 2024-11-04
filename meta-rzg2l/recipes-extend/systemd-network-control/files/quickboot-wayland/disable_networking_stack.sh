# This script creates symlinks to /dev/null for various systemd services
# to prevent them from being enabled. It includes services related to udev,
# networking, wpa_supplicant, Bluetooth, and dbus.

set -e

# Config file to track states of network
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

# Function to mask systemd udev services
mask_systemd_udev() {
    echo "Masking systemd udev services..."
    ln -sf /dev/null /etc/systemd/system/systemd-udevd
    ln -sf /dev/null /etc/systemd/system/systemd-udev-trigger.service
    ln -sf /dev/null /etc/systemd/system/systemd-udevd.service
}

# Function to mask systemd connman and wpa supplicant
mask_systemd_wifi_related() {
    echo "Masking systemd connman and wpa supplicant services..."

    # Mask connman service
    ln -sf /dev/null /etc/systemd/system/connman.service

    # Mask wpa_supplicant services
    ln -sf /dev/null /etc/systemd/system/wpa_supplicant-nl80211@.service
    ln -sf /dev/null /etc/systemd/system/wpa_supplicant-wired@.service
    ln -sf /dev/null /etc/systemd/system/wpa_supplicant.service
    ln -sf /dev/null /etc/systemd/system/wpa_supplicant@.service
}

# Function to mask systemd network-related services
mask_systemd_network_service() {
    # Mask systemd network-related services
    echo "Masking network-related services..."

    ln -sf /dev/null /etc/systemd/system/network.target
    ln -sf /dev/null /etc/systemd/system/systemd-network-generator.service
    ln -sf /dev/null /etc/systemd/system/systemd-networkd-wait-online.service
    ln -sf /dev/null /etc/systemd/system/systemd-networkd.service
}

# Function to mask bluetooth services
mask_systemd_bluetooth() {
    # Mask Bluetooth services
    echo "Masking systemd bluetooth services..."

    ln -sf /dev/null /etc/systemd/system/bluetooth.service
    ln -sf /dev/null /etc/systemd/system/bluetooth.target
}

# Function to mask dbus services
mask_systemd_dbus() {
    echo "Masking systemd dbus services..."

    mkdir -p /etc/systemd/system/dbus.target.wants/
    ln -sf /dev/null /etc/systemd/system/dbus-org.freedesktop.hostname1.service
    ln -sf /dev/null /etc/systemd/system/dbus-org.freedesktop.locale1.service
    ln -sf /dev/null /etc/systemd/system/dbus-org.freedesktop.login1.service
    ln -sf /dev/null /etc/systemd/system/dbus-org.freedesktop.timedate1.service
    ln -sf /dev/null /etc/systemd/system/dbus.service
    ln -sf /dev/null /etc/systemd/system/dbus.socket
    ln -sf /dev/null /etc/systemd/system/sshd.service
}

mask_sshd_service() {
    echo "Masking systemd sshd services..."

    off_load_systemd_generators
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
        WIFI_ACTIVE=false
        mask_systemd_wifi_related
        mask_systemd_network_service
        ;;
    bluetooth)
        BLUETOOTH_ACTIVE=false
        mask_systemd_bluetooth
        ;;
    sshd)
        SSHD_ACTIVE=false
        mask_sshd_service
        ;;
    all)
        WIFI_ACTIVE=false
        BLUETOOTH_ACTIVE=false
        SSHD_ACTIVE=false
        mask_systemd_wifi_related
        mask_systemd_network_service
        mask_systemd_dbus
        mask_systemd_bluetooth
        mask_sshd_service
        off_load_systemd_generators
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

# Check if neither Wi-Fi nor Bluetooth are active, and mask udev and dbus if so
if [ "$WIFI_ACTIVE" == false ] && [ "$BLUETOOTH_ACTIVE" == false ]; then
    mask_systemd_dbus
fi

systemctl daemon-reload

echo "All specified systemd services have been successfully masked."
echo "Please reset the board for the changes to take effect."
