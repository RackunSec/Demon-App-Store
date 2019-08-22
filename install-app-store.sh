#!/bin/bash
rm /usr/local/sbin/demon-app-store.sh 2>/dedv/null
cp demon-app-store.sh /usr/local/sbin/
chmod +x /usr/local/sbin/demon-app-store.sh
mkdir -p /usr/share/demon/images/icons 2>/dev/null
cp icons/* /usr/share/demon/images/icons
cp Demon\ App\ Store.desktop /root/Desktop/
