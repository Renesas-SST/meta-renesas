IMAGE_INSTALL:append = " \
	packagegroup-gstreamer1.0-plugins \
	packagegroup-wayland-community \
"
# For GPU testing purposes
IMAGE_INSTALL:append = " kmscube glmark2 apitrace"
