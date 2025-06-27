SUMMARY = "Support scripts for flashing rz-cmn"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

URL = "git://github.com/Renesas-SST/rz-utils.git"
BRANCH = "rz-utils-init"
SRCREV = "${AUTOREV}"

SRC_URI = "${URL};protocol=https;branch=${BRANCH}"

S = "${WORKDIR}/git/universal-scripts/host"

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}/host
    cp -r ${S}/* ${DEPLOYDIR}/host
}

addtask deploy after do_compile before do_build
