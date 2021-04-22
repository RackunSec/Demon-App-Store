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
export DAS_APP_NAME="BloodHound x64"
#export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
if [[ "$1" == "uninstall" ]]
then
  printf "[log] Uninstalling BloodHoundx64 ... \n"
  rm -rf /cyberpunk/windows-domains/BloodHound-linux-x64*
  rm $LOCAL_APPS/bloodhound.desktop # remove the menu icon
else
  export FILE=BloodHound-linux-x64.zip
  export URL=https://demonlinux.com/download/packages/$FILE
  export LOCALAREA=$DAS_APPCACHE/$FILE
  export DAS_CHECKSUM=10a90643338662b56b19e99d7cbf27ab
  $DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME # download the file
  cp $DAS_APPCACHE/$FILE /cyberpunk/windows-domains/
  cd /cyberpunk/windows-domains/ && unzip $FILE && rm $FILE
  cp $DAS_DESKTOP_CACHE/bloodhound.desktop $LOCAL_APPS
fi
