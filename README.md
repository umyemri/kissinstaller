# kissinstaller
https://k1ss.org  
This will be will be an installer for k1ss linux. Still need to do some probing into the project however.

This is a very individualistic installer. It is sectioned out in stages. At the end of those sections
you should be doing some either very long thought out processes or mechanisms that take time. For the 
thought based sections: you will need to study your own hardware and what is needed.

To get started:  
```shell
curl -sL https://git.io/JLcN7 > prep.sh
```

Build Time:
stage 1-2: 37 minute mark
stage 3: 46 minute mark (9 minutes)
stage 4: 1:11 hour mark (25 minutes)
stage 5: 1:19 hour total  (8 minutes)

## goals
Priorities:
1. ~~Wayland + some wm manager~~ nope! Well... maybe: https://github.com/dilyn-corner/KISS-kde this really is an interesting approach.
    - https://github.com/kisslinux/wiki/blob/master/wayland/install-wayland.txt
2. Media: mpv / svix / w3m / cmus / ranger combo
3. Wireless: wpa_sup + wg
4. Big Apps: Firefox / Krita / Blender / Latex
    - krita: https://github.com/dilyn-corner/KISS-kde/tree/master/kde/krita
    - blender: pending
    - Latex: https://www.reddit.com/r/kisslinux/comments/i2x7bn/who_uses_kiss_linux/g1k9clb?utm_source=share&utm_medium=web2x&context=3
5. ~~Games: Enough to run renpy or simple unity apps (wine?)~~ probably just get qemu / chroot

~~Lost a lot of priorities after reading the k1ss site more deeply... Still~~ I like the philosophy.
