# Full mesa is the generic EGL/GLES provider for the unified rz-cmn rootfs.
# Pull in virtual/egl so GL headers that include KHR/khrplatform.h resolve in
# recipe sysroots without depending on the private PowerVR vendor package.
DEPENDS:append:rz-cmn = " virtual/egl"
