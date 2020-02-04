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
export DAS_APP_NAME=Nessus
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

export GIT_URL=https://demonlinux.com/download/packages/Nessus-8.9.0-debian6_amd64.deb
export FILE=Nessus-8.6.0-debian6_amd64.deb
export LOCALAREA=$DAS_APPCACHE/$FILE
export DAS_CHECKSUM=d76a6b3d793e424737746c810991499a
export DAS_BINFILE=/usr/local/sbin/nessus
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $GIT_URL $DAS_APP_NAME # download the file

dpkg -i $LOCALAREA
apt -f install -y
echo '#!/usr/bin/env bash' > $DAS_BINFILE
echo "/etc/init.d/nessusd start & sleep 5 && firefox https://127.0.0.1:8834" >> $DAS_BINFILE
chmod +x $DAS_BINFILE # make it executable
