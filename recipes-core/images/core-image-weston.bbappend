require include/core-image-renesas-base.inc
require include/core-image-bsp.inc
require include/core-image-renesas-mmp.inc
require include/core-image-renesas-sbc.inc

# PowerVR (Renesas GSX) userspace GPU stack for rz-cmn (Sparrow Hawk / V4H):
# the proprietary libEGL/libGLESv2 + wayland-kms/wsegl + libgbm libraries.
IMAGE_INSTALL:append:rz-cmn = " packagegroup-renesas-graphics"
