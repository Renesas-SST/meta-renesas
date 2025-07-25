#!/bin/bash

cru=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "cru-ip")
csi2=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "csi2")
ov=$(cat /sys/class/video4linux/v4l-subdev*/name | grep "ov")
default_camera=$(echo "$ov" | awk '{print $1}')

declare -A camera_default_resolution
camera_default_resolution["ov5640"]="1280x720"
camera_default_resolution["ov5645"]="1280x960"

declare -A camera_valid_resolutions
camera_valid_resolutions["ov5640"]="720x480 720x576 1024x768 1280x720 1920x1080 2592x1944"
camera_valid_resolutions["ov5645"]="1280x960 1920x1080 2592x1944"

# Usage information function
function print_usage {
    echo "Usage: $0 <resolution>"
    echo "Detected camera: $default_camera"
    echo "Available resolutions for $default_camera: ${camera_valid_resolutions[$default_camera]}"
    echo ""
    echo "Example: $0 1920x1080"
    echo "If no resolution is specified, $default_camera will used the default resolution '${camera_default_resolution[$default_camera]}'."
}

# Check if help is requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Check for no input
if [ -z "$1" ]; then
    echo "Detected camera: $default_camera"
    echo "No resolution specified. Using default resolution: ${camera_default_resolution[$default_camera]}"
    ov564x_res="${camera_default_resolution[$default_camera]}"
else
    ov564x_res="$1"
    valid_resolutions=(${camera_valid_resolutions[$default_camera]})
    # Check if the given resolution is valid
    if [[ ! " ${valid_resolutions[@]} " =~ " ${ov564x_res} " ]]; then
        echo "Invalid resolution: $ov564x_res for camera $default_camera"
        ov564x_res="${camera_default_resolution[$default_camera]}"
        echo "Input resolution is not available. Using default resolution: ${camera_default_resolution[$default_camera]}"
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
        media-ctl -d /dev/media0 -V "'$csi2':0 [fmt:UYVY8_1X16/$ov564x_res field:none]"
        media-ctl -d /dev/media0 -V "'$csi2':1 [fmt:UYVY8_1X16/$ov564x_res field:none]"
        media-ctl -d /dev/media0 -V "'$ov':0 [fmt:UYVY8_1X16/$ov564x_res field:none]"
        media-ctl -d /dev/media0 -V "'$cru':0 [fmt:UYVY8_1X16/$ov564x_res field:none]"
        media-ctl -d /dev/media0 -V "'$cru':1 [fmt:UYVY8_1X16/$ov564x_res field:none]"

        width=${ov564x_res%x*}
        height=${ov564x_res#*x}
        v4l2-ctl -d /dev/video0 --set-fmt-video=width=${width},height=${height},pixelformat=UYVY
        echo "Link CRU/CSI2 to $ov with format UYVY8_1X16 and resolution ${ov564x_res}"
    fi
fi
