#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# AWUS1900 DKMS Driver from Aircrack-NG GitHUB
# --------------------
# NOTES:
# Use iw dev <device> set type monitor instead of airmon-ng
#
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
DAS_DL_URL=https://github.com/aircrack-ng/rtl8812au
DAS_BUILD_DIR=rtl8812au
DAS_BUILD_DEPS="dkms git"
##### Demon App Store Functions:
apt -y install $DAS_BUILD_DEPS -y # install all depends
cd /tmp/ && git clone $DAS_DL_URL
cd /tmp/$DAS_BUILD_DIR
./dkms-install.sh # install it with DKMS
### Complete.