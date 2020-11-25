#!/bin/sh
#
# stage 4: kernel generation
#
# method that i used was the localyesconfig but there are ways of just copying
# the config from the arch installer.
#

# alternative... if you're not interested in combing through kernel make commands
#echo -n "copy arch kernel config (y/n): "
#read arch
#if arch = 'y'; then
#    linux_ver = ${uname -r | sed '/\d*\.\d*\.\d*/g'}
#    #uname -r | awk '/\d*\.\d*\.\d*/{ print $0 }' # not sure why these aren't working...
#    zcat /proc/config.gz > ~/linux-${linux_ver}/.config
#else

echo -n "version number of kernel (ex. 5.9.2): "
read linux_ver

#fi

# move to where the kernel package and .config is
cd ~/linux-${linux_ver}

make -j "$(nproc)" #long process here
make install

mv /boot/vmlinuz    /boot/vmlinuz-${linux_ver}
mv /boot/System.map /boot/System.map-${linux_ver}    
