RZ_MMP_PACKAGES = " \
    packagegroup-gstreamer1.0-plugins \
    packagegroup-multimedia-libs \
    packagegroup-multimedia-kernel-modules \
    packagegroup-wayland-community \
    kmscube \
    glmark2 \
    apitrace \
"

# Only append to IMAGE_INSTALL if RZ_FEATURE_CODEC is set to "True"
IMAGE_INSTALL:append = " ${@oe.utils.conditional('RZ_FEATURE_CODEC', 'True', '${RZ_MMP_PACKAGES}', '', d)}"
