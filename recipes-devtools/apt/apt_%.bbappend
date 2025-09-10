# Modifies the do_install:append:class-target function
# of the original apt recipe to define arm64 architecture

do_install:append:class-target() {
    if ! grep -q 'APT::Architecture "arm64";' ${D}${sysconfdir}/apt/apt.conf; then
        echo 'APT::Architecture "arm64";' > ${D}${sysconfdir}/apt/apt.conf
    fi
}

# Move the libapt-private library to ${D}${libdir}/aarch64-linux-gnu
# to follow the structure of APT 3.1.5 in the Ubuntu repo
do_install:append:class-target() {
    install -d ${D}${libdir}/aarch64-linux-gnu
    mv ${D}${libdir}/libapt-private.so.0.0.0 ${D}${libdir}/aarch64-linux-gnu/
    mv ${D}${libdir}/libapt-pkg.so.6.0.0 ${D}${libdir}/aarch64-linux-gnu/

    rm ${D}${libdir}/libapt-private.so.0.0 ${D}${libdir}/libapt-pkg.so.6.0

    ln -s aarch64-linux-gnu/libapt-private.so.0.0.0 ${D}${libdir}/libapt-private.so.0.0
    ln -s aarch64-linux-gnu/libapt-pkg.so.6.0.0 ${D}${libdir}/libapt-pkg.so.6.0
}

PACKAGES =+ "${PN}-lib"
FILES:${PN}-lib = "${libdir}/aarch64-linux-gnu/libapt-private.so.0.0.0 \
                ${libdir}/aarch64-linux-gnu/libapt-pkg.so.6.0.0"
RDEPENDS_${PN} += "${PN}-lib"
