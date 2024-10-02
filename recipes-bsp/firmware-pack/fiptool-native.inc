SECTION = "bootloaders"
SUMMARY = "Fiptool from Trusted Firmware-A"
LICENSE = "MIT"

inherit native

DEPENDS = "openssl-native"

# Set S variable point to Makefile 
S = "${WORKDIR}/git"

# Make args with option ${EXTRA_OEMAKE} 
EXTRA_OEMAKE:append:task-compile = "fiptool"

# Install fiptool to bindir folder
do_install () {
    install -d ${D}${bindir}
    install ${S}/tools/fiptool/fiptool ${D}${bindir}
}
