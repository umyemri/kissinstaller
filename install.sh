#!/bin/bash
#
# install.sh
#
# gpt uefi basic install of kiss linux (k1ss.org)
#
# assumes an ethernet line is plugged in an wget is installed
#

# prompts before start
echo -n "swap size (GiB): "
read swap_size

# disk setup
sgdisk -og /dev/sda 
sgdisk -n 1:2048:+512MiB -t 1:ef00 /dev/sda
start_of=$(sgdisk -f /dev/sda)
sgdisk -n 2:$start_of:+$swap_sizeGiB -t 2:8200 /dev/sda
start_of=$(sgdisk -f /dev/sda)
end_of=$(sgdisk -E /dev/sda)
sgdisk -n 3:$start_of:$end_of -t 3:8300 /dev/sda
#sgdisk -p /dev/sda # print if you want to see the layout
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

