#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2019 WeakNet Labs
## Douglas Berdeaux

source ~/.bashrc # Testing this as there seems to be an issue with the $PATH for Spotifail.
APPDEV=/appdev
$DAS=Demon-App-Store
APPDEVDAS=$APPDEV/$DAS
### Generate working directories if not present:
if [ ! -d "/usr/share/demon/images/icons" ] # Store app icons, etc
  then
    mkdir -p /usr/share/demon/images/icons/
fi
if [ ! -d "/var/demon/store/app-cache" ] # Store all apps in cache area
  then
    mkdir -p /var/demon/store/app-cache/
fi

### Update to the latest workflow app:
if [ ! -d $APPDEV ]
  then
    mkdir -p $APPDEV
fi
cd $APPDEV
if [ -d $DAS ]
  then
    cd $DAS && git pull
else
  git clone https://github.com/weaknetlabs/Demon-App-Store
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
cp $APPDEVDAS/demon-app-store.sh /usr/local/sbin/
cp $APPDEVDAS/demon-app-store-workflow.sh /usr/local/sbin/
chmod +x /usr/local/sbin/demon-app-store.sh
chmod +x /usr/local/sbin/demon-app-store-workflow.sh

### Update all icons:
if [ ! -d /usr/share/demon/images/icons ]
  then
    mkdir -p /usr/share/demon/images/icons 2>/dev/null
fi
cp $APPDEVDAS/icons/* /usr/share/demon/images/icons

### Complete
printf "[!] The latest version is now installed ... \n";

### start Workflow:
/usr/local/sbin/demon-app-store-workflow.sh
