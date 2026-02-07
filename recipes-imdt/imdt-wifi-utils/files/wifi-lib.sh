#: Title        : wifi-lib.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#               : Tien Nguyen <tien.nguyen.uh@renesas.com>
#: Description  : Library of functions for use by the WiFi control scripts

# Get network IP from existing configuration
function get_network_ip
{
    local network_ip=""

    # Try to extract from existing AP network config
    if [ -f /lib/systemd/network/21-ap.network ]; then
        network_ip=$(grep "Address=" /lib/systemd/network/21-ap.network | cut -d'=' -f2 | cut -d'/' -f1)
    elif [ -f /lib/systemd/network/21-ap.network.disabled ]; then
        network_ip=$(grep "Address=" /lib/systemd/network/21-ap.network.disabled | cut -d'=' -f2 | cut -d'/' -f1)
    fi

    # Fallback to default if extraction fails
    if [ -z "$network_ip" ]; then
        network_ip="172.16.10.100"
    fi

    echo "$network_ip"
}

# Add missing functions for internet sharing
function setup_internet_sharing
{
    echo 1 > /proc/sys/net/ipv4/ip_forward

    local wan_iface=""
    for i in {1..10}; do
        wan_iface=$(ip -4 route show default 0.0.0.0/0 2>/dev/null | awk '{print $5}' | head -n1)
        [ -n "$wan_iface" ] && break
        sleep 1
    done

    if [ -n "$wan_iface" ]; then
        iptables -t nat -A POSTROUTING -o "$wan_iface" -j MASQUERADE
        iptables -A FORWARD -i wlan0 -o "$wan_iface" -j ACCEPT
        iptables -A FORWARD -i "$wan_iface" -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        echo "Internet sharing enabled via $wan_iface"
    else
        echo "Warning: No active internet connection found, skipping internet sharing"
    fi
}

function update_ap_network_config
{
    local network_ip=$(get_network_ip)

    cat > /lib/systemd/network/21-ap.network << EOF
[Match]
Name=wlan0

[Network]
Address=$network_ip/24
DHCPServer=yes

[DHCPServer]
PoolOffset=200
PoolSize=32
EmitDNS=yes
DNS=8.8.8.8
EmitRouter=yes
EOF
    systemctl restart systemd-networkd
}

function enable_access_point
{
    update_ap_network_config
    setup_internet_sharing
    systemctl enable hostapd.service
    systemctl start hostapd.service
}

function disable_access_point
{
    systemctl stop hostapd.service
    systemctl disable hostapd.service
}

function restart_access_point
{
    update_ap_network_config
    setup_internet_sharing
    systemctl restart hostapd.service
}

function enable_station
{
    systemctl stop wpa_supplicant.service 2>/dev/null || true
    systemctl stop wpa_supplicant-nl80211@wlan0.service 2>/dev/null || true
    pkill -x wpa_supplicant 2>/dev/null || true
    rm -f /run/wpa_supplicant/wlan0 /var/run/wpa_supplicant/wlan0

    systemctl enable wpa_supplicant-nl80211@wlan0.service
    systemctl start wpa_supplicant-nl80211@wlan0.service
}

function disable_station
{
    systemctl stop wpa_supplicant-nl80211@wlan0.service
    systemctl disable wpa_supplicant-nl80211@wlan0.service
}

function restart_station
{
    systemctl stop wpa_supplicant.service 2>/dev/null || true
    systemctl stop wpa_supplicant-nl80211@wlan0.service 2>/dev/null || true
    pkill -x wpa_supplicant 2>/dev/null || true
    rm -f /run/wpa_supplicant/wlan0 /var/run/wpa_supplicant/wlan0

    systemctl start wpa_supplicant-nl80211@wlan0.service
}

function enable_access_point_network_unit
{
    pushd /lib/systemd/network 1>/dev/null
    mv 21-ap.network.disabled 21-ap.network 2>/dev/null || true
    mv 25-wlan.network 25-wlan.network.disabled 2>/dev/null || true
    popd 1>/dev/null
    # Don't restart here - let update_ap_network_config handle it
}

function enable_station_network_unit
{
    pushd /lib/systemd/network 1>/dev/null
    mv 21-ap.network 21-ap.network.disabled 2>/dev/null || true
    mv 25-wlan.network.disabled 25-wlan.network 2>/dev/null || true
    popd 1>/dev/null
    systemctl restart systemd-networkd
}

function disable_network_units
{
    pushd /lib/systemd/network 1>/dev/null
    mv 21-ap.network 21-ap.network.disabled 2>/dev/null || true
    mv 25-wlan.network 25-wlan.network.disabled 2>/dev/null || true
    popd 1>/dev/null
    systemctl restart systemd-networkd
}

function take_down_wlan0
{
    ip link set wlan0 down
}

function prepare_wifi_hardware
{
    # Unblock WiFi hardware
    rfkill unblock all

    # Check and recover WiFi driver if needed
    check_and_recover_wifi_driver || exit 1

    # Disable problematic virtual interfaces
    ip link set uap0 down 2>/dev/null || true
    ip link set wfd0 down 2>/dev/null || true

    # Suppress annoying kernel messages
    # Message: Easymesh Error! Can't find station in the station list
    echo "4 4 1 7" > /proc/sys/kernel/printk
}

function check_and_recover_wifi_driver
{
    # Check if wlan0 exists
    if ! ip link show wlan0 &>/dev/null; then
        echo "WiFi interface wlan0 not found, reloading driver..."

        # Stop any WiFi services
        systemctl stop hostapd 2>/dev/null || true
        killall hostapd 2>/dev/null || true

        # Remove WiFi modules
        rmmod moal 2>/dev/null || true
        rmmod mlan 2>/dev/null || true

        sleep 2

        # Reload modules
        modprobe mlan
        modprobe moal

        # Wait for driver to initialize
        sleep 3

        # Verify wlan0 is now available
        if ! ip link show wlan0 &>/dev/null; then
            echo "Error: Failed to recover WiFi driver"
            return 1
        fi

        echo "WiFi driver recovered successfully"
    fi

    return 0
}
