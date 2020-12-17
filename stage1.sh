#!/bin/sh
#
# install.sh
#
# gpt uefi basic install of kiss linux (k1ss.org)
#
# assumes an ethernet line is plugged in an wget is installed
# i used an arch usb
#

# prompts before start
echo -n "swap size (GiB): "
read swap_size
#echo -n "mbr or uefi (m/u): "
#read boot_type

# disk setup

# uefi
#parted -s -a optimal /dev/sda \
#    mklabel gpt \
#    mkpart "EFI system partition" fat32 1MiB 261MiB \
#    mkpart "swap partition" linux-swap 261MiB $((${swap-size}*1024+261))MiB \
#    mkpart "root partition" ext4 $((${swap-size}*1024+261))MiB 100%
#parted /dev/sda set 1 esp on
#mkfs.fat -F32 /dev/sda1

# mbr
parted -s -a optimal -- /dev/sda \
    mklabel msdos \
    mkpart primary ext4 1MiB 513MiB \
    mkpart primary linux-swap 513MiB $((${swap_size}*1024+512))MiB \
    mkpart primary ext4 $((${swap_size}*1024+512))MiB 100%
parted /dev/sda set 1 boot on
#parted /dev/sda align-check optimal 1
mkfs.ext4 /dev/sda1

mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# kiss specific steps

## download & verification
url=https://github.com/kisslinux/repo/releases/download/2020.9-2 
wget "$url/kiss-chroot-2020.9-2.tar.xz" 
wget "$url/kiss-chroot-2020.9-2.tar.xz.sha256" 
sha256sum -c < kiss-chroot-2020.9-2.tar.xz.sha256
wget "$url/kiss-chroot-2020.9-2.tar.xz.asc"
gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E
gpg --verify "kiss-chroot-2020.9-2.tar.xz.asc" 

## extraction & kiss-chroot
cd /mnt
tar xvf /root/kiss-chroot-2020.9-2.tar.xz
genfstab /mnt >> /mnt/etc/fstab
echo "export REPOS_DIR='/var/db/kiss'                                   
export KISS_PATH=''                                              

KISS_PATH=\$KISS_PATH:\$REPOS_DIR/repo/core                         
KISS_PATH=\$KISS_PATH:\$REPOS_DIR/repo/extra                        
KISS_PATH=\$KISS_PATH:\$REPOS_DIR/repo/xorg                         
KISS_PATH=\$KISS_PATH:\$REPOS_DIR/community/community

export CFLAGS=\"-O3 -pipe -march=native\"
export CXXFLAGS=\"\$CFLAGS\"
export MAKEFLAGS=\"-j3\"
                                                         
export KISS_SU=su    
" > /mnt/etc/profile.d/kiss_path.sh

echo 'run the following:' 
echo '/mnt/bin/kiss-chroot /mnt'
