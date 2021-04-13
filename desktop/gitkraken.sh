#!/usr/bin/env bash
# 2021 Demon App Store
# RackunSec
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# GitKraken https://obsidian.md/
# --------------------
# NOTES:
#   Vulnx is An Intelligent Bot Auto Shell Injector that detects vulnerabilities in multiple types of Cms,
#    fast cms detection,informations gathering and vulnerabilitie Scanning of the target like subdomains,
#    ipaddresses, country, org, timezone, region, ans and more ...
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
export DAS_APP_NAME="Gitkraken"
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export APPFILE=gitkraken-amd64.deb
export STARTUP_SCRIPT=/usr/local/bin/obsidian
export URL=https://demonlinux.com/download/packages/${APPFILE}
export DAS_CHECKSUM=0f57aaa3e26c4591c489b6fedcdb2730
export LOCALAREA=$DAS_APPCACHE/$APPFILE
### UNINSTALL:
if [[ "$1" == "uninstall" ]]
  then
    apt remove gitkraken -y # don't forget about meeeeeeeeeeeee!!!!
    exit 0
fi
$DAS_FUNC_SCRIPT_DIR/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME # download the file
printf "[debug]: ${LOCALAREA}"
dpkg -i $LOCALAREA
apt -f install -y # just incake
echo "#!/usr/bin/env bash" >> $STARTUP_SCRIPT
echo "/usr/share/gitkraken/gitkraken --no-sandbox" >> $STARTUP_SCRIPT
chmod +x $STARTUP_SCRIPT
exit 0
