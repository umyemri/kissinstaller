#!/bin/sh
#
# stage 4: kernel generation
#
# method that i used was the localyesconfig but there are ways of just copying
# the config from the arch installer.
#

echo -n "version number of kernel (ex. 5.9.2): "
read linux_ver

# move to where the kernel package and .config is
cd ~/linux-${linux_ver}

make -j "$(nproc)" #long process here
make install

mv /boot/vmlinuz    /boot/vmlinuz-${linux_ver}
mv /boot/System.map /boot/System.map-${linux_ver}    
