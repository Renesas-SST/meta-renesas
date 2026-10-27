#!/bin/bash
#===============================================================================
# title           : v4l2-init.sh
# description     : Initialise and test camera pipelines for RZ Common System
# usage           : bash v4l2-init.sh --device 0 --width 1280 --height 720
#                   bash v4l2-init.sh --camera imx219 --stream --sink wayland
#
# Two kinds of camera graphs are handled:
#
#   * RZ/G2L style (CRU): sensor -> CSI2 -> CRU.  The media links and formats
#     are configured here with media-ctl (ov5640, ov5645, ap1302, ar1335).
#
#   * R-Car Gen4 (Sparrow-Hawk / V4H): sensor -> CSI2 -> ISP -> VIN.  The
#     CSI2 -> ISP links are immutable and libcamera owns the whole pipeline
#     (imx219 = Raspberry Pi Camera V2, imx708 = Raspberry Pi Camera V3), so
#     media-ctl is not used (never run `media-ctl -r` on this hardware).  The
#     camera is selected by name with `cam -l` and streamed with libcamerasrc.
#===============================================================================
set -eE

# Supported camera models (CRU boards)
SUPPORTED_MODELS=("ov5640" "ov5645" "ap1302" "ar1335")

# Supported camera models (R-Car Gen4 boards, handled by libcamera)
V4H_CAMERAS="imx219 imx708"

# Default values
DEFAULT_DEVICE_ID=0
DEFAULT_CAPTURE_WIDTH="1920"
DEFAULT_CAPTURE_HEIGHT="1080"

# Options (set by parse_shell_args)
DEVICE_ID=${DEFAULT_DEVICE_ID}
CAMERA_REQUEST=auto
WIDTH=""
HEIGHT=""
STREAM=0
PRINT_GST=0
SINK=wayland
FRAMES=0

# Valid resolutions per camera model
declare -A CAMERA_VALID_RESOLUTIONS
CAMERA_VALID_RESOLUTIONS["ov5640"]="720x480 720x576 1024x768 1280x720 1920x1080 2592x1944"
CAMERA_VALID_RESOLUTIONS["ov5645"]="1280x960 1920x1080 2592x1944"
CAMERA_VALID_RESOLUTIONS["ap1302"]="1280x720 1920x1080"
CAMERA_VALID_RESOLUTIONS["ar1335"]="1280x720 1920x1080"

declare -A CAMERA_DEFAULT_FORMAT
CAMERA_DEFAULT_FORMAT["ov5640"]="UYVY8_1X16"
CAMERA_DEFAULT_FORMAT["ov5645"]="UYVY8_1X16"
CAMERA_DEFAULT_FORMAT["ap1302"]="YUYV8_1X16"
CAMERA_DEFAULT_FORMAT["ar1335"]="SRGGB10_1X10"

# Detect subdevs
mapfile -t subdevs < <(
  grep '-' /sys/class/video4linux/v4l-subdev*/name 2>/dev/null \
    | sed 's/.*://' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u
)

# Get camera model
get_cam_model() {
    local cam="$1"
    # Strip everything after first space or dot
    echo "$cam" | sed -E 's/[ .].*//'
}

# Filter supported cameras
cameras=()
for s in "${subdevs[@]}"; do
  for m in "${SUPPORTED_MODELS[@]}"; do
    if [[ "$s" == "$m"* ]]; then
        cameras+=("$s")
        break
    fi
  done
done

# Detect CSI2 and CRU (entity names only)
mapfile -t csi2 < <(grep 'csi2' /sys/class/video4linux/v4l-subdev*/name 2>/dev/null | sed 's|.*/name:||')
mapfile -t cru  < <(grep 'cru-ip' /sys/class/video4linux/v4l-subdev*/name 2>/dev/null | sed 's|.*/name:||')

# Set defaults
default_camera=${cameras[0]:-"<none>"}
default_csi2=${csi2[0]:-"<none>"}
default_cru=${cru[0]:-"<none>"}
cru_output="CRU output"

die() {
    echo "ERROR: $*" >&2
    exit 1
}

have() {
    command -v "$1" >/dev/null 2>&1
}

# Usage
function print_usage {
    local -A seen_models
    local resolution_info=""

    for cam in "${cameras[@]}"; do
        local model=$(get_cam_model "$cam")
        # Only add if not already processed
        if [[ -z "${seen_models[$model]:-}" ]]; then
            seen_models[$model]=1
            resolution_info+="  ${model}: ${CAMERA_VALID_RESOLUTIONS[$model]}"$'\n'
        fi
    done

cat << EOF
Usage: v4l2-init [options]
Options:
  --help                    show this help message and exit
  --device DEVICE_ID        The id of the media device, where 0 corresponds to /dev/media0
  --width WIDTH             Width of capture image
  --height HEIGHT           Height of capture image

R-Car Gen4 (Sparrow-Hawk / V4H) options, camera handled by libcamera:
  --camera NAME             auto, imx219 (Pi Camera V2, J1) or imx708 (Pi Camera V3, J2)
                            (default: auto)
  --stream                  run the GStreamer pipeline
  --sink NAME               fakesink, wayland or autovideosink (default: wayland)
  --frames N                stop after N frames (default 5 with --sink fakesink)
  --print-gst               print the GStreamer command and exit

  The default size is 1920x1080 for imx219 and 2304x1296 (native) for imx708.
  Another size is applied to imx708 with videoscale after capture.

Detected cameras: ${cameras[*]}

Available resolutions:
${resolution_info}
Examples:
  $0 --device 0 --width 1920 --height 1080
  $0 --camera imx219 --stream --sink wayland
  $0 --camera imx708 --stream --sink fakesink --frames 5
EOF
}

#===============================================================================
# CRU boards (RZ/G2L): media-ctl based pipeline
#===============================================================================

# Validate resolution against camera model
check_resolution() {
    local cam_model="$1"
    local width="$2"
    local height="$3"
    local target="${width}x${height}"
    for res in ${CAMERA_VALID_RESOLUTIONS[$cam_model]}; do
        if [[ "$res" == "$target" ]]; then
            echo "$target"
            return
        fi
    done

    # Fallback to first listed resolution if the input is invalid
    local fallback=$(echo ${CAMERA_VALID_RESOLUTIONS[$cam_model]} | awk '{print $1}')
    echo "WARNING: Requested resolution '${target}' is invalid for '${cam_model}', falling back to '${fallback}'." >&2
    echo "$fallback"
}

# Validate requested media device exists.
validate_device_index() {
    local device_id="$1"

    # numeric check
    if ! [[ "$device_id" =~ ^[0-9]+$ ]]; then
        echo "ERROR: --device must be a non-negative integer."
        exit 2
    fi

    # Check media device node exists
    if [[ ! -e "/dev/media${device_id}" ]]; then
        echo "ERROR: Media device /dev/media${device_id} not found."
        echo "Available media devices:"
        for m in /dev/media*; do
            [[ -e "$m" ]] || continue
            echo "  - $m"
        done
        exit 2
    fi
}

# Ensure the media device has at least one supported CRU camera entity
validate_cru_camera() {
    local device_id="$1"

    if ! media-ctl -d "/dev/media${device_id}" -p 2>/dev/null | grep -E -q "$(printf '%s|' "${SUPPORTED_MODELS[@]}" | sed 's/|$//')"; then
        echo "ERROR: /dev/media${device_id} does not appear to contain any supported cameras (${SUPPORTED_MODELS[*]})."
        echo "Inspect topology with:"
        echo "  media-ctl -d /dev/media${device_id} -p"
        exit 3
    fi
}

# Create media pipeline
create_pipeline() {
    local device_id="$1"
    local capture_width="$2"
    local capture_height="$3"
    local media_device="/dev/media${device_id}"

    # Find which camera is actually on this media device
    local selected_camera=""
    for cam in "${cameras[@]}"; do
        if [[ "$CAMERA_REQUEST" != auto && "$(get_cam_model "$cam")" != "$CAMERA_REQUEST" ]]; then
            continue
        fi
        if media-ctl -d "$media_device" -p 2>/dev/null | grep -q "$cam"; then
            selected_camera="$cam"
            break
        fi
    done

    if [[ -z "$selected_camera" ]]; then
        echo "ERROR: No supported camera found on $media_device"
        exit 1
    fi

    # Extract entity names from media-ctl -p output
    local device_csi2=$(media-ctl -d "$media_device" -p | grep -E "^- entity.*csi" | sed 's/.*: \([^ ]*\) .*/\1/')
    local device_cru=$(media-ctl -d "$media_device" -p | grep -E "^- entity.*cru-ip" | sed 's/.*: \([^ ]*\) .*/\1/')
    local cru_output="CRU output"

    echo "Using camera: $selected_camera"
    echo "Using CSI2: $device_csi2"
    echo "Using CRU: $device_cru"

    if [[ -z "$device_csi2" || -z "$device_cru" ]]; then
        echo "ERROR: Could not find CSI2 or CRU entities on $media_device"
        echo "Available entities:"
        media-ctl -d "$media_device" -p | grep -E "^- entity"
        exit 1
    fi

    # Get camera model for format lookup
    local cam_model=$(get_cam_model "$selected_camera")
    local pixfmt=${CAMERA_DEFAULT_FORMAT[$cam_model]}
    local resolution=$(check_resolution "$cam_model" "$capture_width" "$capture_height")

    local width=${resolution%x*}
    local height=${resolution#*x}

    echo "Using format: $pixfmt"
    echo "Using resolution: ${width}x${height}"

    MEDIA_DEV="$media_device"

    # Clear previous links
    media-ctl -d "$MEDIA_DEV" -r

    # Link pads
    echo "Setting up links..."
    media-ctl -d "$MEDIA_DEV" -l "'$selected_camera':0 -> '$device_csi2':0 [1]"
    media-ctl -d "$MEDIA_DEV" -l "'$device_csi2':1 -> '$device_cru':0 [1]"
    media-ctl -d "$MEDIA_DEV" -l "'$device_cru':1 -> '$cru_output':0 [1]"

    # Set formats
    echo "Setting up formats..."
    media-ctl -d "$MEDIA_DEV" -V "\"$selected_camera\":0 [fmt:${pixfmt}/${width}x${height} field:none colorspace:srgb]"
    media-ctl -d "$MEDIA_DEV" -V "\"$device_csi2\":0 [fmt:${pixfmt}/${width}x${height} field:none colorspace:srgb]"
    media-ctl -d "$MEDIA_DEV" -V "\"$device_csi2\":1 [fmt:${pixfmt}/${width}x${height} field:none colorspace:srgb]"
    media-ctl -d "$MEDIA_DEV" -V "\"$device_cru\":0 [fmt:${pixfmt}/${width}x${height} field:none colorspace:srgb]"
    media-ctl -d "$MEDIA_DEV" -V "\"$device_cru\":1 [fmt:${pixfmt}/${width}x${height} field:none colorspace:srgb]"

    echo "Pipeline successfully configured for ${width}x${height}"
}

#===============================================================================
# R-Car Gen4 boards (Sparrow-Hawk / V4H): libcamera based pipeline
#===============================================================================

# True when the media graph is sensor -> rcar_csi2 -> rcar_isp -> VIN
is_v4h_topology() {
    local topology="$1"
    [[ "$topology" == *rcar_csi2* && "$topology" == *rcar_isp* ]]
}

camera_model_from_line() {
    local line="$1"
    if [[ "$line" =~ (imx219|imx708) ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

# Pick the camera by name from `cam -l`: sets CAMERA_MODEL and CAMERA_NAME
# (the device tree path, e.g. /base/soc/i2c@e6508000/cam@10).  It does not
# depend on the /dev/video* numbering.
discover_libcamera() {
    have cam || die "cam is not installed (libcamera tools are required)"

    local listing
    listing="$(cam -l 2>&1 || true)"
    [[ -n "$listing" ]] || die "libcamera did not report any camera"

    local line model path
    while IFS= read -r line; do
        model="$(camera_model_from_line "$line" || true)"
        [[ -n "$model" ]] || continue
        if [[ "$CAMERA_REQUEST" != auto && "$model" != "$CAMERA_REQUEST" ]]; then
            continue
        fi
        path="$(sed -nE 's/.*\(([^()]*\/(sensor|cam)@[0-9a-fx]+)\).*/\1/p' <<<"$line" | head -n1)"
        [[ -n "$path" ]] || continue
        CAMERA_MODEL="$model"
        CAMERA_NAME="$path"
        return 0
    done <<<"$listing"

    if [[ "$CAMERA_REQUEST" == auto ]]; then
        die "no supported libcamera camera found (expected: ${V4H_CAMERAS})"
    fi
    printf 'ERROR: requested camera %q was not found; cam -l output:\n%s\n' \
        "$CAMERA_REQUEST" "$listing" >&2
    exit 1
}

set_default_size() {
    # imx708 is reliably exposed by the V4H pipeline at 2304x1296.  A
    # requested display size is applied after capture with videoscale; asking
    # libcamerasrc for an arbitrary 1920x1080 mode causes not-negotiated on
    # this pipeline.  imx219's tested native viewfinder mode is 1920x1080.
    if [[ "$CAMERA_MODEL" == imx708 ]]; then
        SOURCE_WIDTH=2304
        SOURCE_HEIGHT=1296
    else
        SOURCE_WIDTH=1920
        SOURCE_HEIGHT=1080
    fi

    WIDTH="${WIDTH:-$SOURCE_WIDTH}"
    HEIGHT="${HEIGHT:-$SOURCE_HEIGHT}"
    [[ "$WIDTH" =~ ^[0-9]+$ && "$HEIGHT" =~ ^[0-9]+$ ]] || die "width and height must be positive integers"
    (( WIDTH > 0 && HEIGHT > 0 )) || die "width and height must be greater than zero"
}

# An SSH shell does not inherit the Weston socket: look for it like the
# board's own session does when WAYLAND_DISPLAY is not set.
setup_wayland_env() {
    [[ -n "${WAYLAND_DISPLAY:-}" && -n "${XDG_RUNTIME_DIR:-}" ]] && return 0
    if [[ -S /run/user/1000/wayland-1 ]]; then
        export XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1
    elif [[ -S /run/wayland-0 ]]; then
        export XDG_RUNTIME_DIR=/run WAYLAND_DISPLAY=wayland-0
    else
        echo "WARNING: no Wayland socket found, set XDG_RUNTIME_DIR and WAYLAND_DISPLAY" >&2
    fi
}

# Build the GStreamer pipeline in the array "pipeline"
build_gst_pipeline() {
    pipeline=(gst-launch-1.0 -e -v
        libcamerasrc "camera-name=${CAMERA_NAME}" '!'
        "video/x-raw,format=BGRx,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT},framerate=30/1" '!'
        videoconvert)
    if [[ "$WIDTH" != "$SOURCE_WIDTH" || "$HEIGHT" != "$SOURCE_HEIGHT" ]]; then
        pipeline+=('!' videoscale '!'
            "video/x-raw,format=BGRx,width=${WIDTH},height=${HEIGHT}")
    fi
    pipeline+=('!')
    case "$SINK" in
        fakesink)
            (( FRAMES > 0 )) || FRAMES=5
            pipeline+=(fakesink "num-buffers=${FRAMES}" sync=false)
            ;;
        wayland) pipeline+=(waylandsink sync=false) ;;
        autovideosink) pipeline+=(autovideosink sync=false) ;;
        *) die "unsupported sink '$SINK' (use fakesink, wayland, or autovideosink)" ;;
    esac
}

run_v4h() {
    local topology="$1"

    discover_libcamera
    set_default_size
    echo "R-Car Gen4 camera: ${CAMERA_MODEL} (${CAMERA_NAME})"
    echo "Media graph: CSI2 -> ISP -> VIN (configured by libcamera; links left intact)"
    echo "Sensor stream: ${SOURCE_WIDTH}x${SOURCE_HEIGHT} BGRx @ 30 fps"
    echo "Requested stream: ${WIDTH}x${HEIGHT} BGRx @ 30 fps"

    if (( PRINT_GST == 1 || STREAM == 1 )); then
        local -a pipeline
        build_gst_pipeline
        echo "GStreamer pipeline: ${pipeline[*]}"
        if (( STREAM == 1 )); then
            have gst-launch-1.0 || die "gst-launch-1.0 is not installed"
            [[ "$SINK" == fakesink ]] || setup_wayland_env
            "${pipeline[@]}"
        fi
    fi
}

#===============================================================================
# Arguments and main
#===============================================================================

# Parse arguments
parse_shell_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --device)
                if [[ -z "${2:-}" ]]; then
                    echo "ERROR: --device requires a value."
                    print_usage
                    exit 1
                fi
                DEVICE_ID="$2"
                shift 2
                ;;
            --width)
                if [[ -z "${2:-}" ]]; then
                    echo "ERROR: --width requires a value."
                    print_usage
                    exit 1
                fi
                WIDTH="$2"
                shift 2
                ;;
            --height)
                if [[ -z "${2:-}" ]]; then
                    echo "ERROR: --height requires a value."
                    print_usage
                    exit 1
                fi
                HEIGHT="$2"
                shift 2
                ;;
            --camera)
                [[ -n "${2:-}" ]] || die "--camera requires a value"
                CAMERA_REQUEST="$2"
                shift 2
                ;;
            --sink)
                [[ -n "${2:-}" ]] || die "--sink requires a value"
                SINK="$2"
                shift 2
                ;;
            --frames)
                [[ -n "${2:-}" ]] || die "--frames requires a value"
                FRAMES="$2"
                shift 2
                ;;
            --stream)    STREAM=1; shift ;;
            --print-gst) PRINT_GST=1; shift ;;
            --help|-h)   print_usage; exit 0;;
            *)           echo "ERROR: Unknown parameter: $1"; print_usage; exit 1;;
        esac
    done

    [[ "$FRAMES" =~ ^[0-9]+$ ]] || die "--frames must be a non-negative integer"
}

main() {
    parse_shell_args "$@"

    validate_device_index "$DEVICE_ID"
    have media-ctl || die "media-ctl is not installed"

    local topology
    topology="$(media-ctl -d "/dev/media${DEVICE_ID}" -p 2>/dev/null || true)"

    if is_v4h_topology "$topology"; then
        set -u -o pipefail
        run_v4h "$topology"
    else
        if (( STREAM == 1 || PRINT_GST == 1 )); then
            die "--stream and --print-gst are only available on the R-Car Gen4 (V4H) topology"
        fi
        validate_cru_camera "$DEVICE_ID"
        create_pipeline "$DEVICE_ID" "${WIDTH:-$DEFAULT_CAPTURE_WIDTH}" "${HEIGHT:-$DEFAULT_CAPTURE_HEIGHT}"
    fi
}

# Main
main "$@"
