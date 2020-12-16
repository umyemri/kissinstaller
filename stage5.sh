#!/bin/sh
#
# stage 5: boot loader
#
# assumes kernal compiles and installed.
# grub install on my dell xps is a mystery i'll solve some other day.
#

# used later for efi schema
#echo -n "which uefi (y/n): "
#read uefi

kiss b grub && kiss i grub 
#kiss b efibootmgr && kiss i efibootmgr

# bios only
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# uefi only
#grub-install --target=x86_64-efi \
#             --efi-directory=/boot \
#             --bootloader-id=kiss
#grub-mkconfig -o /boot/grub/grub.cfg

kiss b baseinit && kiss i baseinit 

echo "install complete! be sure to add a user and change root's password."
echo "root password: passwd"
echo "adding a user: adduser username"
