#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2019 WeakNet Labs
## Douglas Berdeaux

source ~/.bashrc # Testing this as there seems to be an issue with the $PATH for Spotifail.

### Generate working directories if not present:
if [ ! -d "/usr/share/demon/store/app-cache" ] # Store app icons, etc
  then
    mkdir -p /usr/share/demon/images/icons/
fi
if [ ! -d "/var/demon/" ] # Store all apps in cache area
  then
    mkdir -p /var/demon/app-cache
fi

### Update to the latest workflow app:
if [ ! -d /appdev/ ]
  then
    mkdir -p /appdev
    cd /appdev
    git clone https://github.com/weaknetlabs/Demon-App-Store
else
  if [ -d /appdev/Demon-App-Store ]
    then
      rm -rf /appdev/Demon-App-Store # remove it
      # recreate it:
      cd /appdev && git clone https://github.com/weaknetlabs/Demon-App-Store
  fi
fi

if [ -f /usr/local/sbin/demon-app-store.sh ]
  then
    rm /usr/local/sbin/demon-app-store.sh
fi
if [ -f /usr/local/sbin/demon-app-store-worklflkow.sh ]
  then
    rm /usr/local/sbin/demon-app-store-workflow.sh
fi

### Copy the new executable:
cd /appdev/Demon-App-Store
cp demon-app-store.sh /usr/local/sbin/
cp demon-app-store-workflow.sh /usr/local/sbin/
chmod +x /usr/local/sbin/demon-app-store.sh
chmod +x /usr/local/sbin/demon-app-store-workflow.sh

### Update all icons:
if [ ! -d /usr/share/demon/images/icons ]
  then
    mkdir -p /usr/share/demon/images/icons 2>/dev/null
fi
cp icons/* /usr/share/demon/images/icons

### Complete
printf "[!] The latest version is now installed ... \n";

### start Workflow:
demon-app-store-workflow.sh
