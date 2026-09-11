SUMMARY = "Murata Binaries"

# Murata module fitted on the board; selects the power-table source directory.
MURATA_MODULE ?= "1XK"

LICENSE = "BSD-2-Clause"

LIC_FILES_CHKSUM = "file://${S}/nxp-linux-calibration/LICENSE;md5=ffa10f40b98be2c2bc9608f56827ed23"

SRC_URI = " \
    git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=imx-6-1-1;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
    file://switch_module.sh \
"

SRCREV_nxp-linux-calibration="6103e224be638f5b421c323993f29bb6c0ada44a"

SRCREV_default = "${AUTOREV}"

S = "${UNPACKDIR}"
B = "${UNPACKDIR}"
DEPENDS = " libnl "

do_compile () {
    echo "Compiling: "
    echo "Testing Make        Display:: ${MAKE}"
    echo "Testing bindir      Display:: ${bindir}"
    echo "Testing base_libdir Display:: ${base_libdir}"
    echo "Testing sysconfdir  Display:: ${sysconfdir}"
    echo "Testing S  Display:: ${S}"
    echo "Testing B  Display:: ${B}"
    echo "Testing D  Display:: ${D}"
    echo "WORK_DIR :: ${WORKDIR}"
    echo "MACHINE TYPE :: ${MACHINE}"
    echo "PWD :: "
    pwd
}

DO_INSTALL_64BIT_BINARIES = "no"
DO_INSTALL_64BIT_BINARIES_mx6 = "no"
DO_INSTALL_64BIT_BINARIES_mx7 = "no"
DO_INSTALL_64BIT_BINARIES_mx8 = "yes"

do_install () {
    echo "Installing: "
    install -d ${D}/usr/sbin
    install -d ${D}/etc/udev/rules.d

    # Install the calibration tree as published with every module.
    # Adding a board or module needs no change here.
    install -d ${D}${nonarch_base_libdir}/firmware/nxp/murata
    cp -R --no-dereference --preserve=links \
        ${S}/nxp-linux-calibration/murata/files ${D}${nonarch_base_libdir}/firmware/nxp/murata/
    find ${D}${nonarch_base_libdir}/firmware/nxp/murata/files -type d -exec chmod 0755 {} +
    find ${D}${nonarch_base_libdir}/firmware/nxp/murata/files -type f -exec chmod 0444 {} +

    install -m 755 ${S}/switch_module.sh ${D}/usr/sbin/switch_module.sh
    install -m 755 ${S}/nxp-linux-calibration/murata/switch_regions.sh ${D}/usr/sbin/switch_regions.sh
    install -m 444 ${S}/nxp-linux-calibration/murata/README.txt ${D}${nonarch_base_libdir}/firmware/nxp/murata/README.txt

    # wifi_mod_para.conf and request_firmware both take these as is under nxp/.
    # Link the fitted module's binaries there.
    # MURATA_MODULE controls which module files are sourced.
    # rgpower_<CC> is the mwifiex name for the table files that moal reads as txpower_<CC>.
    for _rzsrc in ${D}${nonarch_base_libdir}/firmware/nxp/murata/files/${MURATA_MODULE}/*.bin; do
        _rzf=$(basename $_rzsrc)
        ln -sf murata/files/${MURATA_MODULE}/$_rzf ${D}${nonarch_base_libdir}/firmware/nxp/$_rzf
        case $_rzf in
        txpower_*)
            _rzrg=$(echo $_rzf | sed 's/^txpower_/rgpower_/')
            ln -sf murata/files/${MURATA_MODULE}/$_rzf ${D}${nonarch_base_libdir}/firmware/nxp/$_rzrg
            ;;
        esac
    done

    # README: TW uses the JP table on modules that dont have a txpower_TW.bin.
    if [ ! -e ${D}${nonarch_base_libdir}/firmware/nxp/txpower_TW.bin ]; then
        ln -sf murata/files/${MURATA_MODULE}/txpower_JP.bin ${D}${nonarch_base_libdir}/firmware/nxp/txpower_TW.bin
        ln -sf murata/files/${MURATA_MODULE}/txpower_JP.bin ${D}${nonarch_base_libdir}/firmware/nxp/rgpower_TW.bin
    fi
}

FILES:${PN} += "${nonarch_base_libdir}/firmware"
FILES:${PN} += "${nonarch_base_libdir}/firmware/*"
FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "{sysconfdir}/firmware"
FILES:${PN} += "${nonarch_base_libdir}"
FILES:${PN} += "{sysconfdir}/firmware/nxp"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata/files"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata/1XK"
#FILES:${PN} += "/usr/sbin/wpa_supplicant"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"
