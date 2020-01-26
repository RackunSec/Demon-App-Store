#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Bloodhound
# --------------------
# NOTES:
#   This is a HUGE package/module.
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
export GIT_URL=https://github.com/adaptivethreat/Bloodhound
export DAS_BUILD_DEPS="--no-install-recommends gnome-keyring -y"
export DAS_BUILD_PIP_DEPS=""
export DAS_PYTHON_VERSION=3
export BH_GIT_URL=https://github.com/BloodHoundAD/BloodHound/releases/download/2.2.1/BloodHound-linux-x64.zip

##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
NEOCHECKSUM=4f625988b580eacaf7daef1cb8c98622
NEO4JURL=https://demonlinux.com/download/packages/neo4j-desktop-offline-1.2.1-x86_64.AppImage
NEOFILE=neo4j-desktop-offline-1.2.1-x86_64.AppImage
LOCALAREA=${DAS_APPCACHE}/$NEOFILE
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $NEOCHECKSUM $NEO4JURL "Neo4J (WNL Mirror)" # download Neo4J
chmod +x $LOCALAREA
cp $LOCALAREA /usr/local/sbin/neo4j-start # copy the binary into the $PATH, keep original for checksum/bandwidth
apt install $DAS_BUILD_DEPS # needed for web interface of Neo4J
# Install Bloodhound:
BHFILE=BloodHound-linux-x64.zip
LOCALAREA=${DAS_APPCACHE}/$BHFILE
BHCHECKSUM=c0c25df56b7eaaefd8ac2e9214c5fbe6
BINFILE=/usr/local/sbin/BloodHound.sh
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $BHCHECKSUM $BH_GIT_URL "$app Release (GitHUB)" # git the BloodHound Release
cd /opt/ && git clone $GIT_URL BloodHoundFiles # git the BloodHound Files
cd $DAS_APPCACHE && unzip -o $BHFILE # unzip the BloodHound "release"
mv BloodHound-linux-x64 /opt/
echo "#!/usr/bin/env bash" > $BINFILE
echo "cd /opt/BloodHound-linux-x64 && ./BloodHound" >> $BINFILE
chmod +x $BINFILE
