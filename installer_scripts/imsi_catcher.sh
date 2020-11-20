#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# IMSI-Catcher
# --------------------
# NOTES:
#   I think this only works with 2G. I can't find any 2G networks in my city.
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_BINFILE=/usr/local/sbin/imsi-catcher
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/Oros42/IMSI-catcher.git
export DAS_APP_NAME=IMSI-Catche
export DAS_BUILD_DEP="python-numpy python-scipy python-scapy gr-gsm"
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

if [ ! -d /cyberpunk/rf ]
  then
    mkdir -p /cyberpunk/rf
fi
if [ ! -d /cyberpunk/rf/IMSI-catcher ] # /cyberpunk/rf/ should be tehre by now
  then
    cd /cyberpunk/rf && git clone $GIT_URL
else
    cd /cyberpunk/rf/IMSI-catcher && git pull
fi
apt -y install $DAS_BUILD_DEP
cp $DAS_DESKTOP_CACHE/imsi-catcher.desktop $SYS_LOCAL_APPS
echo '#!/usr/bin/env bash' > $DAS_BINFILE
echo "cd /cyberpunk/rf/IMSI-catcher && ls --color=auto " >> $DAS_BINFILE
chmod +x $DAS_BINFILE # make it executable
