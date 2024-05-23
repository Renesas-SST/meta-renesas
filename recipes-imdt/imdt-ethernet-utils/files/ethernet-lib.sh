#: Title        : ethernet-lib.sh
#: Author       : Paul Thomson <pault@imd-tec.com>, Lewis Purvis <lewisp@imd-tec.com>
#: Description  : Library of functions for use by the Ethernet control scripts


function enable_ethernet_network_unit
{
    local num=$1
    pushd /lib/systemd/network 1>/dev/null
    mv 19-eth${num}.network.disabled 19-eth${num}.network 2>/dev/null
    popd 1>/dev/null

    systemctl restart systemd-networkd
}

function disable_ethernet_network_unit
{
    local num=$1
    pushd /lib/systemd/network 1>/dev/null
    mv 19-eth${num}.network 19-eth${num}.network.disabled 2>/dev/null
    popd 1>/dev/null

    systemctl restart systemd-networkd
}

function take_down_eth
{
    local num=$1
    ip link set eth${num} down
}

function bring_up_eth
{
    local num=$1
    ip link set eth${num} up
}
