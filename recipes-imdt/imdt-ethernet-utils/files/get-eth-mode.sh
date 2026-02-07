#!/bin/bash

# Title: get-ethernet-mode.sh
# Author: Lewis Purvis, Tien Nguyen
# Description: Echoes the Ethernet mode (DHCP-host, Client)

INTERFACE_NUMBER=$1
NETWORK_DIR=/lib/systemd/network
CONFIG_FILE_BASE="19-end${INTERFACE_NUMBER}.network"

if [ -z "$INTERFACE_NUMBER" ]; then
    echo "Usage: $0 <interface_number>" >&2
    exit 1
fi

FILE="${NETWORK_DIR}/${CONFIG_FILE_BASE}"
FILE_DISABLED="${FILE}.disabled"

if [ -f "${FILE}" ]; then
    echo "ADHOC"
elif [ -f "${FILE_DISABLED}" ]; then
    echo "LAN"
else
    echo "Error: invalid network configuration file" >&2
    exit 1
fi
