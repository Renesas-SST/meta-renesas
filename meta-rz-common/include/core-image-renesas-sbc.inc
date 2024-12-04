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

# Create new files and folders for apt/dpkg to fix the following issues:
# 1. When running APT commands like `apt-get update`, the following error occurs:
#    "E: The method driver /usr/lib/apt/methods/http could not be found."
#    This happens because APT requires the HTTP method driver located in
#    `/usr/lib/apt/methods/`. However, in some cases, the driver files are installed
#    in `/usr/lib64/apt/methods/` instead, causing APT to fail.
# 2. Additionally, the absence of the `status` and `available` files in `/var/lib/dpkg/`
#    causes errors such as:
#    "E: Could not open file /var/lib/dpkg/status - open(2: No such file or directory)."
#    Creating the `status` and `available` files is necessary to resolve this issue.
update_deb_issues() {
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/status
    touch ${IMAGE_ROOTFS}/var/lib/dpkg/available

    cp -r ${IMAGE_ROOTFS}/usr/lib64/apt/ ${IMAGE_ROOTFS}/usr/lib/apt
}

ROOTFS_POSTPROCESS_COMMAND += " update_deb_issues; "