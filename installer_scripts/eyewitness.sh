#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# EyeWitness
# --------------------
# NOTES:
#
#
export DAS_CONFIG=./das_config.txt # This is REQUIRED
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
GIT_URL=https://github.com/FortyNorthSecurity/EyeWitness
DAS_BINFILE=/usr/local/sbin/EyeWitness.sh
cd /tmp && git clone $GIT_URL
cd EyeWitness
sed -ir 's/# OS Specific Installation Statement/osinfo=Kali/g' setup/setup.sh # Whoopsey Daisey!
sed -ir 's/^clear$//' setup/setup.sh # ass hats.
./setup/setup.sh
cp -R /tmp/EyeWitness /opt
echo "#!/usr/bin/env bash" > $DAS_BINFILE # generate a script to autostart the framework.
echo "cd /opt/EyeWitness && ./EyeWitness.py" >> $DAS_BINFILE
chmod +x $DAS_BINFILE
