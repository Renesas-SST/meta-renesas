#!/bin/bash
#: Title        : get-ethernet-mode.sh
#: Author       : Lewis Purvis
#: Description  : Echoes the Ethernet mode (DHCP-host, Client)

FILE=/lib/systemd/network/19-eth${1}.network
FILE2=/lib/systemd/network/19-eth${1}.network.disabled
if [ -f "$FILE" ]
then
    echo "ADHOC"
elif [ -f "$FILE2" ]
then
    echo "LAN"
else
    echo "Error: invalid network configuration file"
fi

