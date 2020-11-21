#!/bin/bash
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

# disk setup
sgdisk -og /dev/sda 
sgdisk -n 1:2048:+512MiB -t 1:ef00 /dev/sda
start_of=$(sgdisk -f /dev/sda)
sgdisk -n 2:$start_of:+${swap_size}GiB -t 2:8200 /dev/sda
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
export MAKEFLAGS=\"-j2\"
                                                         
export KISS_SU=su    
" > /mnt/etc/profile.d/kiss_path.sh

echo 'run the following:' 
echo '/mnt/bin/kiss-chroot /mnt'
