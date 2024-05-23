#!/bin/bash
#: Title        : set-eth-mode.sh
#: Author       : Lewis Purvis <lewisp@imd-tec.com>
#: Description  : Set an ethernet interface into adhoc mode

function display_usage
{
    echo -e ""
    echo -e "Usage:"
    echo -e ""
    echo -e "$0 <ethernet-interface-number> [0|1]"
    echo -e ""
    echo -e "\t<interface-number> : Specify the ethernet interface number (0 or 1)"
    echo -e "\t1 : LAN mode - Connect to an existing network. Expects DHCP server elsewhere on network."
    echo -e "\t    falls back to default IP address if not found."
    echo -e ""
    echo -e "\t2 : ADHOC mode - Connect directly to another machine. This sets a static IP address for the device"
    echo -e "\t    and uses a DHCP server to lease an IP address to whatever device you wish to connect to it."
    echo -e ""
    exit 1
}

. /opt/imdt/ethernet/ethernet-lib.sh

# Check command line arguments
if [ $# -ne 2 ]; then
    display_usage
    exit 0
fi

INTERFACE_NUMBER=$1
MODE_ARG=$2

if ! [[ "$INTERFACE_NUMBER" =~ ^(0|1)$ ]]; then
    echo "Invalid interface number argument"
    display_usage
    exit 1
fi

if ! [ "$MODE_ARG" -eq 1 ] && ! [ "$MODE_ARG" -eq 2 ]; then
    echo "Invalid mode argument"
    display_usage
    exit 1
fi


# Correct behavior depends on the mode
MODE=$(/opt/imdt/ethernet/get-eth-mode.sh "${INTERFACE_NUMBER}")

# where lan == 1
if [ "$MODE" == "LAN" ]; then
    if [ "$MODE_ARG" == 1 ]; then
        echo "Ethernet eth${INTERFACE_NUMBER} is already in LAN mode"
        exit 0
    else
        enable_ethernet_network_unit "${INTERFACE_NUMBER}"
        echo "Ethernet eth${INTERFACE_NUMBER} set to ADHOC mode."
    fi
elif [ "$MODE" == "ADHOC" ]; then
    if [ "$MODE_ARG" == 2 ]; then
        echo "Ethernet eth${INTERFACE_NUMBER} is already in ADHOC mode"
        exit 0
    else
        disable_ethernet_network_unit "${INTERFACE_NUMBER}"
        echo "Ethernet eth${INTERFACE_NUMBER} set to LAN mode."
    fi
else
    echo "Error: unrecognized ethernet mode for eth${INTERFACE_NUMBER}!"
    exit 1
fi
