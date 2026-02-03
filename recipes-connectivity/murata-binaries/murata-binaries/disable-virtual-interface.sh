#!/bin/bash
echo "Disable Virtual Interface: Starting..."

if ! modinfo moal >/dev/null 2>&1; then
    echo "No WiFi modules on this board, skipping..."
    exit 0
fi

# Wait for system to be ready
sleep 15

# Check if WiFi is already working
if iwconfig wlan0 2>/dev/null | grep -q "IEEE 802.11"; then
    echo "WiFi already working, just disabling virtual interfaces"
    ip link set uap0 down 2>/dev/null || true
    ip link set wfd0 down 2>/dev/null || true
    exit 0
fi

# Full reload sequence
echo "Reloading WiFi driver..."
rmmod moal 2>/dev/null || true
rmmod mlan 2>/dev/null || true
sleep 3

# Load with clean state
modprobe moal
sleep 10

# Disable virtual interfaces
ip link set uap0 down 2>/dev/null || true
ip link set wfd0 down 2>/dev/null || true

# Start hostapd if configured
if [ -f /etc/hostapd.conf ]; then
    systemctl start hostapd 2>/dev/null || true
fi

echo "Disable Virtual Interface: Complete"
