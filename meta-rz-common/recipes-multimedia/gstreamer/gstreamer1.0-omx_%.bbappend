FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

SRC_URI_append = " \
    file://0001-common-Change-the-submodule-to-a-mirror-repository.patch \
"
