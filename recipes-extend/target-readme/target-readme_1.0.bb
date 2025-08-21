# Add Readme file to the target folder in the build directory

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://Readme.md \
    file://env/Readme.md \
    file://images/Readme.md \
    file://images/linux/Readme.md \
    file://images/linux/dtbs/Readme.md \
    file://images/linux/dtbs/overlays/Readme.md \
    file://images/u-boot/Readme.md \
    file://images/u-boot/dtbs/Readme.md \
    file://images/atf/Readme.md \
    file://images/atf/fdts/Readme.md \
    file://images/rootfs/Readme.md"

FILES:${PN} += "/target"

do_install () {
    install -d ${D}/target
    install -d ${D}/target/env
    install -d ${D}/target/images/linux/dtbs/overlays
    install -d ${D}/target/images/u-boot/dtbs
    install -d ${D}/target/images/atf/fdts
    install -d ${D}/target/images/rootfs

    install -m 0644 ${S}/Readme.md ${D}/target/Readme.md
    install -m 0644 ${S}/env/Readme.md ${D}/target/env/Readme.md
    install -m 0644 ${S}/images/Readme.md ${D}/target/images/Readme.md
    install -m 0644 ${S}/images/linux/Readme.md ${D}/target/images/linux/Readme.md
    install -m 0644 ${S}/images/linux/dtbs/Readme.md ${D}/target/images/linux/dtbs/Readme.md
    install -m 0644 ${S}/images/linux/dtbs/overlays/Readme.md ${D}/target/images/linux/dtbs/overlays/Readme.md
    install -m 0644 ${S}/images/u-boot/Readme.md ${D}/target/images/u-boot/Readme.md
    install -m 0644 ${S}/images/u-boot/dtbs/Readme.md ${D}/target/images/u-boot/dtbs/Readme.md
    install -m 0644 ${S}/images/atf/Readme.md ${D}/target/images/atf/Readme.md
    install -m 0644 ${S}/images/atf/fdts/Readme.md ${D}/target/images/atf/fdts/Readme.md
    install -m 0644 ${S}/images/rootfs/Readme.md ${D}/target/images/rootfs/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    # Install Readme files in their respective locations

    install -d ${DEPLOYDIR}/target
    install -d ${DEPLOYDIR}/target/env
    install -d ${DEPLOYDIR}/target/images/linux/dtbs/overlays
    install -d ${DEPLOYDIR}/target/images/u-boot/dtbs
    install -d ${DEPLOYDIR}/target/images/atf/fdts
    install -d ${DEPLOYDIR}/target/images/rootfs

    install -m 0644 ${D}/target/Readme.md ${DEPLOYDIR}/target/Readme.md
    install -m 0644 ${D}/target/env/Readme.md ${DEPLOYDIR}/target/env/Readme.md
    install -m 0644 ${D}/target/images/Readme.md ${DEPLOYDIR}/target/images/Readme.md
    install -m 0644 ${D}/target/images/linux/Readme.md ${DEPLOYDIR}/target/images/linux/Readme.md
    install -m 0644 ${D}/target/images/linux/dtbs/Readme.md ${DEPLOYDIR}/target/images/linux/dtbs/Readme.md
    install -m 0644 ${D}/target/images/linux/dtbs/overlays/Readme.md ${DEPLOYDIR}/target/images/linux/dtbs/overlays/Readme.md
    install -m 0644 ${D}/target/images/u-boot/Readme.md ${DEPLOYDIR}/target/images/u-boot/Readme.md
    install -m 0644 ${D}/target/images/u-boot/dtbs/Readme.md ${DEPLOYDIR}/target/images/u-boot/dtbs/Readme.md
    install -m 0644 ${D}/target/images/atf/Readme.md ${DEPLOYDIR}/target/images/atf/Readme.md
    install -m 0644 ${D}/target/images/atf/fdts/Readme.md ${DEPLOYDIR}/target/images/atf/fdts/Readme.md
    install -m 0644 ${D}/target/images/rootfs/Readme.md ${DEPLOYDIR}/target/images/rootfs/Readme.md
}

COMPATIBLE_MACHINE = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
