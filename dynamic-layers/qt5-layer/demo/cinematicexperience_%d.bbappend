FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
	file://0001-Add-exit-button-for-cinematic-demo.patch \
	file://exit.png \
"

do_install:append() {
	install ${UNPACKDIR}/exit.png ${D}${datadir}/${P}/content/images
}
