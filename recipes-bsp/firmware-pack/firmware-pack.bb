SECTION = "bootloaders"
SUMMARY = "Firmware Packaging"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = " trusted-firmware-a u-boot bootparameter-native fiptool-native"

S = "${WORKDIR}/sources"

# Create bin file and convert to srec file
do_compile () {

    # Create bl2_bp.bin
    bootparameter ${RECIPE_SYSROOT}/boot/bl2-${MACHINE}.bin bl2_bp.bin
    # Add for eSD boot image
    cp bl2_bp.bin bl2_bp_esd.bin

    cat ${RECIPE_SYSROOT}/boot/bl2-${MACHINE}.bin >> bl2_bp.bin

    # Create fip.bin
    fiptool create --align 16 --soc-fw ${RECIPE_SYSROOT}/boot/bl31-${MACHINE}.bin --nt-fw ${RECIPE_SYSROOT}/boot/u-boot.bin fip.bin

    # Convert to srec
    objcopy -I binary -O srec --adjust-vma=0x00011E00 --srec-forceS3 bl2_bp.bin bl2_bp.srec
    objcopy -I binary -O srec --adjust-vma=0x0000 --srec-forceS3 fip.bin fip.srec

}

# Install fip images to deploy folder
do_deploy () {
    # Create deploy folder
    install -d ${DEPLOYDIR}

    # Copy fip images
    install -m 0644 ${S}/bl2_bp.bin ${DEPLOYDIR}/bl2_bp-${MACHINE}.bin
    install -m 0644 ${S}/bl2_bp.srec ${DEPLOYDIR}/bl2_bp-${MACHINE}.srec
    install -m 0644 ${S}/fip.bin ${DEPLOYDIR}/fip-${MACHINE}.bin
    install -m 0644 ${S}/fip.srec ${DEPLOYDIR}/fip-${MACHINE}.srec

    # Copy fip image for eSD boot
    install -m 0644 ${S}/bl2_bp_esd.bin ${DEPLOYDIR}/bl2_bp_esd-${MACHINE}.bin

}

addtask deploy before do_build after do_compile

COMPATIBLE_MACHINE = "rzg2l-sbc"
