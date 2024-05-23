#!/bin/bash
#: Title        : get-connection-status.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Echoes the connection status in JSON format

MODE=`/opt/imdt/wifi/get-wifi-mode.sh`

if [ $MODE != "STA" ]
then
    echo "WiFi interface is not in STAtion mode"
    exit 1
fi

# Get the basic state of the connection

STATUS_FILE=`mktemp`

wpa_cli -i wlan0 status > $STATUS_FILE

SSID=""
WPA_STATE=""
RSSI=""
FREQUENCY=""

if [ $? == 0 ]
then
    while IFS== read KEY VALUE
    do
        case $KEY in
            "ssid") SSID=$VALUE;;
            "wpa_state") WPA_STATE=$VALUE;;
            *);;
        esac
    done < "$STATUS_FILE"
fi

rm $STATUS_FILE

# If we're connected, get the RSSI and frequency

if [ $WPA_STATE == "COMPLETED" ]
then

    SIGNAL_POLL_FILE=`mktemp`

    wpa_cli -i wlan0 signal_poll > $SIGNAL_POLL_FILE

    if [ $? == 0 ]
    then
        while IFS== read KEY VALUE
        do
            case $KEY in
                "RSSI") RSSI=$VALUE;;
                "FREQUENCY") FREQUENCY=$VALUE;;
                *);;
            esac
        done < "$SIGNAL_POLL_FILE"
    fi

    rm $SIGNAL_POLL_FILE
fi

# Format the output as JSON

echo -ne "{"
echo -ne "\"wpa_state\":\"$WPA_STATE\","
echo -ne "\"ssid\":\"$SSID\","
echo -ne "\"rssi\":\"$RSSI\","
echo -ne "\"frequency\":\"$FREQUENCY\""
echo -ne "}"
echo ""
