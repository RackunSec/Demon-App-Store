#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Bluez
# --------------------
# NOTES:
#     The Bluetooth wireless technology is a worldwide specification for a small-form factor, low-cost radio solution that provides
# links between mobile computers, mobile phones, other portable handheld devices, and connectivity to the Internet.
# version 5.52
#
# Something NEW:
#  This module contains the "uninstall" script. Just pass that as an argument. See below.
#
export DAS_CONFIG=./das_config.txt # This is REQUIRED
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export DAS_BUILD_PIP_DEPS="libglib2.0-dev/stable dbus libdbus-1-dev/stable libudev-dev/stable libical-dev/stable libreadline-dev/stable"
export DAS_APP_NAME=Bluez
export DAS_FILE=bluez-5.52.tar.xz
export DAS_CHECKSUM=a33eb9aadf1dd4153420958709d3ce60
export DAS_LOCALAREA=$DAS_APPCACHE/$DAS_FILE
export DAS_DIR=$(echo $DAS_FILE|sed -r 's/\.tar.*//')
export DAS_URL=http://www.kernel.org/pub/linux/bluetooth/$DAS_FILE
export DAS_CONFIG_OPTS="--enable-deprecated --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-library"
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
./das_functions/checksum_check.sh $DAS_LOCALAREA $DAS_CHECKSUM $DAS_URL $DAS_APP_NAME
cd $DAS_APPCACHE/ && tar vxf $DAS_FILE
cd $DAS_DIR
if [[ "$1" == "uninstall" ]]
  then
    apt remove -y $DAS_BUILD_DEPS
    rm -rf /usr/local/bin/bluetoothctl # because of hciconfig
    ./configure $DAS_CONFIG_OPTS
    make uninstall
  else
    apt install -y $DAS_BUILD_DEPS
    ./configure $DAS_CONFIG_OPTS && make && make install
fi
