# Full mesa is the generic EGL/GLES provider for the unified rz-cmn rootfs.
# libepoxy needs KHR/EGL headers at build time, so depend on the selected
# virtual provider instead of the private PowerVR package.
DEPENDS:append:rz-cmn = " virtual/egl"
