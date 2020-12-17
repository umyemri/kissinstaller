#!/bin/sh
#
# stage 2: repo pull
#
# kiss-chroot doesn't act like arch-chroot
#

# . /etc/profile.d/kiss_path.sh
cd /var/db/kiss/
git clone https://github.com/kisslinux/repo 
git clone https://github.com/kisslinux/community
kiss build gnupg1
kiss install gnupg1
gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E
echo trusted-key 0x46d62dd9f1de636e >> /root/.gnupg/gpg.conf
cd /var/db/kiss/repo 
git config merge.verifySignatures true
kiss update
cd /var/db/kiss/installed

echo "done! but you need to run kiss update again."
echo "after that run the below when you've got time:"
echo "kiss build *"
