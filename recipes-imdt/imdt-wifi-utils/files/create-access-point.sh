#!/bin/bash
#: Title        : create-access-point.sh
#: Author       : Paul Thomson <pault@imd-tec.com>
#: Description  : Creates/enables a WiFi access point

function display_usage
{
    echo -e ""
    echo -e "Usage:"
    echo -e ""
    echo -e "$0 [<SSID> <Passphrase>]"
    echo -e ""
    echo -e "\tSSID\t\t : SSID of the new access point"
    echo -e "\tPassphrase\t : Plaintext passphrase (8 to 63 characters)"
    echo -e ""
    exit 1
}

. /opt/imdt/wifi/wifi-lib.sh

# Check command line arguments

case $# in
    0) ;;
    2) ;;
    *) echo "Error - incorrect number of command line arguments"
       display_usage
       ;;
esac

# If two arguments, update the hostapd.conf file

if [ $# == 2 ]
then

    # Validate inputs

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

    # Generate PSK

    PSK=""

    TMP_FILE=`mktemp`

    wpa_passphrase "$SSID" "$PASSPHRASE" > $TMP_FILE

    if [ $? == 0 ]
    then
        while IFS== read KEY VALUE
        do
            KEY=${KEY//$'\t'/}

            case $KEY in
                "psk") PSK=$VALUE;;
                *);;
            esac
        done < "$TMP_FILE"
    fi

    rm $TMP_FILE

    PSK_LENGTH=${#PSK}

    if [ $PSK_LENGTH -lt 64 ]
    then
        echo "Error - PSK length is incorrect ($PSK_LENGTH)"
        display_usage
    fi

    # Create new hostapd.conf file

    EXISTING_CONF_FILE="/etc/hostapd.conf"
    BACKUP_CONF_FILE="$EXISTING_CONF_FILE.bak"

    NEW_CONF_FILE=`mktemp`

    while IFS== read KEY VALUE
    do
        case $KEY in
            "ssid") VALUE=$SSID;;
            "wpa_psk") VALUE=$PSK;;
            *);;
        esac

        echo "$KEY=$VALUE" >> $NEW_CONF_FILE

    done < "$EXISTING_CONF_FILE"

    # Backup old conf file

    cp $EXISTING_CONF_FILE $BACKUP_CONF_FILE

    # Copy new file over old file

    cp $NEW_CONF_FILE $EXISTING_CONF_FILE

fi

# Correct behaviour depends on the mode

MODE=`/opt/imdt/wifi/get-wifi-mode.sh`

if [ $MODE == "AP" ]
then

    if [ $# == 2 ]
    then

        restart_access_point

    else

        echo "WiFi interface is already in Access Point mode"
        exit 1

    fi

elif [ $MODE == "STA" ]
then

    disable_station

    enable_access_point_network_unit

    enable_access_point

else

    enable_access_point_network_unit

    enable_access_point

fi
