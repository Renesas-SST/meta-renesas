# Add Readme file to the target folder in the build directory

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://Readme.md \
    file://env/Readme.md \
    file://images/Readme.md \
    file://images/dtbs/Readme.md \
    file://images/dtbs/overlays/Readme.md \
    file://images/rootfs/Readme.md"

FILES_${PN} += "/target"

do_install () {
    install -d ${D}/target
    install -d ${D}/target/env
    install -d ${D}/target/images/dtbs/overlays
    install -d ${D}/target/images/rootfs

    install -m 0644 ${S}/Readme.md ${D}/target/Readme.md
    install -m 0644 ${S}/env/Readme.md ${D}/target/env/Readme.md
    install -m 0644 ${S}/images/Readme.md ${D}/target/images/Readme.md
    install -m 0644 ${S}/images/dtbs/Readme.md ${D}/target/images/dtbs/Readme.md
    install -m 0644 ${S}/images/dtbs/overlays/Readme.md ${D}/target/images/dtbs/overlays/Readme.md
    install -m 0644 ${S}/images/rootfs/Readme.md ${D}/target/images/rootfs/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    # Install Readme files in their respective locations

    install -d ${DEPLOYDIR}/target
    install -d ${DEPLOYDIR}/target/env
    install -d ${DEPLOYDIR}/target/images/dtbs/overlays
    install -d ${DEPLOYDIR}/target/images/rootfs

    install -m 0644 ${D}/target/Readme.md ${DEPLOYDIR}/target/Readme.md
    install -m 0644 ${D}/target/env/Readme.md ${DEPLOYDIR}/target/env/Readme.md
    install -m 0644 ${D}/target/images/Readme.md ${DEPLOYDIR}/target/images/Readme.md
    install -m 0644 ${D}/target/images/dtbs/Readme.md ${DEPLOYDIR}/target/images/dtbs/Readme.md
    install -m 0644 ${D}/target/images/dtbs/overlays/Readme.md ${DEPLOYDIR}/target/images/dtbs/overlays/Readme.md
    install -m 0644 ${D}/target/images/rootfs/Readme.md ${DEPLOYDIR}/target/images/rootfs/Readme.md
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
