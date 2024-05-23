#: Title        : wifi-lib.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Library of functions for use by the WiFi control scripts

function enable_access_point
{
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
    mv 21-ap.network.disabled 21-ap.network 2>/dev/null
    mv 25-wlan.network 25-wlan.network.disabled 2>/dev/null
    popd 1>/dev/null

    systemctl restart systemd-networkd
}

function enable_station_network_unit
{
    pushd /lib/systemd/network 1>/dev/null
    mv 21-ap.network 21-ap.network.disabled 2>/dev/null
    mv 25-wlan.network.disabled 25-wlan.network 2>/dev/null
    popd 1>/dev/null

    systemctl restart systemd-networkd
}

function disable_network_units
{
    pushd /lib/systemd/network 1>/dev/null
    mv 21-ap.network 21-ap.network.disabled 2>/dev/null
    mv 25-wlan.network 25-wlan.network.disabled 2>/dev/null
    popd 1>/dev/null

    systemctl restart systemd-networkd
}

function take_down_wlan0
{
    ip link set wlan0 down
}
