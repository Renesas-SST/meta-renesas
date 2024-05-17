#!/bin/bash


function chelp() {
	echo "------------------------------------------------------"
	echo "Command format:"
	echo "    sd_flash.sh <device> <location of yocto directory>"
	echo "    Example: sd_flash.sh /dev/sda ~/yocto"
	echo "------------------------------------------------------"
}


if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    chelp
    exit 0
fi
if [ $# -lt 1 ]
  then
    echo "Missing arguments."
    chelp
    exit 0
fi

sd_dev=$1
# double quotes are necessary as the return string can contain spaces which will trigger Too many arguements error with if test - if [].
parted_present=$(dpkg-query -s parted | sed -n "2p")
dpkg_present="Status: install ok installed"
#regex that has word boundary to make sure only 'Y' and 'y' at the beginning pass.
regex_y_check="\\b(Y|y)\\b"

usr=$(id -u)
echo "usr=$usr"
if [ $usr != 0 ]; then
	echo "Please run this script as sudo / root."
	exit 0
fi
echo $regex_y_check
if [ "${parted_present}" == "${dpkg_present}" ];
then
	echo "selected device is ${sd_dev}"
	printf "Warning: all data will be erased on this drive. Please confirm (Y|y) : "
	read -r format_confirm
	if [[ ${format_confirm} =~ ${regex_y_check} ]]
	then
		echo "You have chosen to erase the memory device (${sd_dev})"
		num_part=$(cat /proc/partitions | grep ${sd_dev} | wc -l)
		echo $num_part
		echo "Disk info:-------------------------------------------------------------------"
		parted -s ${sd_dev} print
		echo "-----------------------------------------------------------------------------"
		echo "Unmounting device.."
		df -hT | grep ${sd_dev} | cut -d " " -f 1 | xargs umount
		if [ -z $(df -hT | grep ${sd_dev}) ]; then
			echo "Unmount successful"
		else
			echo "Unmount failed."
			exit
		fi
		echo "Erasing disk..."
		#mounts=$(cat /proc/mounts | grep sdb | cut -d ' ' -f 2)
		#cat ${mounts} | xargs umount
		#echo "mounts = ${mounts}"
		#echo "partiton 1 mount:"
		sfdisk --delete ${sd_dev}
		echo "Disk erase complete."
		echo "-----------------------------------------------------------------------------"

		echo "Disk info:"
		parted -s ${sd_dev} print
		echo "-----------------------------------------------------------------------------"
		parted -s ${sd_dev} mklabel gpt
		parted -s ${sd_dev} mkpart primary fat32 2MiB 512MiB
		parted -s ${sd_dev} mkpart primary ext4 512MiB 4096MiB
		parted -s ${sd_dev} align-check min 1
		sync

		echo "Partitioning complete"
		echo "-----------------------------------------------------------------------------"
		echo "Disk info:"
		parted -s ${sd_dev} print
		partprobe
		echo "-----------------------------------------------------------------------------"
		sleep 1
	
		# Formatting is not needed as parted will create a formatted partition
		echo "Formatting partitions"
		mkfs -t vfat ${sd_dev}1
		mkfs -t ext4 ${sd_dev}2
		echo "-----------------------------------------------------------------------------"

		echo "Mounting sd card"
		mkdir -p /tmp/rz_sdm1
		mkdir -p /tmp/rz_sdm2

		mount ${sd_dev}1 /tmp/rz_sdm1
		mount ${sd_dev}2 /tmp/rz_sdm2

		sleep 2

		if [[ -z $(df -hT | grep ${sd_dev}) ]]; then
			echo "Device not mounted"
			exit
		else
			echo "Device found"
		fi

		echo "-----------------------------------------------------------------------------"
		echo "Copying files..."
		echo "Changing to ${PWD}"
		echo "Listing rootfs partition:"
		ls -l
		tar -xvjf core-image-qt-rzpi-*.rootfs.tar.bz2 -C /tmp/rz_sdm2/
		#cp rzpi.dtb /tmp/rz_sdm2/boot/
		#ls -l /tmp/rz_sdm2/
		cd /tmp/rz_sdm2/boot
		#gzip -k Image-*
		#mv Image-*.gz Image.gz
		echo "Listing boot directory:"
		ls -l
		echo "Syncing fs"
		sync /tmp/rz_sdm1
		sync /tmp/rz_sdm2
		sync ${sd_dev}1
		sync ${sd_dev}2
		echo "Successfully copied"
		cd -
		echo "Unmounting device."
		umount /tmp/rz_sdm1
		umount /tmp/rz_sdm2
		echo " SD card successfully created."
	else
		echo "Did not recieve a confirmation. exiting.."
	fi
fi
echo "exiting"

