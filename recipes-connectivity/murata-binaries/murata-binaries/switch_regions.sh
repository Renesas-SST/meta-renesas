#!/bin/sh

# Switching Tx power binary, edmac, bluetooth power, and regulatory.bin files based on module selection"

VERSION="2.0"
MODULE=1XK
TYPE=`getconf LONG_BIT`
#COUNTRY=EU

function set_iw_reg()
{
    line=$(sed -n '162p' /lib/firmware/nxp/wifi_mod_para.conf)
    COUNTRY=${line#*=}
    COUNTRY=${COUNTRY#*/txpower_}
    COUNTRY=${COUNTRY%.bin}

    echo "${COUNTRY}"
    iw reg set ${COUNTRY}
    echo "Setup complete."
    echo ""
    iw reg get
    echo ""
}

function run_boot()
{
    # check for the existence of folder, "crda"
    if [ ! -d "/usr/lib/crda" ]
    then
        echo "Directory /usr/lib/crda does not exist."
        echo "Creating crda in /usr/lib/"
        mkdir /usr/lib/crda
        cp /lib/firmware/nxp/murata/files/regulatory.rules /etc/udev/rules.d/
    fi

    # Copy Tx power, edmac and bluetooth power files to /lib/firmware/nxp
    cp /lib/firmware/nxp/murata/files/${MODULE}/txpower_*.bin /lib/firmware/nxp
    cp /lib/firmware/nxp/murata/files/${MODULE}/ed_mac.bin /lib/firmware/nxp

    if [ ! -f /lib/firmware/nxp/bt_power_config_1.sh ]; then
        cp /lib/firmware/nxp/murata/files/bt_power_config_1.sh /lib/firmware/nxp
    fi

    # copy regulatory.db and regulatory.db.p7s to /lib/firmwware
    cp /lib/firmware/nxp/murata/files/${MODULE}/regulatory.db     /lib/firmware
    cp /lib/firmware/nxp/murata/files/${MODULE}/regulatory.db.p7s /lib/firmware
}

function modify_conf() {
    # Update the wifi_mod_para.conf file based on ${MODULE} and ${COUNTRY}. Keep a backup.
    if [ ! -f /lib/firmware/nxp/wifi_mod_para.conf.orig ]; then
        if [ -f /lib/firmware/nxp/wifi_mod_para.conf ]; then
        cp /lib/firmware/nxp/wifi_mod_para.conf /lib/firmware/nxp/wifi_mod_para.conf.orig
        fi
    fi

    cp /lib/firmware/nxp/murata/files/wifi_mod_para_murata.conf /lib/firmware/nxp/wifi_mod_para.conf
    sed -i '163 {/^\tinit_hostcmd_cfg=nxp\/ed_mac.bin$/d}' /lib/firmware/nxp/wifi_mod_para.conf

    case ${COUNTRY} in
        US)
        sed -i '162s/txpower_[A-Za-z][A-Za-z]/txpower_US/' /lib/firmware/nxp/wifi_mod_para.conf
        ;;
        EU)
        sed -i '162s/txpower_[A-Za-z][A-Za-z]/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
        sed -i '163s/.*/\tinit_hostcmd_cfg=nxp\/ed_mac.bin\n&/' /lib/firmware/nxp/wifi_mod_para.conf
        ;;
        JP)
        sed -i '162s/txpower_[A-Za-z][A-Za-z]/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
        ;;
        CA)
        sed -i '162s/txpower_[A-Za-z][A-Za-z]/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
        ;;
        *)
        ;;
    esac

    echo "mlan region config changed to ${COUNTRY}."
    echo "please reboot the device for change to take effect."
}


function usage() {
    echo ""
    echo "Version: $VERSION"
    echo ""
    echo "Usage:"
    echo "  $0  <country code>"
    echo ""
    echo "  <country code> is one of :"
    echo "     CA, EU, JP, US"
    echo "     CA - Canada"
    echo "     EU - European Union"
    echo "     JP - Japan"
    echo "     US - United States"
    echo "NOTE: Country code for EU will be displayed as DE when you use the command - iw reg get"
    echo ""
}

if [ $# -eq 0 ]; then
    run_boot
    set_iw_reg
    exit 0
fi

case ${1^^} in
    US)
        COUNTRY=US
        ;;
    EU)
        COUNTRY=EU
        ;;
    JP)
        COUNTRY=JP
        ;;
    CA)
        COUNTRY=CA
        ;;
    *)
        #current
        usage
        exit 1
        ;;
esac

modify_conf
