#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2019 WeakNet Labs
## Douglas Berdeaux

### Am I already running?
RUN=$(ps aux | egrep -E 'demon-app-[s]tore\.sh'|wc -l)
if [[ $RUN -gt 2 ]]
  then
    yad --text="\n The Demon App Store is already running. " --window-icon=/usr/share/demon/images/icons/demon-64-white.png --image=/usr/share/demon/images/icons/demon-store-icon-64-padded.png --button=Exit:0 --width=400 --height=20 --fixed
    exit 57
fi

### XFCE4 Notification
notify () {
  notify-send "$1" "$2" "$DAS_NOTIFY_ICON"
}
export -f notify
export DAS_NOTIFY_APP="Demon App Store Notification"
export DAS_NOTIFY_ICON="--icon=/usr/share/demon/images/icons/demon-store-icon.png"

notify "$DAS_NOTIFY_APP" "The Demon App Store is Initializing."

source ~/.bashrc # Testing this as there seems to be an issue with the $PATH for Spotifail.
APPDEV="/var/demon/store/code/"
DAS="Demon-App-Store"
APPDEVDAS="$APPDEV/$DAS"
### Generate working directories if not present:
if [ ! -d "/usr/share/demon/images/icons" ] # Store app icons, etc
  then
    mkdir -p /usr/share/demon/images/icons/
fi
if [ ! -d "/var/demon/store/app-cache" ] # Store all apps in cache area
  then
    mkdir -p /var/demon/store/app-cache/
fi
if [ ! -d "/usr/share/demon/desktop" ]
  then
    mkdir -p /usr/share/demon/desktop
fi

### Grab a few dependencies and update our Debian repo cache/lists
apt update 1>&2>/dev/null
apt install -y xfce4-notifyd

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
notify "$DAS_NOTIFY_APP" "The Demon App Store has been updated."

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
cp $APPDEVDAS/icons/* /usr/share/demon/images/icons # Add all the icon files
cp $APPDEVDAS/desktop/* /usr/share/demon/desktop/ # Add all the desktop icons into Demon shared area
### Complete
printf "[!] The latest version is now installed ... \n";

### start Workflow:
/usr/local/sbin/demon-app-store-workflow.sh
