#!/bin/sh
#
# stage 4: kernel generation
#
# method that i used was the localyesconfig but there is ways of just copying
# the config from the arch installer.
#

echo -n "version number of kernel: "
read linux_ver

# move to where the kernel package and .config is
cd ~/linux-${linux_ver}

make -j "$(nproc)" 
make install

mv /boot/vmlinuz    /boot/vmlinuz-${linux_ver}
mv /boot/System.map /boot/System.map-${linux_ver}    
