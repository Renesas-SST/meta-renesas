FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://aarch64-multiarch.conf \
"

do_install:append() {
    install -d ${D}${sysconfdir}/ld.so.conf.d
    install -m 0644 ${UNPACKDIR}/aarch64-multiarch.conf ${D}${sysconfdir}/ld.so.conf.d
}

FILES:${PN} += "${sysconfdir}/ld.so.conf.d"
