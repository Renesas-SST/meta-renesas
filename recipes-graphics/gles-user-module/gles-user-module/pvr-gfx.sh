#!/bin/sh

# Export the same PowerVR environment for interactive login shells on V4H.
# Non-V4H boards keep Mesa because no environment file is generated for them.
# Source /run/pvr-gfx.env explicitly in non-interactive SSH commands.
pvr_gfx_is_pvr_board()
{
    if [ -r /proc/device-tree/model ] && tr '\0' '\n' < /proc/device-tree/model | grep -Eiq 'sparrow|v4h|r8a779g'; then
        return 0
    fi

    if [ -r /proc/device-tree/compatible ] && tr '\0' '\n' < /proc/device-tree/compatible | grep -Eq 'renesas,r8a779g|renesas,r8a779g0'; then
        return 0
    fi

    for compat in $(find /proc/device-tree -name compatible -type f 2>/dev/null); do
        if tr '\0' '\n' < "$compat" | grep -qx 'renesas,gsx'; then
            return 0
        fi
    done

    return 1
}

if [ -r /run/pvr-gfx.env ]; then
    # shellcheck disable=SC1091
    . /run/pvr-gfx.env
elif pvr_gfx_is_pvr_board && [ -r /usr/lib/pvr/libEGL.so.1 ]; then
    LD_LIBRARY_PATH=/usr/lib/pvr
    [ -r /usr/share/pvr/vulkan/icd.d/powervr_icd.json ] && VK_ICD_FILENAMES=/usr/share/pvr/vulkan/icd.d/powervr_icd.json
    [ -d /usr/share/pvr/OpenCL/vendors ] && OCL_ICD_VENDORS=/usr/share/pvr/OpenCL/vendors
fi

export LD_LIBRARY_PATH
[ -n "${VK_ICD_FILENAMES:-}" ] && export VK_ICD_FILENAMES
[ -n "${OCL_ICD_VENDORS:-}" ] && export OCL_ICD_VENDORS
