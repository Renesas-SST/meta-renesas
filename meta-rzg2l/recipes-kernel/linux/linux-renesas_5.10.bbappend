LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE_rzg2l = "(smarc-rzg2l|rzg2l-dev|smarc-rzg2lc|rzg2lc-dev|smarc-rzg2ul|rzg2ul-dev|smarc-rzv2l|rzv2l-dev|rzpi)"

B = "${WORKDIR}/build"

# Remove the patch URI if it exists
SRC_URI_remove = " \
    file://0002-Workaround-GPU-driver-remove-power-domains-of-GPU-no.patch \
    file://0002-Workaround-GPU-driver-remove-power-domains-v2l.patch \
"

# Support to build dtbo for RZ SBC
KERNEL_DTC_FLAGS = "-@"
KERNEL_DEVICETREE_OVERLAY ?= ""

do_compile_prepend() {
    if [ -n "${KERNEL_DTC_FLAGS}" ]; then
       export DTC_FLAGS="${KERNEL_DTC_FLAGS}"
    fi
}

do_compile_append() {
    for dtbf in ${KERNEL_DEVICETREE_OVERLAY}; do
        dtb=`normalize_dtb "$dtbf"`
        oe_runmake $dtb CC="${KERNEL_CC} $cc_extra " LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS}
    done
}

do_deploy_append(){
    install -d ${DEPLOYDIR}/target/images/dtbs/overlays
    install -m 0644 ${B}/arch/arm64/boot/dts/renesas/overlays/* ${DEPLOYDIR}/target/images/dtbs/overlays

    install -m 0644 ${B}/arch/arm64/boot/Image ${DEPLOYDIR}/target/images/${base_name}.bin
    ln -sf ${base_name}.bin ${DEPLOYDIR}/target/images/Image

    install -m 0644 ${B}/arch/arm64/boot/dts/renesas/rzpi.dtb ${DEPLOYDIR}/target/images/dtbs/$dtb_base_name-${KERNEL_DTB_NAME}.$dtb_ext
    ln -sf $dtb_base_name-${KERNEL_DTB_NAME}.$dtb_ext ${DEPLOYDIR}/target/images/dtbs/rzpi.dtb
}

do_populate_sysroot () {
}

COMPATIBLE_MACHINE = "(rzpi)"
PACKAGE_ARCH = "${MACHINE_ARCH}"
