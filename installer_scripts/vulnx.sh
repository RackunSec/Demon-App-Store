#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Vulnx 2.0
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
export DAS_APP_NAME=PwnDrop
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

export GIT_URL=https://github.com/anouarbensaad/vulnx
cd $DAS_APPCACHE && git clone $GIT_URL
cd $DAS_APPCACHE/vulnx && chmod +x install.sh && ./install.sh
cp $DAS_DESKTOP_CACHE/vulnx.desktop $SYS_LOCAL_APPS # copy in the icon into the desktop menu
exit 0
