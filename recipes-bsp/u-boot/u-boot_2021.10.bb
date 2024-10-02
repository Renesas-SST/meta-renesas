require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc

PROVIDES += "u-boot"
DEPENDS += "bc-native dtc-native"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

UBOOT_URL:rzg2l-sbc = "git://github.com/Renesas-SST/u-boot.git"
SRC_URI:rzg2l-sbc = "${UBOOT_URL};name=machine;protocol=https;branch=${BRANCH}"
BRANCH:rzg2l-sbc = "styhead/rz-sbc"
SRCREV_machine:rzg2l-sbc = "${AUTOREV}"

FILES:${PN} = "/boot ${sysconfdir}"

# Add the /boot directory to the target's sysroot
SYSROOT_DIRS += "/boot"

# Define the U-Boot srec file name format
UBOOT_SREC_SUFFIX = "srec"
UBOOT_SREC ?= "u-boot-elf.${UBOOT_SREC_SUFFIX}"
UBOOT_SREC_IMAGE ?= "u-boot-elf-${MACHINE}-${PV}-${PR}.${UBOOT_SREC_SUFFIX}"
UBOOT_SREC_SYMLINK ?= "u-boot-elf-${MACHINE}.${UBOOT_SREC_SUFFIX}"

# Copy the U-Boot file to the deployment directory and create symbolic links to easily access this file with a simpler name.
do_deploy:append() {
     # UBOOT_CONFIG variable is name folder stored uboot srec files. It's defined in rzg2l-sbc.conf
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    install -m 644 ${B}/${config}/${UBOOT_SREC} ${DEPLOYDIR}/u-boot-elf-${type}-${PV}-${PR}.${UBOOT_SREC_SUFFIX}
                    cd ${DEPLOYDIR}
                    ln -sf u-boot-elf-${type}-${PV}-${PR}.${UBOOT_SREC_SUFFIX} u-boot-elf-${type}.${UBOOT_SREC_SUFFIX}
                fi
            done
            unset j
        done
        unset i
    else
        install -m 644 ${B}/${UBOOT_SREC} ${DEPLOYDIR}/${UBOOT_SREC_IMAGE}
        cd ${DEPLOYDIR}
        rm -f ${UBOOT_SREC} ${UBOOT_SREC_SYMLINK}
        ln -sf ${UBOOT_SREC_IMAGE} ${UBOOT_SREC_SYMLINK}
        ln -sf ${UBOOT_SREC_IMAGE} ${UBOOT_SREC}
    fi
}

