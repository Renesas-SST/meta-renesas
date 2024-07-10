DESCRIPTION = "Linux Kernel for RZ SBC board"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

KERNEL_URL = "git://github.com/Renesas-SST/linux-rz.git"
BRANCH = "dunfell/rz-sbc"
SRCREV = "${AUTOREV}"
SRC_URI = "${KERNEL_URL};protocol=https;nocheckout=1;branch=${BRANCH}"

SRC_URI_append = "\
	file://sii.cfg \
	file://laird.cfg \
"

