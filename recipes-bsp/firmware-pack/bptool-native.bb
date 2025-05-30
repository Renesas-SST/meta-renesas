SECTION = "bootloaders"
SUMMARY = "Application to create binaries in the correct format for RZV2H board"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"

URL = "git://github.com/vudangRVC/rz-atf-sst.git"
BRANCH = "dev-rzv2h"
SRCREV = "${AUTOREV}"

SRC_URI = "${URL};protocol=https;branch=${BRANCH}"

inherit native

DEPENDS = "openssl-native"

# Set S variable point to Makefile 
S = "${WORKDIR}/git"
B = "${S}/tools/renesas/rz_boot_param"

# Make args with option ${EXTRA_OEMAKE} 
EXTRA_OEMAKE:append:task-compile = "DEST_OFFSET_ADR=0x08103000 bptool"

# Install fiptool to bindir folder
do_install () {
    install -d ${D}${bindir}
    install ${S}/tools/renesas/rz_boot_param/bptool ${D}${bindir}
}
