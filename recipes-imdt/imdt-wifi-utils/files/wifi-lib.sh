#: Title        : wifi-lib.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
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
    iptables -t nat -A POSTROUTING -o end0 -j MASQUERADE
    iptables -A FORWARD -i wlan0 -o end0 -j ACCEPT
    iptables -A FORWARD -i end0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
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
    systemctl restart wpa_supplicant-nl80211@wlan0.service
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

    # Disable problematic virtual interfaces
    ip link set uap0 down 2>/dev/null || true
    ip link set wfd0 down 2>/dev/null || true

    # Suppress annoying kernel messages
    # Message: Easymesh Error! Can't find station in the station list
    echo "4 4 1 7" > /proc/sys/kernel/printk
}
