#!/bin/sh

cru=$(cat /sys/class/video4linux/video*/name | grep "CRU")
csi2=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "csi2")
valid_resolutions=("1280x720" "1280x960" "1600x900" "1920x1080" "1920x1200" "2560x1080")

# Usage information function
function print_usage {
    echo "Usage: $0 <resolution>"
    echo "Available resolutions for ov5640: ${valid_resolutions[@]}. \
	Using default resolution '1280x960'."
    echo "Example: $0 1920x1080"
    echo "If no resolution is specified, the default resolution '1280x960' will be used."
}

# Check if help is requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Check for no input
if [ -z "$1" ]; then
    echo "No resolution specified. Using default resolution: 1280x960"
    ov5640_res="1280x960"
else
    ov5640_res=$1
    # Check if the given resolution is valid
    if [[ ! " ${valid_resolutions[@]} " =~ " ${ov5640_res} " ]]; then
        echo "Invalid resolution: $ov5640_res"
        ov5640_res="1280x960"
        echo "Input resolution is not available. Using default resolution: 1280x960"
    fi
fi

if [ -z "$cru" ]
then
    echo "No CRU video device founds"
else
    media-ctl -d /dev/media0 -r
    if [ -z "$csi2" ]
    then
        echo "No MIPI CSI2 sub video device founds"
    else
        media-ctl -d /dev/media0 -l "'rzg2l_csi2 10830400.csi2':1 -> 'CRU output':0 [1]"
        media-ctl -d /dev/media0 -V "'rzg2l_csi2 10830400.csi2':1 [fmt:UYVY8_2X8/$ov5640_res field:none]"
        media-ctl -d /dev/media0 -V "'ov5640 1-003c':0 [fmt:UYVY8_2X8/$ov5640_res field:none]"
        echo "Link CRU/CSI2 to ov5640 1-003c with format UYVY8_2X8 and resolution $ov5640_res"
    fi
fi
