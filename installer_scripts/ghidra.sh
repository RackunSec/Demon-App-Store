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
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt
##### ##### ##### ##### #####
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_INST_FILE=ghidra9.zip
export DAS_BUILD_DEPS=""
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_BINFILE=/usr/local/sbin/ghidra9.sh
export DAS_INSTALL_AREA=/opt/ghidra

##### Demon App Store Functions:
cd $DAS_APPCACHE && unzip -o $DAS_INST_FILE
mv ghidra_9.1-BETA_DEV $DAS_INSTALL_AREA # mv locally
echo "#!/usr/bin/env bash" > $DAS_BINFILE
echo "cd /opt/ghidra && ./ghidraRun" >> $DAS_BINFILE
chmod +x $DAS_BINFILE
# copy the menu entry into /usr/share/applications:
cp $DAS_DESKTOP_CACHE/ghidra.desktop $LOCAL_APPS
