SECTION = "bootloaders"
SUMMARY = "Firmware Packaging"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = " trusted-firmware-a u-boot bootparameter-native fiptool-native bptool-native"

S = "${WORKDIR}/sources"

# Create bin file and convert to srec file
do_compile () {
    for target in ${SUPPORT_TARGETS}; do
        if [ ${target} = "rzv2h-evk" ]; then
            # Create bl2_bp.bin esd
            bptool ${RECIPE_SYSROOT}/boot/bl2-${target}.bin bp.bin 0x08103000 esd
            cat bp.bin ${RECIPE_SYSROOT}/boot/bl2-${target}.bin > bl2_bp_esd_${target}.bin
            objcopy -I binary -O srec --adjust-vma=0x08101E00 --srec-forceS3 bl2_bp_esd_${target}.bin bl2_bp_esd_${target}.srec

            # Create bl2_bp.bin spi
            bptool ${RECIPE_SYSROOT}/boot/bl2-${target}.bin bp.bin 0x08103000 spi
            cat bp.bin ${RECIPE_SYSROOT}/boot/bl2-${target}.bin > bl2_bp_spi_${target}.bin
            objcopy -I binary -O srec --adjust-vma=0x08101E00 --srec-forceS3 bl2_bp_spi_${target}.bin bl2_bp_spi_${target}.srec

            # Create bl2_bp.bin mmc
            bptool ${RECIPE_SYSROOT}/boot/bl2-${target}.bin bp.bin 0x08103000 mmc
            cat bp.bin ${RECIPE_SYSROOT}/boot/bl2-${target}.bin > bl2_bp_mmc_${target}.bin
            objcopy -I binary -O srec --adjust-vma=0x08101E00 --srec-forceS3 bl2_bp_mmc_${target}.bin bl2_bp_mmc_${target}.srec

            # Create fip.bin
            fiptool create --align 16 --soc-fw ${RECIPE_SYSROOT}/boot/bl31-${target}.bin --nt-fw ${RECIPE_SYSROOT}/boot/u-boot.bin fip_${target}.bin
            objcopy -I binary -O srec --adjust-vma=0x0000 --srec-forceS3 fip_${target}.bin fip_${target}.srec
            continue
        fi
        # Create bl2_bp.bin
        bootparameter ${RECIPE_SYSROOT}/boot/bl2-${target}.bin bl2_bp_${target}.bin
        # Add for eSD boot image
        cp bl2_bp_${target}.bin bl2_bp_esd_${target}.bin

        cat ${RECIPE_SYSROOT}/boot/bl2-${target}.bin >> bl2_bp_${target}.bin

        # Create fip.bin
        fiptool create --align 16 --soc-fw ${RECIPE_SYSROOT}/boot/bl31-${target}.bin --nt-fw ${RECIPE_SYSROOT}/boot/u-boot.bin fip_${target}.bin

        # Convert to srec
        objcopy -I binary -O srec --adjust-vma=0x00011E00 --srec-forceS3 bl2_bp_${target}.bin bl2_bp_${target}.srec
        objcopy -I binary -O srec --adjust-vma=0x0000 --srec-forceS3 fip_${target}.bin fip_${target}.srec
    done
}

# Install fip images to deploy folder
do_deploy () {
    # Create deploy folder
    install -d ${DEPLOYDIR}/target/images

    install -m 0644 ${S}/*.srec ${DEPLOYDIR}/target/images/
    install -m 0644 ${S}/*.bin ${DEPLOYDIR}/target/images/

    rm ${DEPLOYDIR}/target/images/bp.bin

}

addtask deploy before do_build after do_compile

COMPATIBLE_MACHINE = "rz-cmn"
