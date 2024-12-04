# Packages for Wi-Fi and BT support
IMAGE_INSTALL_append = " \
    net-tools \
    phytool \
    lwb-fcc-firmware \
    kernel-module-lwb5p-backports-summit \
    summit-supplicant-lwb \
    rng-tools \
    htop \
    iw \
    ethtool \
    iperf3 \
    tcpdump \
    bluez5 \
    bluez5-dev \
    obexftp \
"

CORE_IMAGE_EXTRA_INSTALL += " packagegroup-tools-bluetooth "

# Packages for users application development
IMAGE_INSTALL_append = " \
    apt \
    dpkg \
    python3-tkinter \
    python3-numpy \
    python3-pandas \
    python3-pyserial \
    python3-matplotlib \
    python3-pip \
    apt-sources-config \
    python3-smbus \
    python3-smbus2 \
"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"

# Rootfs RZ SBC board
IMAGE_INSTALL_append = " mmc-utils mtd-utils memtester minicom ca-certificates openssl dtc iputils ppp traceroute"

# Create folders for apt/dpkg
update_deb_issues() {
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/status
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/available

    cp -r ${IMAGE_ROOTFS}/usr/lib64/apt/ ${IMAGE_ROOTFS}/usr/lib/apt
}

ROOTFS_POSTPROCESS_COMMAND += " update_deb_issues; "