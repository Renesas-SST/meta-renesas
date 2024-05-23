#!/bin/bash
#: Title        : get-wifi-mode.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Echoes the WiFi mode (AP, STA or OFF)

systemctl is-active hostapd.service --quiet
HOSTAPD_STATUS=$?

systemctl is-active wpa_supplicant-nl80211@wlan0.service --quiet
WPA_SUPPLICANT_STATUS=$?

if [ "$HOSTAPD_STATUS" == "0" ]
then
    echo "AP"
elif [ "$WPA_SUPPLICANT_STATUS" == "0" ]
then
    echo "STA"
else
    echo "OFF"
fi
