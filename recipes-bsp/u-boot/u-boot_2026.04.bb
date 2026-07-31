require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc
require include/rz-optee-config.inc

PROVIDES += "u-boot"
DEPENDS += "lzop-native srecord-native bc-native dtc-native python3-pyelftools-native gnutls-native"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# u-boot source code repository
UBOOT_URL = "git://github.com/Renesas-SST/u-boot.git"
BRANCH = "styhead/rz-cmn"
SRC_URI = "${UBOOT_URL};name=machine;protocol=https;branch=${BRANCH}"
SRCREV_machine = "${AUTOREV}"

FILES:${PN} = "/boot ${sysconfdir}"

# Add the /boot directory to the target's sysroot
SYSROOT_DIRS += "/boot"

DEVICETREE_NAME:rz-cmn = " \
    rzg2l-sbc \
    smarc-rzg2l \
    smarc-rzv2l \
    rzv2h-evk-ver1 \
    rzv2h-rdk-ver1 \
    rs-g2l100 \
    imdt-v2h-sbc \
    sparrow-hawk \
"

# Install u-boot-nodtb.bin and u-boot device tree to temp location
do_install() {
    install -d ${D}/boot
    install -d ${D}/boot/dtbs

    install -m 644 ${KCONFIG_CONFIG_ROOTDIR}/u-boot-nodtb.bin ${D}/boot/
    for dtb_name in ${DEVICETREE_NAME}; do
        dtb_path=""
        for dtb_dir in \
            ${KCONFIG_CONFIG_ROOTDIR}/dts/upstream/src/arm64/renesas \
            ${KCONFIG_CONFIG_ROOTDIR}/arch/arm/dts; do
            if [ -f "${dtb_dir}/${dtb_name}.dtb" ]; then
                dtb_path="${dtb_dir}/${dtb_name}.dtb"
                break
            fi
        done

        if [ -z "${dtb_path}" ]; then
            bbfatal "U-Boot DTB ${dtb_name}.dtb was not built"
        fi
        install -m 644 "${dtb_path}" ${D}/boot/dtbs/
    done
}

do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}/target/images/u-boot/dtbs

    install -m 0644 ${D}/boot/u-boot-nodtb.bin ${DEPLOYDIR}/target/images/u-boot/u-boot-nodtb-${MACHINE}.bin
    for dtb_name in ${DEVICETREE_NAME}; do
        install -m 644 ${D}/boot/dtbs/${dtb_name}.dtb ${DEPLOYDIR}/target/images/u-boot/dtbs
    done

    if [ "${ENABLE_V4H_DIRECT_OPTEE}" = "1" ]; then
        if [ ! -s "${KCONFIG_CONFIG_ROOTDIR}/sa0.bin" ]; then
            bbfatal "V4H SA0+SPL image was not built"
        fi
        install -m 0644 ${KCONFIG_CONFIG_ROOTDIR}/sa0.bin \
            ${DEPLOYDIR}/target/images/u-boot/sa0.bin
    fi
}

addtask deploy after do_install
