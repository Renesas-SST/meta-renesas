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
"

PACKAGECONFIG_append_pn-python3 = " tk"

# Ignore vte-local-en-gb package because it has incompatible license GPL-3.0
BAD_RECOMMENDATIONS += " vte-locale-en-gb"

# Support wic image
IMAGE_FSTYPES_append = " wic "

# Remove unused rootfs types
IMAGE_FSTYPES_remove = " tar.gz ext4 "

# Linux bootloader flashing utility
EXTRA_IMAGEDEPENDS += " bootloader-flasher-linux "

# Windows bootloader flashing utility
EXTRA_IMAGEDEPENDS += " bootloader-flasher-win "

# Windows bootloader flashing readme
EXTRA_IMAGEDEPENDS += " bootloader-flasher-readme "

# Linux sd-creator-linux
EXTRA_IMAGEDEPENDS += " sd-creator-linux "

# Windows sd-creator-win
EXTRA_IMAGEDEPENDS += " sd-creator-win "

# sd-creator-readme
EXTRA_IMAGEDEPENDS += " sd-creator-readme "

# Linux uload-bootloader-linux
EXTRA_IMAGEDEPENDS += " uload-bootloader-linux "

# Windows uload-bootloader-win
EXTRA_IMAGEDEPENDS += " uload-bootloader-win "

# uload-bootloader-readme
EXTRA_IMAGEDEPENDS += " uload-bootloader-readme "

# uEnv.txt
IMAGE_INSTALL_append = " uenv "

# host-readme
EXTRA_IMAGEDEPENDS += " host-readme "

# target-readme
EXTRA_IMAGEDEPENDS += " target-readme "

# Readme documentation
EXTRA_IMAGEDEPENDS += " readme "
EXTRA_IMAGEDEPENDS += " rzpi-docs "

# Rootfs RZ SBC board
IMAGE_INSTALL_append = " mmc-utils mtd-utils memtester minicom ca-certificates openssl dtc iputils ppp traceroute"
