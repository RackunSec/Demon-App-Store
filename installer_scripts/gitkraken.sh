#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# GitKraken Git GUI Tool
# --------------------
# NOTES:
#
#
export DAS_CONFIG=./das_config.txt # This is REQUIRED
##### ##### ##### ##### #####
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
dpkg -i $1
apt -f install -y
