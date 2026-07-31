DESCRIPTION = "PowerVR GPU user module"
LICENSE = "CLOSED"

require include/rcar-gfx-common.inc

COMPATIBLE_MACHINE = "rz-cmn"
PACKAGE_ARCH = "${MACHINE_ARCH}"

PN = "gles-user-module"
PR = "r0"

SRC_URI:rz-cmn = "${GFX_LIBRARY_URL};sha256sum=${GFX_LIBRARY_SHA256}"

SRC_URI:append:rz-cmn = " \
    file://rc.pvr.service \
    file://pvr-gfx-select \
    file://pvr-gfx-select.service \
    file://pvr-gfx.sh \
"

S = "${WORKDIR}/rogue"

inherit update-rc.d systemd

INITSCRIPT_NAME = "pvrinit"
INITSCRIPT_PARAMS = "start 7 5 2 . stop 62 0 1 6 ."
SYSTEMD_SERVICE:${PN} = "pvr-gfx-select.service rc.pvr.service"

do_populate_lic[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    # Install configuration files
    install -d ${D}${sysconfdir}/init.d
    cp -r ${S}/etc/* ${D}${sysconfdir}/
    install -m 755 ${S}/etc/init.d/rc.pvr ${D}${sysconfdir}/init.d/pvrinit

    # Keep PowerVR headers private. Mesa owns the generic EGL/GLES/KHR headers
    # in the unified rz-cmn rootfs so non-V4H boards keep working.
    install -d ${D}${includedir}/pvr
    cp -r ${S}/usr/include/* ${D}${includedir}/pvr/
    rm -rf ${D}${includedir}/pvr/CL
    rm -rf ${D}${includedir}/pvr/vulkan ${D}${includedir}/pvr/vk_video

    # Install pre-built binaries privately. Mesa owns the generic SONAMEs under
    # ${libdir}; V4H selects these libraries with LD_LIBRARY_PATH at runtime.
    install -d ${D}${libdir}/pvr
    install -m 755 ${S}/usr/lib/*.so ${D}${libdir}/pvr/
    install -d ${D}/usr/local/bin
    install -m 755 ${S}/usr/local/bin/* ${D}/usr/local//bin/
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 644 ${S}/lib/firmware/* ${D}${nonarch_base_libdir}/firmware/

    # Remove conflict binary
    rm -rf ${D}${libdir}/pvr/libOpenCL.so
    rm -rf ${D}${libdir}/pvr/libvulkan.so*

    # Do not publish PowerVR pkg-config files as the generic EGL/GLES provider.
    install -d ${D}${libdir}/pvr/pkgconfig
    install -m 644 ${S}/usr/lib/pkgconfig/*.pc ${D}${libdir}/pvr/pkgconfig/
    rm -rf ${D}${libdir}/pvr/pkgconfig/vulkan.pc

    # Create symbolic link
    cd ${D}${libdir}/pvr
    ln -s libEGL.so libEGL.so.1
    ln -s libGLESv2.so libGLESv2.so.2

    # Keep OpenCL/Vulkan vendor files private so non-V4H boards do not see the
    # PowerVR ICDs. pvr-gfx-select exposes them through environment variables
    # only on V4H/Sparrow-Hawk.
    install -d ${D}${datadir}/pvr
    if [ -d ${D}${sysconfdir}/vulkan ]; then
        install -d ${D}${datadir}/pvr/vulkan
        mv ${D}${sysconfdir}/vulkan/* ${D}${datadir}/pvr/vulkan/
        rm -rf ${D}${sysconfdir}/vulkan
        if [ -f ${D}${datadir}/pvr/vulkan/icd.d/powervr_icd.json ]; then
            sed -i 's#"library_path": "libVK_IMG.so"#"library_path": "/usr/lib/pvr/libVK_IMG.so"#' \
                ${D}${datadir}/pvr/vulkan/icd.d/powervr_icd.json
        fi
    fi
    if [ -d ${D}${sysconfdir}/OpenCL ]; then
        install -d ${D}${datadir}/pvr/OpenCL
        mv ${D}${sysconfdir}/OpenCL/* ${D}${datadir}/pvr/OpenCL/
        rm -rf ${D}${sysconfdir}/OpenCL
        if [ -f ${D}${datadir}/pvr/OpenCL/vendors/IMG.icd ]; then
            echo "/usr/lib/pvr/libPVROCL.so" > ${D}${datadir}/pvr/OpenCL/vendors/IMG.icd
        fi
    fi

    # Install systemd service
    # NOTE: use UNPACKDIR (not WORKDIR) — on Yocto styhead, file:// SRC_URI
    # entries unpack into ${UNPACKDIR} (= ${WORKDIR}/sources-unpack), whereas
    # on scarthgap they landed directly in ${WORKDIR}. UNPACKDIR is correct
    # on both.
    install -d ${D}${systemd_system_unitdir}/
    install -m 644 ${UNPACKDIR}/rc.pvr.service ${D}${systemd_system_unitdir}/
    install -m 644 ${UNPACKDIR}/pvr-gfx-select.service ${D}${systemd_system_unitdir}/
    install -d ${D}${exec_prefix}/bin
    install -m 755 ${S}/etc/init.d/rc.pvr ${D}${exec_prefix}/bin/pvrinit
    install -m 755 ${UNPACKDIR}/pvr-gfx-select ${D}${exec_prefix}/bin/pvr-gfx-select
    install -d ${D}${sysconfdir}/profile.d
    install -m 755 ${UNPACKDIR}/pvr-gfx.sh ${D}${sysconfdir}/profile.d/pvr-gfx.sh
}

PACKAGES = "\
    ${PN} \
    ${PN}-dev \
"

FILES:${PN} = " \
    ${sysconfdir}/* \
    ${libdir}/pvr/*.so* \
    ${nonarch_base_libdir}/firmware/rgx.fw* \
    ${nonarch_base_libdir}/firmware/rgx.sh* \
    ${datadir}/pvr/* \
    /usr/local/bin/* \
    ${exec_prefix}/bin/* \
    ${systemd_system_unitdir}/pvr-gfx-select.service \
"

FILES:${PN}-dev = " \
    ${includedir}/pvr/* \
    ${libdir}/pvr/pkgconfig/* \
"

PROVIDES = "virtual/gles-user-module"
PRIVATE_LIBS:${PN} = " \
    libEGL.so.1 \
    libGLESv2.so.2 \
    libIMGegl.so \
    libPVROCL.so \
    libPVRScopeServices.so \
    libVK_IMG.so \
    libdlc_REL.so \
    libpvrDRM_WSEGL.so \
    libsrv_um.so \
    libsutu_display.so \
    libufwriter.so \
    libusc.so \
"

RDEPENDS:${PN} = " \
    kernel-module-gles \
"

INSANE_SKIP:${PN} = "ldflags build-deps file-rdeps"
INSANE_SKIP:${PN}-dev = "ldflags build-deps file-rdeps"
INSANE_SKIP:${PN} += "arch"
INSANE_SKIP:${PN}-dev += "arch"
INSANE_SKIP:${PN}-dbg = "arch"

# To avoid QA Issue: already-stripped errors and not stripped libs from packages
# To avoid QA Issue: Files/directories were installed but not shipped in any package
INSANE_SKIP:${PN} += "already-stripped"
INSANE_SKIP:${PN} += "installed-vs-shipped"

# Skip debug split and strip of do_package()
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
