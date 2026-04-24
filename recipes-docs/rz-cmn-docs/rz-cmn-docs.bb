# Add document and license to the folder in the build directory

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://r11qs0072eu0310-rz-cmn-srp-um-quick-start-guide.pdf \
    file://r12uz0204eu0310-rz-cmn-srp-um.pdf \
    file://RZ_System_Release_Package_Evaluation_license.pdf \
    file://Disclaimer051.pdf \
"

FILES:${PN} += "/util"

do_install () {
    install -d ${D}/util
    install -m 0644 ${S}/r11qs0072eu0310-rz-cmn-srp-um-quick-start-guide.pdf ${D}/util/r11qs0072eu0310-rz-cmn-srp-um-quick-start-guide.pdf
    install -m 0644 ${S}/r12uz0204eu0310-rz-cmn-srp-um.pdf ${D}/util/r12uz0204eu0310-rz-cmn-srp-um.pdf
    install -m 0644 ${S}/RZ_System_Release_Package_Evaluation_license.pdf ${D}/util/RZ_System_Release_Package_Evaluation_license.pdf

    # Disclaimer files
    install -m 0644 ${S}/Disclaimer051.pdf ${D}/util/Disclaimer051.pdf
}

inherit deploy
addtask deploy after do_install

do_deploy () {
    # Install the user guide into the build folder
    install -d ${DEPLOYDIR}/
    install -m 0644 ${D}/util/r11qs0072eu0310-rz-cmn-srp-um-quick-start-guide.pdf ${DEPLOYDIR}/
    install -m 0644 ${D}/util/r12uz0204eu0310-rz-cmn-srp-um.pdf ${DEPLOYDIR}/
    install -m 0644 ${D}/util/RZ_System_Release_Package_Evaluation_license.pdf ${DEPLOYDIR}/

    # Install license files into the license folder in the build
    install -d ${DEPLOYDIR}/license
    install -m 0644 ${D}/util/Disclaimer051.pdf ${DEPLOYDIR}/license
}

COMPATIBLE_MACHINE = "(rz-cmn)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
