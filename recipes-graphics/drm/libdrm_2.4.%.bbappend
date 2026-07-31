FILESEXTRAPATHS:prepend:rz-cmn := "${THISDIR}/${PN}:"

SRC_URI:append:rz-cmn = " \
    file://0001-Add-sync_fence_info-and-sync_pt_info.patch \
    file://Add-libkms.patch \
"

PACKAGES:prepend:rz-cmn = "${PN}-kms "

# libkms handling — TARGET ONLY, via EXTRA_OEMESON (NOT PACKAGECONFIG).
# Add-libkms.patch re-adds the libkms meson option (removed from upstream
# libdrm) and is only in SRC_URI:append:rz-cmn, so it does NOT apply to
# libdrm-native. Using a PACKAGECONFIG[libkms] flag would emit -Dlibkms on
# native too (against an unpatched tree -> "Unknown options: libkms"), and a
# :rz-cmn-overridden flag trips styhead's invalid-packageconfig QA. Passing
# the meson option directly, scoped to class-target + rz-cmn, avoids both.
EXTRA_OEMESON:append:class-target:rz-cmn = " -Dlibkms=enabled"

FILES:${PN}-kms:rz-cmn = "${libdir}/libkms*.so.*"
