# Add document and license to the folder in the build directory

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}"

SRC_URI = " \
    file://r12uz0158eu0101-rz-g2l-sbc-single-board-computer.pdf \
    file://RZG2L-SBC_Evaluation_license.pdf \
    file://Disclaimer051.pdf \
    file://Disclaimer052.pdf \
"

FILES_${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/r12uz0158eu0101-rz-g2l-sbc-single-board-computer.pdf ${D}/util/r12uz0158eu0101-rz-g2l-sbc-single-board-computer.pdf
    install -m 0644 ${S}/RZG2L-SBC_Evaluation_license.pdf ${D}/util/RZG2L-SBC_Evaluation_license.pdf

    # Disclaimer files
    install -m 0644 ${S}/Disclaimer051.pdf ${D}/util/Disclaimer051.pdf
    install -m 0644 ${S}/Disclaimer052.pdf ${D}/util/Disclaimer052.pdf
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    # Install the user guide into the build folder
    install -d ${DEPLOYDIR}/
    install -m 0644 ${D}/util/r12uz0158eu0100-rz-g2l-sbc-single-board-computer.pdf ${DEPLOYDIR}/
    install -m 0644 ${D}/util/RZG2L-SBC_Evaluation_license.pdf ${DEPLOYDIR}/

    # Install license files into the license folder in the build
    install -d ${DEPLOYDIR}/license
    install -m 0644 ${D}/util/Disclaimer051.pdf ${DEPLOYDIR}/license
    install -m 0644 ${D}/util/Disclaimer052.pdf ${DEPLOYDIR}/license
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

