LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
LICENSE="BSD-3-Clause"
PV = "1.06+git${SRCPV}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

ENABLE_SPD_OPTEE	?= '0'

# Enable hardware crypt IP(SCE) driver in OP-TEE OS
ENABLE_RZ_SCE		?= '0'

FLASH_WRITER_URL = "git://github.com/Renesas-SST/flash-writer.git"
BRANCH = "styhead/rz-cmn"
SRC_URI = "${FLASH_WRITER_URL};name=rzg2l-sbc;subdir=rzg2l-sbc;protocol=https;branch=${BRANCH} \
			${FLASH_WRITER_URL};name=rzg2l-evk;subdir=rzg2l-evk;protocol=https;branch=${BRANCH} \
			${FLASH_WRITER_URL};name=rzv2l-evk;subdir=rzv2l-evk;protocol=https;branch=${BRANCH} \
			file://Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot \
"
SRCREV_rzg2l-sbc = "8e5919a314673217d93dbb34227b8c22d71d681b"
SRCREV_rzg2l-evk = "ff167b676547f3997906c82c9be504eb5cff8ef0"
SRCREV_rzv2l-evk = "ff167b676547f3997906c82c9be504eb5cff8ef0"

SRCREV_FORMAT = "rzg2l-sbc_rzg2l-evk_rzv2l-evk"

inherit deploy
#require include/provisioning.inc

S = "${WORKDIR}/git"
UNPACKDIR = "${S}"

do_compile() {
	for target in ${SUPPORT_TARGETS}; do
		PMIC_BUILD_DIR="${S}/${target}/build_pmic"
		if [ ${target} = "rzv2h-evk" ]; then
			continue;
		elif [ ${target} = "rzg2l-sbc" ]; then
			BOARD="RZG2L_SBC"
			PMIC_BOARD="RZG2L_SMARC_PMIC"
		elif [ ${target} = "rzg2l-evk" ]; then
			BOARD="RZG2L_SMARC_PMIC"
			PMIC_BOARD="RZG2L_SMARC_PMIC"
		elif [ ${target} = "rzv2l-evk" ]; then
			BOARD="RZV2L_SMARC"
			PMIC_BOARD="RZV2L_SMARC_PMIC"
		fi
		cd ${S}/${target}
		oe_runmake BOARD=${BOARD}
		if [ "${PMIC_SUPPORT}" = "1" ]; then
			oe_runmake OUTPUT_DIR=${PMIC_BUILD_DIR} clean
			oe_runmake BOARD=${PMIC_BOARD} OUTPUT_DIR=${PMIC_BUILD_DIR}
		fi
		mv ${S}/${target}/AArch64_output/Flash_Writer*${BOARD}*.mot ${S}/${target}/AArch64_output/Flash_Writer_SCIF_${target}.mot
		mv ${PMIC_BUILD_DIR}/Flash_Writer*${PMIC_BOARD}*.mot ${PMIC_BUILD_DIR}/Flash_Writer_SCIF_${target}_PMIC.mot
	done
}

do_install[noexec] = "1"

do_deploy() {
	install -d ${DEPLOYDIR}/target/images
	for target in ${SUPPORT_TARGETS}; do
		if [ ${target} = "rzv2h-evk" ]; then
			continue;
		fi
		PMIC_BUILD_DIR="${S}/${target}/build_pmic"
		install -m 644 ${S}/${target}/AArch64_output/*.mot ${DEPLOYDIR}/target/images
		if [ "${PMIC_SUPPORT}" = "1" ]; then
			install -m 644 ${PMIC_BUILD_DIR}/*.mot ${DEPLOYDIR}/target/images
		fi
	done
	install -m 644 ${S}/Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot ${DEPLOYDIR}/target/images
}

PARALLEL_MAKE = "-j 1"
addtask deploy after do_compile
