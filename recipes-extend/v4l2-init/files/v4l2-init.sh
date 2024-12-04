#!/bin/sh

cru=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "cru-ip")
csi2=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "csi2")
valid_resolutions=("720x480" "720x576" "1024x768" "1280x720" "1920x1080" "2592x1944")

# Usage information function
function print_usage {
    echo "Usage: $0 <resolution>"
    echo "Available resolutions for ov5640: ${valid_resolutions[@]}. \
	Using default resolution '1280x720'."
    echo "Example: $0 1920x1080"
    echo "If no resolution is specified, the default resolution '1280x720' will be used."
}

# Check if help is requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Check for no input
if [ -z "$1" ]; then
    echo "No resolution specified. Using default resolution: 1280x720"
    ov5640_res="1280x720"
else
    ov5640_res=$1
    # Check if the given resolution is valid
    if [[ ! " ${valid_resolutions[@]} " =~ " ${ov5640_res} " ]]; then
        echo "Invalid resolution: $ov5640_res"
        ov5640_res="1280x720"
        echo "Input resolution is not available. Using default resolution: 1280x720"
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
        media-ctl -d /dev/media0 -V "'$csi2':1 [fmt:UYVY8_1X16/$ov5640_res field:none]"
        media-ctl -d /dev/media0 -V "'ov5640 1-003c':0 [fmt:UYVY8_1X16/$ov5640_res field:none]"
        media-ctl -d /dev/media0 -V "'$cru':0 [fmt:UYVY8_1X16/$ov5640_res field:none]"
        media-ctl -d /dev/media0 -V "'$cru':1 [fmt:UYVY8_1X16/$ov5640_res field:none]"
        echo "Link CRU/CSI2 to ov5640 1-003c with format UYVY8_1X16 and resolution $ov5640_res"
    fi
fi
