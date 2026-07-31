# For Optee Features purpose

# Enable build and load of OP-TEE
ENABLE_SPD_OPTEE            ?= '0'
ENABLE_V4H_DIRECT_OPTEE     ?= '0'

# Enable hardware crypt IP(SCE) driver in OP-TEE OS
ENABLE_RZ_SCE               ?= '0'

python () {
    if d.getVar('ENABLE_SPD_OPTEE') == '1' and d.getVar('ENABLE_V4H_DIRECT_OPTEE') == '1':
        bb.fatal('ENABLE_SPD_OPTEE and ENABLE_V4H_DIRECT_OPTEE are mutually exclusive')
}
