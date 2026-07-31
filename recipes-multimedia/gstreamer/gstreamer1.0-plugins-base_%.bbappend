# g-ir-scanner fails to parse GLib/GStreamer headers in this V4H build while
# generating GstVideo GIR data. The image does not require GIR/typelib runtime
# data for GPU verification, so keep the GStreamer runtime/plugins and disable
# introspection only for rz-cmn.
GI_DATA_ENABLED:rz-cmn = "False"
GIR_MESON_ENABLE_FLAG:rz-cmn = "enabled"
GIR_MESON_DISABLE_FLAG:rz-cmn = "disabled"

# Mesa is the generic provider in the unified rz-cmn rootfs. Keep GBM visible
# through the virtual provider; the private PowerVR libraries are selected only
# at runtime on V4H.
DEPENDS:append:rz-cmn = " virtual/libgbm"
