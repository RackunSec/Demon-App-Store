#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Ghidra NSA Reverse Engineering Tool
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
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_INST_FILE=ghidra9.zip`
export DAS_BUILD_DEPS=""
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_BINFILE=/usr/local/sbin/ghidra9.sh
export DAS_INSTALL_AREA=/opt/ghidra
export URL=https://demonlinux.com/download/packages/ghidra9.zip
export DAS_CHECKSUM=c760ae7359b0fbdef750202d18a9b8aa
export DAS_FILE=ghidra9.zip
export LOCALAREA=$DAS_APPCACHE/$DAS_FILE
export DAS_APP_NAME="Ghidra 9"
##### Demon App Store Functions:
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME

cd $DAS_APPCACHE && unzip -o $DAS_INST_FILE
mv ghidra_9.1-BETA_DEV $DAS_INSTALL_AREA # mv locally
echo "#!/usr/bin/env bash" > $DAS_BINFILE
echo "cd /opt/ghidra && ./ghidraRun" >> $DAS_BINFILE
chmod +x $DAS_BINFILE
# copy the menu entry into /usr/share/applications:
cp $DAS_DESKTOP_CACHE/ghidra.desktop $LOCAL_APPS
