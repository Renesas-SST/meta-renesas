#!/bin/bash
#: Title        : connect-to-access-point.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Configures and enables a connection to a WiFi access point

function display_usage
{
    echo -e ""
    echo -e "Usage:"
    echo -e ""
    echo -e "$0 [<SSID> <Passphrase>]"
    echo -e ""
    echo -e "\tSSID\t\t : SSID of the access point to connect to"
    echo -e "\tPassphrase\t : Plaintext passphrase (8 to 63 characters)"
    echo -e ""
    exit 1
}

. /opt/imdt/wifi/wifi-lib.sh

case $# in
    0) ;;
    2) ;;
    *) echo "Error - incorrect number of command line arguments"
       display_usage
       ;;
esac

if [ $# == 2 ]
then

    SSID=$1
    PASSPHRASE=$2

    SSID_LEN=${#SSID}
    PASSPHRASE_LEN=${#PASSPHRASE}

    if [ $SSID_LEN -gt 32 ]
    then
        echo "Error - SSID is too long"
        display_usage
    fi

    if [ $PASSPHRASE_LEN -lt 8 ]
    then
        echo "Error - passphrase is too short"
        display_usage
    fi

    if [ $PASSPHRASE_LEN -gt 63 ]
    then
        echo "Error - passphrase is too long"
        display_usage
    fi

    TMP_FILE=`mktemp`

    echo "ctrl_interface=/var/run/wpa_supplicant" > $TMP_FILE
    echo "ctrl_interface_group=0" >> $TMP_FILE
    echo "update_config=1" >> $TMP_FILE
    echo "" >> $TMP_FILE

    wpa_passphrase "$SSID" "$PASSPHRASE" >> $TMP_FILE

    if [ $? == 0 ]
    then
        cp $TMP_FILE /etc/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf
    else
        echo "Failed to create wpa_supplicant configuration file ($?)"
        display_usage
    fi

    rm $TMP_FILE

fi

# Enable or restart STA mode, depending on the current mode

MODE=`/opt/imdt/wifi/get-wifi-mode.sh`

if [ $MODE == "AP" ]
then

    disable_access_point

    enable_station_network_unit

    enable_station

elif [ $MODE == "STA" ]
then

    restart_station

else

    enable_station_network_unit

    enable_station

fi
