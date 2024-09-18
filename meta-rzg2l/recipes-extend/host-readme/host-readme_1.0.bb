# Add Readme file to the host folder in the build directory

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://Readme.md \
    file://tools/Readme.md \
    file://env/Readme.md \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util/tools
    install -d ${D}/util/env

    install -m 0644 ${S}/Readme.md ${D}/util/Readme.md
    install -m 0644 ${S}/tools/Readme.md ${D}/util/tools/Readme.md
    install -m 0644 ${S}/env/Readme.md ${D}/util/env/Readme.md
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    # Install Readme files in their respective locations
    install -d ${DEPLOYDIR}/host/tools
    install -d ${DEPLOYDIR}/host/env

    install -m 0644 ${D}/util/Readme.md ${DEPLOYDIR}/host
    install -m 0644 ${D}/util/tools/Readme.md ${DEPLOYDIR}/host/tools
    install -m 0644 ${D}/util/env/Readme.md ${DEPLOYDIR}/host/env
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
