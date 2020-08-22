#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Neo4j
# --------------------
# NOTES:
#
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_FUNC_SCRIPT_DIR|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export DAS_BUILD_PIP_DEPS="libglib2.0-dev/stable dbus libdbus-1-dev/stable libudev-dev/stable libical-dev/stable libreadline-dev/stable"
export DAS_APP_NAME=Neo4j
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
echo 'deb https://debian.neo4j.com stable 4.0' > /etc/apt/sources.list.d/neo4j.list
sudo apt-get update
rm -rf /var/lib/neo4j
apt purge neo4j -y
apt install neo4j -y
