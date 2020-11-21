#!/bin/sh
#
# stage 3: prepping for the kernal
#
# most of this is getting basic application in place for creation of the kernal
#

echo -n "hostname: "
read hostname

cd ~ # going back to root

kiss b e2fsprogs && kiss i e2fsprogs
kiss b dosfstools && kiss i dosfstools
kiss b xfsprogs && kiss i xfsprogs
# kiss b util-linux && kiss i util-linux # should have been installed with xfsprogs
kiss b eudev && kiss i eudev
kiss b wpa_supplicant && kiss i wpa_supplicant
kiss b dhcpcd && kiss i dhcpcd

echo ${hostname} > /etc/hostname
echo "127.0.0.1  ${hostname}.localdomain  ${hostname}
::1        ${hostname}.localdomain  ${hostname}  ip6-localhost
" >> /etc/hosts

kiss b libelf && kiss i libelf
kiss b ncurses && kiss i ncurses
kiss b perl && kiss i perl

# consider making something more dynamic than this... future umyemri problem
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.9.tar.xz
tar xvf linux-5.9.9.tar.xz
cd linux-*

echo 'ready for kernal generation'
echo 'follow the usual process - i\'ll make a version of this for my xps 9360'
echo 'but that\'s going to be just for me. you're mileage may very.'
