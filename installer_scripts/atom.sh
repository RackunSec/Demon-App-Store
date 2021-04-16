#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Nessus
# --------------------
# NOTES:
#   You'll have to accept the license
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export DAS_APP_NAME="Atom IDE"
#export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
if [[ "$1" == "uninstall" ]]
then # uninstall it:
  apt remove atom -y
else
  export FILE=atom-amd64.deb
  export URL=https://demonlinux.com/download/packages/$FILE
  export LOCALAREA=$DAS_APPCACHE/$FILE
  export DAS_CHECKSUM=e8ba29627646dc6455b3ab0a18d30cc5
  $DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME # download the file
  cd $DAS_APPCACHE && dpkg -i $FILE
  apt -f install -y
fi
