SUMMARY = "NXP Wi-Fi driver for module 88w8801/8987/8997/9098 IW416/612"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

# For backwards compatibility
PROVIDES += "kernel-module-nxp89xx"
RREPLACES:${PN} = "kernel-module-nxp89xx"
RPROVIDES:${PN} = "kernel-module-nxp89xx"
RCONFLICTS:${PN} = "kernel-module-nxp89xx"

# For Kernel 5.4 and later
SRCBRANCH = "lf-6.12.49_2.2.0"
SRCREV = "${AUTOREV}"

MRVL_SRC ?= "git://github.com/nxp-imx/mwifiex.git;protocol=https"
SRC_URI = "${MRVL_SRC};branch=${SRCBRANCH};patchdir=${WORKDIR}/git"
S = "${WORKDIR}/git"

NXP_WLAN_PATHMAP_FLAGS = " \
    -fmacro-prefix-map=${STAGING_KERNEL_DIR}=/usr/src/kernel \
    -fmacro-prefix-map=${STAGING_KERNEL_BUILDDIR}=/usr/src/kernel \
"

EXTRA_OEMAKE:append = " \
    KCFLAGS='${NXP_WLAN_PATHMAP_FLAGS}' \
    KBUILD_EXTRA_CPPFLAGS='${NXP_WLAN_PATHMAP_FLAGS}' \
"

SRC_URI += " \
    file://moal.modprobe.conf \
    file://0001-moal-assign-per-instance-lockdep-class-to-moal_lock.patch \
    file://0002-moal-fix-cfg80211-scan-result-reporting-from-atomic-.patch \
"

inherit module

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_BUILDDIR} -C ${STAGING_KERNEL_BUILDDIR} M=${S}"

do_install:append() {
    install -dm 0755 ${D}${libdir}/modules-load.d
    echo "moal" > ${D}${libdir}/modules-load.d/10moal.conf
    echo "btnxpuart" > ${D}${libdir}/modules-load.d/20btnxpuart.conf

    install -dm 0755 ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${UNPACKDIR}/moal.modprobe.conf ${D}${sysconfdir}/modprobe.d/moal.conf
}

FILES:${PN} += " \
    ${libdir}/modules-load.d \
    ${libdir}/modules-load.d/10moal.conf \
    ${libdir}/modules-load.d/20btnxpuart.conf \
    ${sysconfdir}/modprobe.d/moal.conf \
"

RRECOMMENDS:${PN} = "wireless-tools"

