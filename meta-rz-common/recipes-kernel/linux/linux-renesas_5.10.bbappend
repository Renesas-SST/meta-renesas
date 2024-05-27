DESCRIPTION = "Linux Kernel for RZ SBC board"

BB_STRICT_CHEKSUM:forcevariable = "0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

KERNEL_URL = "git://git@github.com/Renesas-SST/linux-rz.git"
BRANCH = "dunfell/rz-sbc-checked-patches"
SRCREV = "275b5dbf0931e5eefc4fc28ad88b56405d05be7a"
SRC_URI = "${KERNEL_URL};protocol=ssh;nocheckout=1;branch=${BRANCH}"

SRC_URI_append = "\
	file://sii.cfg \
	file://laird.cfg \
"

