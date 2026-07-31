DESCRIPTION = "Packages the Sparrow-Hawk BL31 and OP-TEE payloads for manual U-Boot loading, and generates size, CRC32, and SHA-256 metadata for boot-time validation"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

require include/rz-optee-config.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "rz-cmn"

DEPENDS = "trusted-firmware-a optee-os python3-native"

inherit python3native

DIRECT_OPTEE_BL31 = "${RECIPE_SYSROOT}/boot/bl31-sparrow-hawk.bin"
DIRECT_OPTEE_TEE = "${RECIPE_SYSROOT}/boot/tee-raw-sparrow-hawk.bin"

do_install() {
    install -d ${D}/boot
    test -s ${DIRECT_OPTEE_BL31}
    test -s ${DIRECT_OPTEE_TEE}
    install -m 0644 ${DIRECT_OPTEE_BL31} ${D}/boot/bl31-sparrow-hawk.bin
    install -m 0644 ${DIRECT_OPTEE_TEE} ${D}/boot/tee-raw-sparrow-hawk.bin
}

python do_generate_manifest () {
    import binascii
    import hashlib
    import json
    import os

    boot = os.path.join(d.getVar('D'), 'boot')
    payloads = (
        ('bl31', 'bl31-sparrow-hawk.bin', 0x46400000, 0x22200),
        ('tee', 'tee-raw-sparrow-hawk.bin', 0x44100000, 0x300000),
    )
    manifest = {
        'format': 2,
        'build': {
            'machine': d.getVar('MACHINE'),
            'distro': d.getVar('DISTRO'),
            'distro_version': d.getVar('DISTRO_VERSION'),
            'target_sys': d.getVar('TARGET_SYS'),
            'source_date_epoch': d.getVar('SOURCE_DATE_EPOCH'),
        },
        'source_policy': 'recipe branch heads (AUTOREV)',
        'payloads': {},
    }

    for key, name, address, maximum in payloads:
        path = os.path.join(boot, name)
        with open(path, 'rb') as payload:
            data = payload.read()
        size = len(data)
        if not size or size > maximum:
            bb.fatal('%s has invalid size %d (maximum %#x)' % (name, size, maximum))
        manifest['payloads'][key] = {
            'file': '/boot/' + name,
            'load_address': '0x%08x' % address,
            'size': size,
            'crc32': '%08x' % (binascii.crc32(data) & 0xffffffff),
            'sha256': hashlib.sha256(data).hexdigest(),
        }

    env_path = os.path.join(boot, 'v4h-direct-optee.env')
    with open(env_path, 'w', encoding='ascii') as env:
        env.write('v4h_manifest_version=1\n')
        for key in ('bl31', 'tee'):
            item = manifest['payloads'][key]
            env.write('%s_file=%s\n' % (key, item['file']))
            env.write('%s_addr=%s\n' % (key, item['load_address']))
            env.write('%s_size=0x%x\n' % (key, item['size']))
            env.write('%s_crc32=%s\n' % (key, item['crc32']))

    manifest_path = os.path.join(boot, 'v4h-direct-optee.manifest')
    with open(manifest_path, 'w', encoding='ascii') as output:
        json.dump(manifest, output, indent=2, sort_keys=True)
        output.write('\n')

    os.chown(env_path, 0, 0)
    os.chown(manifest_path, 0, 0)
}

addtask generate_manifest after do_install before do_package
do_generate_manifest[fakeroot] = "1"

FILES:${PN} = "/boot"
