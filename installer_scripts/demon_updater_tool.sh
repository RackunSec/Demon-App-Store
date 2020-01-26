#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Demon Updater Tool
# --------------------
# NOTES:
#  Should only be used in Demon Linux
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
##### ##### ##### ##### #####
##### Demon App Store Variables:
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
LOCALAREA=/var/demon/updater/code/Demon-Update-Tool
rm -rf /var/demon/updater # this is okay, since we are "installing" the app.
mkdir -p /var/demon/updater/code
cd /var/demon/updater/code && git clone https://github.com/weaknetlabs/Demon-Update-Tool.git
cp ${LOCALAREA}/demon-updater.sh /usr/local/sbin/
cp ${LOCALAREA}/demon-updater-workflow.sh /usr/local/sbin/
chmod +x /usr/local/sbin/demon-updater* # make them executable
cp ${LOCALAREA}/demon-updater.desktop /usr/share/applications/ # copy the menu icon in
cp ${LOCALAREA}/images/updater.png /usr/share/demon/images/icons/ # copy in our new icon
