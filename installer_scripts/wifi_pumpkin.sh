#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# WiFi PUmpkin
# --------------------
# NOTES:
#
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/P0cL4bs/WiFi-Pumpkin.git
export DAS_BUILD_DEPS="pkg-config libnl-3-dev libnl-genl-3-dev libnfnetlink-dev libnetfilter-queue-dev isc-dhcp-server"
export DAS_BUILD_PIP_DEPS=""
export DAS_PYTHON_VERSION=3
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
# Depends from APT:
apt install -y $DAS_BUILD_DEPS
# Git the repo:
cd /opt && git clone $GIT_URL
cd WiFi-Pumpkin
# Depends from Python:
pip install -r requirements.txt
# Annnd, we also need to do this:
pip install --upgrade pyasn1-modules
# more bad practices ...
sed -ir 's/\tclear$//' installer_wifimode.sh
# This script ... seriously.
sed -ir 's/^INSTALL_DIR=.*/INSTALL_DIR=\/opt\/WiFi-Pumpkin\/plugins\/bin\/hostapd-mana/' installer_wifimode.sh
sed -ir 's/^CURRENT_DIR=.*/CURRENT_DIR=\/opt\/WiFi-Pumpkin\/plugins\/bin\/hostapd-mana/' installer_wifimode.sh
# now, we can run it safely ...
./installer_wifimode.sh # run the "installer" script
sed -ir 's/.usr.share./\/opt\//' wifi-pumpkin # remove the share location for something more sane
# update the menu icon to fit properly into Demon Menu:
echo "Categories=wifihacking" >> wifi-pumpkin.desktop
# update the icon: (TODO recommend to the WF-P dev to use standard locations at some point)
sed -ir 's/.usr.share.WiFi-Pumpkin.icons.icon.png/\/opt\/WiFi-Pumpkin\/icons\/icon.png/' wifi-pumpkin.desktop
# allow me ...
sed -ir 's/gksudo //' wifi-pumpkin.desktop # c'mon, man.
cp /opt/WiFi-Pumpkin/plugins/bin/hostapd-mana/hostapd /usr/local/sbin/
cp /opt/WiFi-Pumpkin/plugins/bin/hostapd-mana/hostapd_cli /usr/local/sbin/
cp wifi-pumpkin.desktop $SYS_LOCAL_APPS # copy the menu icon into local share
cp wifi-pumpkin /usr/local/sbin/ # copy the script that runs the app
