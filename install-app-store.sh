#!/bin/bash
## This will install the Demon App Store into /usr/local/sbin
### Remove any previous version:
if [ -f /usr/local/sbin/demon-app-store.sh ]
  then
    rm /usr/local/sbin/demon-app-store.sh
fi
### Copy the new executable:
cp demon-app-store.sh /usr/local/sbin/
chmod +x /usr/local/sbin/demon-app-store.sh
### Update all icons:
if [ ! -d /usr/share/demon/images/icons ]
  then
    mkdir -p /usr/share/demon/images/icons 2>/dev/null
fi
cp icons/* /usr/share/demon/images/icons
printf "[!] The patest version is now installed ... \n";
#    cp Demon\ App\ Store.desktop /root/Desktop/ # Terrible XFCE4 and Thunar BUG prevents this sadly
