LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
LICENSE="BSD-3-Clause"
PV = "1.06+git${SRCPV}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

ENABLE_SPD_OPTEE	?= '0'

# Enable hardware crypt IP(SCE) driver in OP-TEE OS
ENABLE_RZ_SCE		?= '0'

# flash-writer source code repository
FLASH_WRITER_URL = "git://github.com/Renesas-SST/flash-writer.git"
BRANCH = "styhead/rz-cmn"
SRC_URI = "${FLASH_WRITER_URL};protocol=https;branch=${BRANCH}"
SRCREV = "${AUTOREV}"

inherit deploy
#require include/provisioning.inc

S = "${WORKDIR}/git"
B = "${S}/../build/${DISTRO}"
UNPACKDIR = "${S}"

do_prepare_src() {
	for target in ${SUPPORT_TARGETS}; do
		mkdir -p ${B}/${target}
		cp -r ${S}/git/* ${B}/${target}
	done
}

do_compile() {
	for target in ${SUPPORT_TARGETS}; do
		# Need to reset every iteration
		PMIC_BOARD=""
		PMIC_BUILD_DIR="${B}/${target}/build_pmic"

		if [ "${target}" = "rzv2h-evk" ] || [ "${target}" = "rzv2h-rdk" ] || [ "${target}" = "imdt-v2h-sbc" ]; then
			BOARD="RZV2H_DEV"
		elif [ "${target}" = "rzg2l-sbc" ]; then
			BOARD="RZG2L_SBC"
		elif [ "${target}" = "rs-g2l100" ]; then
			BOARD="RZG2L_15MMSQ_DEV"
		elif [ "${target}" = "rzg2l-evk" ]; then
			BOARD="RZG2L_SMARC"
			PMIC_BOARD="RZG2L_SMARC_PMIC"
		elif [ "${target}" = "rzv2l-evk" ]; then
			BOARD="RZV2L_SMARC"
			PMIC_BOARD="RZV2L_SMARC_PMIC"
		fi

		cd ${B}/${target}
		oe_runmake BOARD=${BOARD}

		# Rename base artifact
		mv ${B}/${target}/AArch64_output/Flash_Writer*${BOARD}*.mot ${B}/${target}/AArch64_output/Flash_Writer_SCIF_${target}.mot

		# Build PMIC only when enabled and have PMIC_BOARD variable set
		if [ "${PMIC_SUPPORT}" = "1" ] && [ -n "${PMIC_BOARD}" ]; then
				oe_runmake OUTPUT_DIR=${PMIC_BUILD_DIR} clean
				oe_runmake BOARD=${PMIC_BOARD} OUTPUT_DIR=${PMIC_BUILD_DIR}

				mv ${PMIC_BUILD_DIR}/Flash_Writer*${PMIC_BOARD}*.mot ${PMIC_BUILD_DIR}/Flash_Writer_SCIF_${target}_PMIC.mot
		fi
	done
}

do_install[noexec] = "1"


do_deploy() {
	install -d "${DEPLOYDIR}/target/images"
	for target in ${SUPPORT_TARGETS}; do
		PMIC_BUILD_DIR="${B}/${target}/build_pmic"

		base_out="${B}/${target}/AArch64_output/Flash_Writer_SCIF_${target}.mot"
		if [ -f "${base_out}" ]; then
			install -m 0644 "${base_out}" "${DEPLOYDIR}/target/images/"
		fi

		# Deploy PMIC artifact only if it exists
		pmic_out="${PMIC_BUILD_DIR}/Flash_Writer_SCIF_${target}_PMIC.mot"
		if [ "${PMIC_SUPPORT}" = "1" ] && [ -f "${pmic_out}" ]; then
			install -m 0644 "${pmic_out}" "${DEPLOYDIR}/target/images/"
		fi
	done
}

PARALLEL_MAKE = "-j 1"
addtask deploy after do_compile
addtask do_prepare_src after do_unpack before do_compile
