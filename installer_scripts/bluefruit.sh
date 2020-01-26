#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Bluefruit
# --------------------
# NOTES:
#   The Python API for Adafruit's Bluefruit LE Sniffer, and our easy to use API wrapper.
#
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt # This is required
export DAS_FUNC_SCRIPT_DIR=$(cat $DAS_FUNC_SCRIPT_DIR|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
##### ##### ##### ##### #####
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export GIT_URL=https://github.com/adafruit/Adafruit_BLESniffer_Python.git
export DAS_BUILD_PIP=pyserial
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export LOCALAREA=/infosec/
export DAS_BIN_FILE=/usr/local/sbin/bluefruit_sniffer.sh
mkdir /infosec/bluetooth 2>/dev/null
cd /infosec/bluetooth
git clone $GIT_URL Bluefruit
pip install $DAS_BUILD_PIP
echo "#!/usr/bin/env bash" > $DAS_BIN_FILE
echo "cd /infosec/bluetooth/Bluefruit && python sniffer.py -h" >> $DAS_BIN_FILE
chmod +x $DAS_BIN_FILE
cp $DAS_DESKTOP_CACHE/bluefruit.desktop ${SYS_LOCAL_APPS} # copy in the desktop / menu icon
