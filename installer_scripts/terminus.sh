#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Terminus
# --------------------
# NOTES:
#
#
export DAS_CONFIG=./das_config.txt # This is REQUIRED
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/wiire/pixiewps/archive/master.zip
export DAS_APP_NAME=Terminus
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
GIT_URL=https://github.com/Eugeny/terminus/releases/download/v1.0.91/terminus-1.0.91-linux.deb
DAS_CHECKSUM=97d337c59e7d03b474b03e83348898d0
DAS_FILE=terminus-1.0.91-linux.deb
LOCALAREA=$DAS_APPCACHE/$DAS_FILE
./das_functions/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $GIT_URL $app # Download the file ...
dpkg -i $LOCALAREA
apt -f install -y # clean up after .deb
sed -ri 's/%U/%U --no-sandbox/g' /usr/share/applications/terminus.desktop # whoopsey daisey!!
