# Tell the kernel class to install the DTBs to /boot/dtb
KERNEL_DTBDEST = "${KERNEL_IMAGEDEST}/dtb"
KERNEL_DTBVENDORED = "1"

inherit kernel
inherit kernel-devicetree

KBRANCH:rz-cmn  = "styhead/rz-cmn"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# Default use of yocto git repositories. Uncomment the following to overrride it to use renesas sst git repo.
SRC_URI:rz-cmn = "git://github.com/Renesas-SST/linux-rz.git;name=machine;branch=${KBRANCH};protocol=https"

# Common config fragments and patches
SRC_URI:append:rz-cmn = " \
	file://common/kernel-common.cfg \
	file://common/panfrost.cfg \
	file://common/usb-serial.cfg \
	file://common/usb-can.cfg \
	file://common/firmware-edid.cfg \
	file://common/nvme.cfg \
	${@bb.utils.contains('DOCKER_SUPPORT', '1', 'file://common/docker.cfg', '', d)} \
	${@bb.utils.contains('DISTRO', 'ubuntu-tiny', 'file://common/docker.cfg', '', d)} \
	${@oe.utils.conditional("OPTIMIZE_KERN", "1", "file://common/optimize.cfg", "", d)} \
"

# RZ/G2L-SBC specific config fragments
SRC_URI:append:rz-cmn =	" \
	file://rzg2l-sbc/laird.cfg \
	file://rzg2l-sbc/touch.cfg \
"

## PREEMPT_RT handled by a separate linux-yocto-preempt-rt recipe

# Stage PREEMPT_RT patch for integrated RT build (not applied to base)
SRC_URI:append:rz-cmn = " \
    file://common/0008-realtime-kernel-patch.patch;apply=no \
"

KERNEL_FEATURES:append = " sii.cfg laird.cfg touch.cfg peripherals.cfg da7219.cfg drm_panel.cfg ov5640.cfg panfrost.cfg kernel-common.cfg ${@oe.utils.conditional('OPTIMIZE_KERN', '1', ' optimize.cfg', '', d)}"

KCONFIG_MODE:rz-cmn = "alldefconfig"
#KMACHINE:rz-cmn ?= "renesas_defconfig"
KBUILD_DEFCONFIG:rz-cmn ?= "renesas_defconfig"

# List of device tree names for rz-cmn
DEVICETREE_NAME:rz-cmn = " \
	rzg2l-sbc \
	rzg2l-evk \
	rzv2l-evk \
	rzv2h-evk-ver1 \
	rzv2h-rdk-ver1 \
	rs-g2l100 \
	imdt-v2h-sbc \
"

# Supported device tree and device tree overlays
KERNEL_DEVICETREE:rz-cmn = "${@' '.join(['renesas/%s.dtb' % devicetree_name for devicetree_name in d.getVar('DEVICETREE_NAME').split()])}"

KERNEL_DEVICETREE:append:rz-cmn = " \
	renesas/overlays/rzg2l-sbc-1.0-can.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ext-i2c.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ext-spi.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-dsi.dtbo \
	renesas/overlays/rzg2l-sbc-1.0-ov5640.dtbo \
	renesas/overlays/rzg2l-evk-1.0-cru-csi-ov5645.dtbo \
	renesas/overlays/rzv2l-evk-1.0-cru-csi-ov5645.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-audio-codec.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-audio-hdmi.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-can.dtbo \
	renesas/overlays/rzv2h-rdk-1.0-ext-spi.dtbo \
"

# Override the dtc flags to support dtbo build in kernel-devicetree.bbclass
KERNEL_DTC_FLAGS = "-@"

# Install overlays folder and kernel images to target/images in build folder
do_deploy:append:rz-cmn(){
	install -d ${DEPLOYDIR}/target/images/linux/dtbs/overlays
	install -m 0644 ${B}/arch/arm64/boot/dts/renesas/overlays/* ${DEPLOYDIR}/target/images/linux/dtbs/overlays

	install -m 0644 ${B}/arch/arm64/boot/Image ${DEPLOYDIR}/target/images/linux/${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin
	ln -sf ${KERNEL_IMAGETYPE}-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/linux/Image

	for dtb_name in ${DEVICETREE_NAME}; do
		install -m 0644 ${B}/arch/arm64/boot/dts/renesas/${dtb_name}.dtb ${DEPLOYDIR}/target/images/linux/dtbs/${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext
		ln -sf ${dtb_name}-${KERNEL_DTB_NAME}.$dtb_ext ${DEPLOYDIR}/target/images/linux/dtbs/${dtb_name}.dtb
	done

	# Deploy PREEMPT_RT kernel image from integrated build if present
	if [ -f ${SRT}/arch/arm64/boot/${KERNEL_IMAGETYPE} ]; then
		install -m 0644 ${SRT}/arch/arm64/boot/${KERNEL_IMAGETYPE} \
			${DEPLOYDIR}/target/images/linux/${KERNEL_IMAGETYPE}-preempt_rt-${KERNEL_ARTIFACT_NAME}.bin
		ln -sf ${KERNEL_IMAGETYPE}-preempt_rt-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/linux/Image-preempt_rt
	fi

	# Deploy non-preempt kernel image if present
	if [ -f ${SNP}/arch/arm64/boot/${KERNEL_IMAGETYPE} ]; then
		install -m 0644 ${SNP}/arch/arm64/boot/${KERNEL_IMAGETYPE} \
			${DEPLOYDIR}/target/images/linux/${KERNEL_IMAGETYPE}-nonpreempt-${KERNEL_ARTIFACT_NAME}.bin
		ln -sf ${KERNEL_IMAGETYPE}-nonpreempt-${KERNEL_ARTIFACT_NAME}.bin ${DEPLOYDIR}/target/images/linux/Image-nonpreempt
	fi
}

SRCREV_machine:rz-cmn ?= "${AUTOREV}"
LINUX_VERSION:rz-cmn ?= "6.10.14"

# COMPATIBLE_MACHINE is regex matcher.
COMPATIBLE_MACHINE:rz-cmn = "(rz-cmn)"
COMPATIBLE_MACHINE = "^(aarch64|rz-cmn)$"

#---------------------------------------------------------------------
# Build an additional NON-PREEMPT kernel image alongside the base Image
#---------------------------------------------------------------------

SNP ?= "${WORKDIR}/git-nonpreempt"

do_compile_nonpreempt() {
    bbnote "Building non-preempt kernel variant"

    if [ -d "${S}/.git" ]; then
        git -C "${S}" worktree remove --force "${SNP}" 2>/dev/null || true
        git -C "${S}" worktree prune 2>/dev/null || true
    fi
    rm -rf "${SNP}"
    mkdir -p "${SNP}"

    if [ -d "${S}/.git" ]; then
        bbnote "Creating git worktree at ${SNP} for non-preempt build"
        if ! git -C "${S}" worktree add --force --detach "${SNP}" HEAD 2>&1; then
            bbnote "git worktree failed; falling back to rsync copy"
            rsync -a --delete --exclude='.git' "${S}/" "${SNP}/"
        fi
    else
        bbnote "Copying kernel source to ${SNP} (no .git found)"
        rsync -a --delete --exclude='.git' "${S}/" "${SNP}/"
    fi

    if [ -f "${B}/.config" ]; then
        cp "${B}/.config" "${SNP}/.config"
    fi

    CFG_NONPREEMPT="${SNP}/.config"
    if [ ! -f "${CFG_NONPREEMPT}" ]; then
        bbfatal "Missing base configuration for non-preempt build"
    fi

    export CFG_NONPREEMPT
    python3 - <<'EOF'
import os, re
cfg = os.environ["CFG_NONPREEMPT"]
with open(cfg, "r", encoding="utf-8") as fh:
    lines = fh.readlines()
patterns = [
    r'^CONFIG_PREEMPT.*',
    r'^# CONFIG_PREEMPT.*is not set',
    r'^CONFIG_PREEMPT_NONE.*',
    r'^# CONFIG_PREEMPT_NONE.*',
    r'^CONFIG_PREEMPT_VOLUNTARY.*',
    r'^# CONFIG_PREEMPT_VOLUNTARY.*',
    r'^CONFIG_PREEMPTION.*',
    r'^# CONFIG_PREEMPTION.*',
    r'^CONFIG_PREEMPT_RCU.*',
    r'^# CONFIG_PREEMPT_RCU.*',
    r'^CONFIG_PREEMPT_DYNAMIC.*',
    r'^# CONFIG_PREEMPT_DYNAMIC.*',
    r'^CONFIG_LOCALVERSION.*',
    r'^CONFIG_LOCALVERSION_AUTO.*',
]
regex = [re.compile(p) for p in patterns]
filtered = [ln for ln in lines if not any(r.match(ln) for r in regex)]
filtered.extend([
    "# CONFIG_PREEMPT is not set\n",
    "# CONFIG_PREEMPT_VOLUNTARY is not set\n",
    "# CONFIG_PREEMPT_DYNAMIC is not set\n",
    "# CONFIG_PREEMPTION is not set\n",
    "# CONFIG_PREEMPT_RCU is not set\n",
    "CONFIG_PREEMPT_NONE=y\n",
    "CONFIG_LOCALVERSION=\"-nonpreempt\"\n",
    "CONFIG_LOCALVERSION_AUTO=n\n",
])
with open(cfg, "w", encoding="utf-8") as fh:
    fh.writelines(filtered)
EOF

    oe_runmake -C "${SNP}" olddefconfig
    oe_runmake -C "${SNP}" ${KERNEL_IMAGETYPE}
    oe_runmake -C "${SNP}" modules
}

addtask compile_nonpreempt after do_compile before do_install

#---------------------------------------------------------------------
# Build an additional PREEMPT_RT kernel image alongside the base Image
# Lightweight: create git worktree or rsync copy, patch only there,
# then build in-tree to avoid extra object dir.
#---------------------------------------------------------------------

# RT variant source tree
SRT ?= "${WORKDIR}/git-preempt-rt"

do_compile_preempt_rt() {
    bbnote "Building PREEMPT_RT kernel variant"

    # Locate the RT patch in common unpack locations
    RT_PATCH_BASENAME="0008-realtime-kernel-patch.patch"
    RT_PATCH_FILE=""
    for candidate in \
        "${WORKDIR}/sources-unpack/common/${RT_PATCH_BASENAME}" \
        "${WORKDIR}/common/${RT_PATCH_BASENAME}" \
        "${THISDIR}/rz-cmn/common/${RT_PATCH_BASENAME}" \
        "${THISDIR}/common/${RT_PATCH_BASENAME}"; do
        if [ -f "$candidate" ]; then RT_PATCH_FILE="$candidate"; break; fi
    done
    if [ ! -f "${RT_PATCH_FILE}" ]; then
        bbfatal "PREEMPT_RT patch not found. Searched: ${WORKDIR}/sources-unpack/common/${RT_PATCH_BASENAME} ${WORKDIR}/common/${RT_PATCH_BASENAME} ${THISDIR}/rz-cmn/common/${RT_PATCH_BASENAME} ${THISDIR}/common/${RT_PATCH_BASENAME}"
    fi

    # Ensure fresh RT worktree
    if [ -d "${S}/.git" ]; then
        git -C "${S}" worktree remove --force "${SRT}" 2>/dev/null || true
        git -C "${S}" worktree prune 2>/dev/null || true
    fi
    rm -rf "${SRT}"
    mkdir -p "${SRT}"

    # Create worktree or copy
    if [ -d "${S}/.git" ]; then
        bbnote "Creating git worktree at ${SRT}"
        if ! git -C "${S}" worktree add --force --detach "${SRT}" HEAD 2>&1; then
            bbnote "git worktree failed; falling back to rsync copy"
            rsync -a --delete --exclude='.git' "${S}/" "${SRT}/"
        fi
    else
        bbnote "Copying kernel source to ${SRT} (no .git found)"
        rsync -a --delete --exclude='.git' "${S}/" "${SRT}/"
    fi

    # Apply PREEMPT_RT patch
    bbnote "Applying PREEMPT_RT patch from ${RT_PATCH_FILE}"
    set +e
    patch -d "${SRT}" -p1 --forward --reject-file=- < "${RT_PATCH_FILE}"
    rc=$?
    set -e
    if [ $rc -ne 0 ]; then
        bbnote "Standard patch failed (rc=$rc); trying git am"
        ( cd "${SRT}" && git init && git config user.email "builder@example.com" && git config user.name "Yocto Builder" && git add -A && git commit -m init && git am -3 --keep-cr "${RT_PATCH_FILE}" ) || \
            bbfatal "Failed to apply PREEMPT_RT patch via patch and git am"
    fi

    # Seed configuration from the base build if present
    if [ -f "${B}/.config" ]; then
        cp "${B}/.config" "${SRT}/.config"
    fi

    # Enable PREEMPT_RT for the RT build
    echo "CONFIG_EXPERT=y" >> "${SRT}/.config" || true
    echo "CONFIG_PREEMPT_RT=y" >> "${SRT}/.config" || true

    # Refresh configuration and build the image + modules in-tree
    oe_runmake -C "${SRT}" olddefconfig
    oe_runmake -C "${SRT}" ${KERNEL_IMAGETYPE}
    oe_runmake -C "${SRT}" modules
}

EXTRA_OEMAKE += "-j16"
# Build RT image after base kernel compile, before install/deploy
addtask compile_preempt_rt after do_compile before do_install

# ---------------------------------------------------------------------
# Install and package PREEMPT_RT modules as a separate package
# so both base and RT module sets can coexist in the same rootfs.
# ---------------------------------------------------------------------

PACKAGES:append = " ${PN}-modules-preempt-rt ${PN}-modules-nonpreempt"
# Install RT module tree and dep files
FILES:${PN}-modules-preempt-rt = " \
    ${nonarch_base_libdir}/modules/*-rt*/modules.* \
    ${nonarch_base_libdir}/modules/*-rt*/kernel/** \
"
FILES:${PN}-modules-nonpreempt = " \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/modules.* \
    ${nonarch_base_libdir}/modules/*-nonpreempt*/kernel/** \
"

do_install:append:rz-cmn() {
    # If we built the RT variant, install its modules into ${D}
    if [ -d "${SRT}" ] && [ -f "${SRT}/.config" ]; then
        bbnote "Installing PREEMPT_RT modules into ${D}"

        # Figure out the kernel release string of the RT build
        if [ -f "${SRT}/include/config/kernel.release" ]; then
            RT_KREL=$(cat "${SRT}/include/config/kernel.release")
        else
            RT_KREL=$(make -s -C "${SRT}" kernelrelease || true)
        fi
        if [ -z "$RT_KREL" ]; then
            bbfatal "Unable to determine PREEMPT_RT kernel release"
        fi

        # Install modules under ${D}${nonarch_base_libdir}/modules/<rt-release> (usrmerge-aware)
        MOD_INSTALL_BASE="${D}"
        if [ "${nonarch_base_libdir}" != "/lib" ]; then
            MOD_INSTALL_BASE="${D}${nonarch_base_libdir%/lib}"
        fi
        oe_runmake -C "${SRT}" INSTALL_MOD_PATH="$MOD_INSTALL_BASE" INSTALL_MOD_STRIP=1 modules_install

        rt_moddir="$MOD_INSTALL_BASE/lib/modules/$RT_KREL"
        # Drop source/build symlinks to avoid packaging symlinked sources
        rm -f "$rt_moddir/build" "$rt_moddir/source" || true
        # Drop any stray top-level files that shouldn't ship
        rm -f "$rt_moddir"/vmlinux "$rt_moddir"/System.map || true
        # Remove embedded debug dirs to avoid buildpaths QA in kernel-dbg
        if [ -d "$rt_moddir/kernel" ]; then
            find "$rt_moddir/kernel" -type d -name .debug -prune -exec rm -rf {} + || true
        fi

        # Clean up
        find "$rt_moddir" -type d -name .debug -exec rm -rf {} + || true
        find "$rt_moddir" -type f -path "*/.debug/*" -exec rm -f {} + || true

        # No relocation needed; INSTALL_MOD_PATH selected the correct base

        # Generate modules.dep for the RT
        if [ -x "${STAGING_BINDIR_NATIVE}/depmodwrapper" ]; then
            "${STAGING_BINDIR_NATIVE}/depmodwrapper" -a -b "$MOD_INSTALL_BASE" "$RT_KREL"
        elif command -v depmod >/dev/null 2>&1; then
            depmod -a -b "$MOD_INSTALL_BASE" "$RT_KREL" || true
        else
            bbwarn "depmod not found; modules.dep for PREEMPT_RT not generated"
        fi
    fi

    # Install non-preempt modules if we built that variant
    if [ -d "${SNP}" ] && [ -f "${SNP}/.config" ]; then
        bbnote "Installing non-preempt modules into ${D}"

        if [ -f "${SNP}/include/config/kernel.release" ]; then
            NP_KREL=$(cat "${SNP}/include/config/kernel.release")
        else
            NP_KREL=$(make -s -C "${SNP}" kernelrelease || true)
        fi
        if [ -z "$NP_KREL" ]; then
            bbfatal "Unable to determine non-preempt kernel release"
        fi

        MOD_INSTALL_BASE="${D}"
        if [ "${nonarch_base_libdir}" != "/lib" ]; then
            MOD_INSTALL_BASE="${D}${nonarch_base_libdir%/lib}"
        fi
        oe_runmake -C "${SNP}" INSTALL_MOD_PATH="$MOD_INSTALL_BASE" INSTALL_MOD_STRIP=1 modules_install

        np_moddir="$MOD_INSTALL_BASE/lib/modules/$NP_KREL"
        rm -f "$np_moddir/build" "$np_moddir/source" || true
        rm -f "$np_moddir"/vmlinux "$np_moddir"/System.map || true
        if [ -d "$np_moddir/kernel" ]; then
            find "$np_moddir/kernel" -type d -name .debug -prune -exec rm -rf {} + || true
        fi
        find "$np_moddir" -type d -name .debug -exec rm -rf {} + || true
        find "$np_moddir" -type f -path "*/.debug/*" -exec rm -f {} + || true

        if [ -x "${STAGING_BINDIR_NATIVE}/depmodwrapper" ]; then
            "${STAGING_BINDIR_NATIVE}/depmodwrapper" -a -b "$MOD_INSTALL_BASE" "$NP_KREL"
        elif command -v depmod >/dev/null 2>&1; then
            depmod -a -b "$MOD_INSTALL_BASE" "$NP_KREL" || true
        else
            bbwarn "depmod not found; modules.dep for non-preempt kernel not generated"
        fi
    fi
}
