# U-Boot environment for RZ SBC board

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://uEnv.txt \
    file://Readme.md \
"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

FILES:${PN} = "/boot"

do_install () {
    install -d ${D}/boot
    install -m 0644 ${S}/uEnv.txt ${D}/boot/uEnv.txt
    install -m 0644 ${S}/Readme.md ${D}/boot/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    install -d ${DEPLOYDIR}/target/env
    install -m 0644 ${D}/boot/uEnv.txt ${DEPLOYDIR}/target/env
    install -m 0644 ${D}/boot/Readme.md ${DEPLOYDIR}
}

# Force the package to be redeployed for each target. This is essential
# to ensure the Readme.md file is available in DEPLOYDIR, allowing it to be
# installed into partition 1.
# Without this, other targets may fail during the build process.
do_deploy[nostamp] = "1"

COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

