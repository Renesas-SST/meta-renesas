FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://aarch64-multiarch.conf \
    file://ldconfig.triggers \
"

do_install:append() {
    install -d ${D}${sysconfdir}/ld.so.conf.d
    install -m 0644 ${UNPACKDIR}/aarch64-multiarch.conf ${D}${sysconfdir}/ld.so.conf.d

    install -d ${D}${localstatedir}/lib/dpkg/info
    install -m 0644 ${UNPACKDIR}/ldconfig.triggers ${D}${localstatedir}/lib/dpkg/info
}

FILES:${PN} += "${sysconfdir}/ld.so.conf.d"
FILES:ldconfig += "${localstatedir}/lib/dpkg/info/ldconfig.triggers"
