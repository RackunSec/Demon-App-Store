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
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/wifiphisher/wifiphisher.git
export DAS_BUILD_DEPS=dnsmasq
export DAS_BUILD_PIP_DEPS=pyric
export DAS_PYTHON_VERSION=3
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
cd /infosec/wifi && git clone $GIT_URL
pip${DAS_PYTHON_VERSION} install $DAS_BUILD_PIP_DEPS
apt install $DAS_BUILD_DEPS -y
cd /infosec/wifi/wifiphisher && python${DAS_PYTHON_VERSION} setup.py build
cd /infosec/wifi/wifiphisher && python${DAS_PYTHON_VERSION} setup.py install
# The icon was copied already at init, we need to copy the desktop file into usr/share/applications/
cp $DAS_DESKTOP_CACHE/wifiphisher.desktop $SYS_LOCAL_APPS
