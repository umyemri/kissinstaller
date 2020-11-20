#!/bin/bash
#
# install.sh
#
# gpt uefi basic install of kiss linux (k1ss.org)
#
# assumes an ethernet line is plugged in an wget is installed
# i used an arch usb
#

# logging - use if needed
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3 RETURN
#exec 1>kiss-log.out 2>&1

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
echo "++++++++++++++++++++++++++++++++++++++++++
export REPOS_DIR='/var/db/kiss'                                   
export KISS_PATH=''                                              

KISS_PATH=$KISS_PATH:$REPOS_DIR/repo/core                         
KISS_PATH=$KISS_PATH:$REPOS_DIR/repo/extra                        
KISS_PATH=$KISS_PATH:$REPOS_DIR/repo/xorg                         
KISS_PATH=$KISS_PATH:$REPOS_DIR/community/community

export CFLAGS="-O3 -pipe -march=native"
export CXXFLAGS="$CFLAGS"
export MAKEFLAGS="-j2"
                                                         
export KISS_SU=su    
+++++++++++++++++++++++++++++++++++++++++++++
" > /mnt/etc/profile.d/kiss_path.sh
/mnt/bin/kiss-chroot /mnt . /etc/profile.d/kiss_path.sh
/mnt/bin/kiss-chroot /mnt git clone https://github.com/kisslinux/repo /var/db/kiss/
/mnt/bin/kiss-chroot /mnt git clone https://github.com/kisslinux/community /var/db/kiss/
/mnt/bin/kiss-chroot /mnt kiss build gnupg1
/mnt/bin/kiss-chroot /mnt kiss install gnupg1
/mnt/bin/kiss-chroot /mnt gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E
/mnt/bin/kiss-chroot /mnt echo trusted-key 0x46d62dd9f1de636e >> /root/.gnupg/gpg.conf
/mnt/bin/kiss-chroot /mnt git config merge.verifySignatures true /var/db/kiss/repo

echo "at this point everything is in place tp update the kiss build."
echo "to run the update type:"
echo "/mnt/bin/kiss-chroot /mnt"
echo "kiss update"
echo "you will need to run it twice"
echo "running kiss build * at /var/db/kiss/installed/"
echo "this will take some four hours... so grab a book."
