PACKAGECONFIG:append = " gstreamer alsa"

RDEPENDS:${PN}-plugins += " \
	gstreamer1.0 \
	gstreamer1.0-libav \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-base-app \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-good-video4linux2 \
	gstreamer1.0-plugins-bad \
	libgstbasecamerabinsrc-1.0 \
"
