#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# SonarQube
# --------------------
# NOTES:
#   Catch bugs and vulnerabilities in your app, with thousands of automated Static Code Analysis rules.
#
export DAS_CONFIG=./das_config.txt # This is REQUIRED
##### ##### ##### ##### #####
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE | sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE | sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS | sed -r 's/[^=]+=//')
export DAS_APP_NAME=SonarQube
##### Demon App Store Variables:
# Example of pulling variable from das_config:
# $(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')

export DAS_FILE=sonarqube-7.9.1.zip
export URL=https://binaries.sonarsource.com/Distribution/sonarqube/$DAS_FILE
export LOCALAREA=$DAS_APPCACHE/$DAS_FILE
export DAS_CHECKSUM=0
export DAS_BINFILE=/usr/local/sbin/sonarqube
export INSTALLAREA=/opt/
./das_functions/checksum_check.sh $LOCALAREA $DAS_CHECKSUM $URL $DAS_APP_NAME

cd $DAS_APPCACHE && unzip $DAS_FILE
mv sonarqube-7.9.1 /opt/
chmod a+rxw -R /opt/sonarqube-7.9.1
echo "#!/usr/bin/env bash" > $DAS_BINFILE
echo 'su postgres -c "/opt/sonarqube-7.9.1/bin/linux-x86-64/sonar.sh console" &' >> $DAS_BINFILE
echo "sleep 10" >> $DAS_BINFILE # this is required because of the overhead of the service ...
echo 'firefox-esr http://127.0.0.1:9000' >> $DAS_BINFILE
chmod +x $DAS_BINFILE
