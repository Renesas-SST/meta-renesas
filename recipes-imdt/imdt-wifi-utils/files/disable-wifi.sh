#!/bin/bash
#: Title        : disable-wifi.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Disables the WiFi interface

. /opt/imdt/wifi/wifi-lib.sh

disable_access_point

disable_station

disable_network_units

take_down_wlan0
