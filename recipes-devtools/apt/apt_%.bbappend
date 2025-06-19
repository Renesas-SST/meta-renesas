# Modifies the do_install:append:class-target function
# of the original apt recipe to define arm64 architecture

do_install:append:class-target() {
    if ! grep -q 'APT::Architecture "arm64";' ${D}${sysconfdir}/apt/apt.conf; then
        echo 'APT::Architecture "arm64";' > ${D}${sysconfdir}/apt/apt.conf
    fi
}
