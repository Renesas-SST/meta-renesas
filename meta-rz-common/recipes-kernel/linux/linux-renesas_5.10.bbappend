DESCRIPTION = "Linux Kernel for RZ SBC board"

BB_STRICT_CHEKSUM:forcevariable = "0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

KERNEL_URL = "git://git@github.com/Renesas-SST/linux-rz.git"
BRANCH = "rz-sbc-release4-5.10-cip36"
SRCREV = "5cf70d0c963320be539a51c3deae1f6729654d33"
SRC_URI = "${KERNEL_URL};protocol=ssh;nocheckout=1;branch=${BRANCH}"

SRC_URI_append = "\
	file://sii.cfg \
	file://laird.cfg \
"

