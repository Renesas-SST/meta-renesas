# SPDX-License-Identifier: MIT
#
# Helper routines for building additional Renesas kernel variants.

RENESAS_KERNEL_VARIANTS ?= ""
RENESAS_KERNEL_DEPLOY_IMAGE_DIR ?= "${DEPLOYDIR}/target/images/linux"
RENESAS_KERNEL_VARIANT_MODULES ?= ""

python () {
    variants = (d.getVar("RENESAS_KERNEL_VARIANTS") or "").split()
    fields = ["SRCTREE", "TREE", "PRETTY", "PATCH", "PATCH_LOCATIONS", "CONFIG", "IMAGE", "SYMLINK"]

    if variants:
        d.setVarFlag("RENESAS_KERNEL_VARIANTS", "export", "1")

    modules = d.getVar("RENESAS_KERNEL_VARIANT_MODULES") or ""

    for variant in variants:
        tree_var = "RENESAS_KERNEL_VARIANT_%s_TREE" % variant
        if not d.getVar(tree_var):
            d.setVar(tree_var, "${WORKDIR}/git-%s" % variant)

        for field in fields:
            var = "RENESAS_KERNEL_VARIANT_%s_%s" % (variant, field)
            d.setVarFlag(var, "export", "1")

        variant_modules = d.getVar("RENESAS_KERNEL_VARIANT_%s_MODULES" % variant) or ""
        if variant_modules:
            modules = " ".join(filter(None, [modules, variant_modules]))

    d.setVar("RENESAS_KERNEL_VARIANT_MODULES", modules.strip())
}

renesas_kernel_variant_get() {
    variant="$1"
    field="$2"
    base="RENESAS_KERNEL_VARIANT_${variant}_${field}"
    eval "value=\"\${${base}}\""
    if [ -z "$value" ] && [ -n "${MACHINE}" ]; then
        mach=$(printf '%s' "${MACHINE}" | tr '-' '_')
        eval "value=\"\${${base}_${mach}}\""
    fi

    printf '%s' "$value"
}

renesas_kernel_install_variant_modules() {
    tree="$1"
    pretty_name="$2"

    if [ -z "$tree" ] || [ ! -d "$tree" ] || [ ! -f "$tree/.config" ]; then
        bbnote "Skipping module install for ${pretty_name:-unknown} (tree missing)"
        return
    fi

    bbnote "Installing ${pretty_name} modules into ${D}"

    if [ -f "$tree/include/config/kernel.release" ]; then
        krel=$(cat "$tree/include/config/kernel.release")
    else
        krel=$(make -s -C "$tree" kernelrelease || true)
    fi
    if [ -z "$krel" ]; then
        bbfatal "Unable to determine ${pretty_name} kernel release"
    fi

    mod_install_base="${D}"
    if [ "${nonarch_base_libdir}" != "/lib" ]; then
        mod_install_base="${D}${nonarch_base_libdir%/lib}"
    fi
    oe_runmake -C "$tree" INSTALL_MOD_PATH="$mod_install_base" INSTALL_MOD_STRIP=1 modules_install

    moddir="$mod_install_base/lib/modules/$krel"
    rm -f "$moddir/build" "$moddir/source" || true
    rm -f "$moddir"/vmlinux "$moddir"/System.map || true
    if [ -d "$moddir/kernel" ]; then
        find "$moddir/kernel" -type d -name .debug -prune -exec rm -rf {} + || true
    fi
    find "$moddir" -type d -name .debug -exec rm -rf {} + || true
    find "$moddir" -type f -path "*/.debug/*" -exec rm -f {} + || true

    if [ -x "${STAGING_BINDIR_NATIVE}/depmodwrapper" ]; then
        "${STAGING_BINDIR_NATIVE}/depmodwrapper" -a -b "$mod_install_base" "$krel"
    elif command -v depmod >/dev/null 2>&1; then
        depmod -a -b "$mod_install_base" "$krel" || true
    else
        bbwarn "depmod not found; modules.dep for ${pretty_name} not generated"
    fi
}

renesas_kernel_copy_variant_image() {
    tree="$1"
    dest_dir="$2"
    dest_basename="$3"
    symlink_name="$4"
    label="$5"

    image_path="${tree}/arch/arm64/boot/${KERNEL_IMAGETYPE}"
    if [ -z "$tree" ] || [ ! -f "$image_path" ]; then
        bbwarn "Skipping ${label} image copy: ${image_path} not found"
        return
    fi

    install -d "$dest_dir"
    dest_path="${dest_dir}/${dest_basename}"
    install -m 0644 "$image_path" "$dest_path"
    ln -sf "$(basename "$dest_path")" "${dest_dir}/${symlink_name}"
}

renesas_kernel_install_variant_image() {
    renesas_kernel_copy_variant_image "$1" "${D}/${KERNEL_IMAGEDEST}" "$2" "$3" "$4"
}

renesas_kernel_deploy_variant_image() {
    renesas_kernel_copy_variant_image "$1" "${RENESAS_KERNEL_DEPLOY_IMAGE_DIR}" "$2" "$3" "$4"
}

renesas_kernel_compile_variant() {
    variant="$1"

    srctree=$(renesas_kernel_variant_get "$variant" SRCTREE)
    tree=$(renesas_kernel_variant_get "$variant" TREE)
    pretty=$(renesas_kernel_variant_get "$variant" PRETTY)
    patch_name=$(renesas_kernel_variant_get "$variant" PATCH)
    config_frags=$(renesas_kernel_variant_get "$variant" CONFIG)

    [ -n "$pretty" ] || pretty="$variant"
    [ -n "$srctree" ] || srctree="${S}"

    if [ -z "$srctree" ] || [ ! -d "$srctree" ]; then
        bbfatal "Source tree not defined or missing for kernel variant '${variant}': ${srctree}"
    fi

    if [ -z "$tree" ]; then
        bbfatal "Build tree not defined for kernel variant '${variant}'"
    fi

    bbnote "Building ${pretty} kernel variant from ${srctree} with output in ${tree}"

    # TREE as a pure build directory, clean it first
    rm -rf "${tree}"
    mkdir -p "${tree}"

    # Seed .config in the build directory
    if [ -f "${B}/.config" ]; then
        cp "${B}/.config" "${tree}/.config"
    fi

    cfg_file="${tree}/.config"
    if [ ! -f "${cfg_file}" ]; then
        bbfatal "Missing base configuration for ${pretty} build"
    fi

    # Append any variant-specific config fragments
    if [ -n "$config_frags" ]; then
        for frag in $config_frags; do
            if [ ! -f "$frag" ]; then
                bbfatal "Config fragment ${frag} for ${pretty} not found"
            fi
            cat "$frag" >> "${cfg_file}"
        done
    fi

    # Standard out-of-tree kernel build: use srctree as -C, TREE as O=
    oe_runmake -C "${srctree}" O="${tree}" olddefconfig
    oe_runmake -C "${srctree}" O="${tree}" ${KERNEL_IMAGETYPE}
    oe_runmake -C "${srctree}" O="${tree}" modules
}

do_install:append() {
    for variant in ${RENESAS_KERNEL_VARIANTS}; do
        tree=$(renesas_kernel_variant_get "$variant" TREE)
        pretty=$(renesas_kernel_variant_get "$variant" PRETTY)
        dest=$(renesas_kernel_variant_get "$variant" IMAGE)
        symlink=$(renesas_kernel_variant_get "$variant" SYMLINK)
        [ -n "$dest" ] || dest="${KERNEL_IMAGETYPE}-${variant}-${KERNEL_ARTIFACT_NAME}.bin"
        [ -n "$symlink" ] || symlink="Image-${variant}"

        renesas_kernel_install_variant_modules "$tree" "${pretty:-$variant}"
        renesas_kernel_install_variant_image "$tree" "$dest" "$symlink" "${pretty:-$variant}"
    done
}

do_deploy:append() {
    for variant in ${RENESAS_KERNEL_VARIANTS}; do
        tree=$(renesas_kernel_variant_get "$variant" TREE)
        label=$(renesas_kernel_variant_get "$variant" PRETTY)
        dest=$(renesas_kernel_variant_get "$variant" IMAGE)
        symlink=$(renesas_kernel_variant_get "$variant" SYMLINK)
        [ -n "$dest" ] || dest="${KERNEL_IMAGETYPE}-${variant}-${KERNEL_ARTIFACT_NAME}.bin"
        [ -n "$symlink" ] || symlink="Image-${variant}"
        renesas_kernel_deploy_variant_image "$tree" "$dest" "$symlink" "${label:-$variant}"
    done
}

RRECOMMENDS:${KERNEL_PACKAGE_NAME}-base:append = " ${RENESAS_KERNEL_VARIANT_MODULES}"
RRECOMMENDS:${KERNEL_PACKAGE_NAME}-image:append = " ${RENESAS_KERNEL_VARIANT_MODULES}"
