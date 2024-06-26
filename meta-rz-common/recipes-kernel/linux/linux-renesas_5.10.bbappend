DESCRIPTION = "Linux Kernel for RZ SBC board"

BB_STRICT_CHEKSUM:forcevariable = "0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

KERNEL_URL = "git://git@github.com/Renesas-SST/linux-rz.git"
BRANCH = "dunfell/rz-sbc-checked-patches-rc2"
SRCREV = "f10344984ceced4fd5f083f3079209befc75f714"
SRC_URI = "${KERNEL_URL};protocol=ssh;nocheckout=1;branch=${BRANCH}"

SRC_URI_append = "\
	file://sii.cfg \
	file://laird.cfg \
"

