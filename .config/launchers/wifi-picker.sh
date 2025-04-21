#!/bin/bash

# Grab list of available Wi-Fi networks (skip duplicates)
wifi_list=$(nmcli --fields SSID,SIGNAL,SECURITY device wifi list | awk '!seen[$0]++')

# Format into columns with headers
formatted=$(echo -e "SSID\tSIGNAL\tSECURITY\n$wifi_list" | column -t -s $'\t')

# Show with Wofi
selected=$(echo "$formatted" | tail -n +2 | wofi --dmenu --prompt "Select Wi-Fi" --width 600 --height 400)

# Extract just the SSID (first column)
ssid=$(echo "$selected" | awk '{print $1}')

# Try to connect
if [ -n "$ssid" ]; then
    nmcli device wifi connect "$ssid"
fi

