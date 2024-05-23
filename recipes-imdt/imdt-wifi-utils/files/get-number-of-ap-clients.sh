#!/bin/bash
#: Title        : get-number-of-ap-clients.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Echoes the number of clients connected to an access point

MODE=`/opt/imdt/wifi/get-wifi-mode.sh`

if [ $MODE != "AP" ]
then
    echo "WiFi interface is not in Access Point mode"
    exit 1
fi

hostapd_cli -i wlan0 list_sta 2>/dev/null | wc -l
