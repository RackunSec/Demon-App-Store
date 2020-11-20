#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# SERT.py
# --------------------
# NOTES:
# from GitHUB: https://github.com/weaknetlabs/SERT.git
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/weaknetlabs/SERT.git
export DAS_BUILD_DEPS=dnsmasq
export DAS_BUILD_PIP_DEPS=pyric
export DAS_PYTHON_VERSION=3
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
mkdir -p /cyberpunk/forensics
cd /cyberpunk/forensics && git clone $GIT_URL
cd /cyberpunk/forensics/SERT
cp sert.py /usr/local/sbin # copy the binary into the $PATH
cp sert.desktop $SYS_LOCAL_APPS # copy in the desktop menu file
