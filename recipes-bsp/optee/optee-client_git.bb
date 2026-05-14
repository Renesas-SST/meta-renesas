DESCRIPTION = "OP-TEE Client"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=69663ab153298557a59c67a60a743e5b"

PACKAGE_ARCH = "${MACHINE_ARCH}"

PV = "4.8.0+git${SRCPV}"
BRANCH = "master"
SRCREV = "9d6f69844ff60ec0966cf3659abcc38eda8b31ea"

SRC_URI = " \
    git://github.com/OP-TEE/optee_client.git;branch=${BRANCH};protocol=https \
    file://optee.service \
"

DEPENDS += "util-linux"

inherit python3native systemd

SYSTEMD_SERVICE:${PN} = "optee.service"
S = "${WORKDIR}/git"

EXTRA_OEMAKE = "RPMB_EMU=0 WITH_TEEACL=0"

do_install() {
    oe_runmake install \
        DESTDIR=${D} \
        SBINDIR=${sbindir} \
        LIBDIR=${libdir} \
        INCLUDEDIR=${includedir}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/optee.service ${D}${systemd_system_unitdir}/optee.service
}

RPROVIDES:${PN} += "optee-client"
FILES:${PN} += " \
    ${sbindir}/tee-supplicant \
    ${libdir}/libteec.so* \
    ${libdir}/libckteec.so* \
    ${libdir}/libseteec.so* \
    ${systemd_system_unitdir}/optee.service \
"
FILES:${PN}-dev += " \
    ${includedir}/tee_client_api.h \
    ${includedir}/teec_trace.h \
    ${includedir}/optee_client_config.mk \
    ${libdir}/libteec.a \
    ${libdir}/libckteec.a \
    ${libdir}/libseteec.a \
"
