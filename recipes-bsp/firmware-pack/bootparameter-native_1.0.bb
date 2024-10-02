SECTION = "bootloaders"
DESCRIPTION = "Application to create binaries in the correct format for rzg2l board flashing"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit native

# Set S variable point to source file bootparameter.c
S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = "file://bootparameter.c"

# Compile file source to module bootparameter
do_compile () {
    ${CC} bootparameter.c -o bootparameter
}

# Install module bootparamter to bindir folder
do_install () {
    install -d ${D}${bindir}
    install ${S}/bootparameter ${D}${bindir}
}
