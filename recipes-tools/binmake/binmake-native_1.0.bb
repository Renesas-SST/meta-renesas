SUMMARY = "Binmake tool to create platform info binaries file"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

URL = "git://github.com/vudangRVC/rz-utility.git"
BRANCH = "main"
SRCREV = "${AUTOREV}"

SRC_URI = "${URL};protocol=https;branch=${BRANCH}"

S = "${WORKDIR}/git/tools/binmake"
B = "${WORKDIR}/build"

inherit cmake native

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/binmake ${D}${bindir}/binmake
}
