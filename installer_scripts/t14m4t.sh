#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# T14m4t
# --------------------
# NOTES:
#   t14m4t is an automated brute-forcing attack tool, wrapper of THC-Hydra and Nmap Security Scanner.
#   https://github.com/MS-WEB-BN/t14m4t
#   GitHUB - Binary into $PATH + /usr/share/t14m4t/Wordlist
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

export GIT_URL=https://github.com/MS-WEB-BN/t14m4t
cd $DAS_APPCACHE && git clone $GIT_URL
cd $DAS_APPCACHE/t14m4t && cp t14m4t /usr/local/bin/
chmod +x /usr/local/bin/t14m4t
mkdir /usr/share/t14m4t
cp -R $DAS_APPCACHE/t14m4t/Wordlist /usr/share/t14m4t/
cp $DAS_DESKTOP_CACHE/t14m4t.desktop $SYS_LOCAL_APPS # copy in the icon into the desktop menu
exit 0
