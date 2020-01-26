#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2020 WeakNet Labs
## Douglas Berdeaux

### XFCE4 Notification
notify () {
  notify-send "$1" "$2" "$3"
}
### Cleanup after CTRL+C:
trap ctrl_c INT
ctrl_c () {
  killall -9 tail
  exit
}

export -f notify
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt

export DAS_NOTIFY_APP="Demon App Store Notification"
export DAS_NOTIFY_ICON="--icon=/usr/share/demon/images/icons/demon-store-icon.png"
export DAS_NOTIFY_ICON_GRN="--icon=/usr/share/demon/images/icons/demon-store-icon-green.png"
export DAS_NOTIFY_ICON_RED="--icon=/usr/share/demon/images/icons/demon-store-icon-red.png"

network_fail () {
  notify "$DAS_NOTIFY_APP" "No network access.\nDemon App Store exiting." $DAS_NOTIFY_ICON_RED
  printf "[ERROR] no network connectivity. (DEBIAN.ORG unreachable) Exiting.\n" 1>&2
  exit 1337
}
export -f network_fail

network_test () {
  ping -c 1 debian.org || network_fail
}

export -f network_test
network_test # ensure a connection

### Am I already running?
RUN=$(ps aux | egrep -E 'demon-app-[s]tore\.sh'|wc -l)
if [[ $RUN -gt 2 ]]
  then
    yad --text="\n The Demon App Store is already running. " --window-icon=/usr/share/demon/images/icons/demon-64-white.png --image=/usr/share/demon/images/icons/demon-store-icon-64-padded.png --button=Exit:0 --width=400 --height=20 --fixed
    notify "$DAS_NOTIFY_APP" "The Demon App Store is already running."
    exit 57
fi

notify "$DAS_NOTIFY_APP" "The Demon App Store is Initializing." $DAS_NOTIFY_ICON


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
apt install -y xfce4-notifyd yad

### Update to the latest app:
# Remove the old app files:
rm -rf $APPDEV
mkdir $APPDEV
cd $APPDEV && git clone https://github.com/weaknetlabs/Demon-App-Store
# remove the old scripts from the $PATH:
if [ -f /usr/local/sbin/demon-app-store.sh ]
  then
    rm /usr/local/sbin/demon-app-store.sh
fi
if [ -f /usr/local/sbin/demon-app-store-worklflkow.sh ]
  then
    rm /usr/local/sbin/demon-app-store-workflow.sh
fi

### Copy the new scripts into $PATH:
cp $APPDEVDAS/demon-app-store.sh /usr/local/sbin/
cp $APPDEVDAS/demon-app-store-workflow.sh /usr/local/sbin/
# Make them executable:
chmod +x /usr/local/sbin/demon-app-store.sh
chmod +x /usr/local/sbin/demon-app-store-workflow.sh

### Update all icons:
if [ ! -d /usr/share/demon/images/icons ]
  then
    mkdir -p /usr/share/demon/images/icons 2>/dev/null
fi
printf "[i] Copying new icon images from ($APPDEVDAS/icons/)... \n"
cp $APPDEVDAS/icons/* /usr/share/demon/images/icons/ # Add all the icon files
cp $APPDEVDAS/desktop/* /usr/share/demon/desktop/ # Add all the desktop icons into Demon shared area
### Complete
# Get the new version:
export DAS_VERSION=$(cat $DAS_CONFIG|grep DAS_VERSION|sed -r 's/[^=]+=//')
# Notify user:
notify "$DAS_NOTIFY_APP" "The Demon App Store has been updated\nto version: $DAS_VERSION" "$DAS_NOTIFY_ICON_GRN"

### start Workflow:
/usr/local/sbin/demon-app-store-workflow.sh
