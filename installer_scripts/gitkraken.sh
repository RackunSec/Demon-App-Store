#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# GitKraken Git GUI Tool
# --------------------
# NOTES:
#   Gitkraken - GIT GUI Interface
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_APP_NAME=Gitkraken
export DAS_FILE=gitkraken-amd64.deb
export LOCALAREA=$DAS_APPCACHE/$DAS_FILE
export DAS_CHECKSUM=bb2f244c968b9bfca9b6c5763e9df698
export URL=http://demonlinux.com/download/packages/gitkraken-amd64.deb
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME

dpkg -i $1
apt -f install -y
