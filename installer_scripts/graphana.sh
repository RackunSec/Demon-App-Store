#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Graphana
# --------------------
# NOTES:
#   open source analytics & monitoring solution for every database.
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export DAS_BUILD_PIP_DEPS=""
export DAS_APP_NAME=Graphana
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

DAS_FILE=grafana_6.3.3_amd64.deb
LOCALAREA=$DAS_APPCACHE/$DAS_FILE
DAS_CHECKSUM=bb2f244c968b9bfca9b6c5763e9df698
DAS_BINFILE=/usr/local/sbin/grafana
URL=https://dl.grafana.com/oss/release/grafana_6.3.3_amd64.deb
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME
dpkg -i $LOCALAREA
apt -f install -y
echo "#!/bin/bash" > $DAS_BINFILE
echo "service grafana-server start" >> $DAS_BINFILE
echo "firefox http://127.0.0.1:3000" >> $DAS_BINFILE
chmod +x $DAS_BINFILE
cp $DAS_DESKTOP_CACHE/grafana.desktop $SYS_LOCAL_APPS # copy the desktop icon over.
