#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# PWNDrop
# --------------------
# NOTES:
#   https://github.com/kgretzky/pwndrop
#   GitHUB - has self installer
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
export GIT_URL=https://raw.githubusercontent.com/kgretzky/pwndrop/master/install_linux.sh
export FILE=install_linux.sh
export LOCALAREA=$DAS_APPCACHE/$FILE
export BINPATH=/usr/local/sbin/
export BINARY=$BINPATH/pwndrop-start.sh
touch $BINARY
echo "#!/usr/bin/env bash" > $BINARY # start the startup script
echo "/etc/init.d/apache2 stop 2>/dev/null # stop Apache2" >> $BINARY
echo "netstat -pan | grep LISTEN | grep 443 | awk '{print \$7}' | sed -r 's/[^0-9]+//g' | xargs -I {} kill {}" >> $BINARY # kill anything running on 443
echo "netstat -pan | grep LISTEN | grep 80 | awk '{print \$7}' | sed -r 's/[^0-9]+//g' | xargs -I {} kill {}" >> $BINARY # kill anything running on 80
echo "cd /usr/local/pwndrop && sudo ./pwndrop &" >> $BINARY
echo "sleep 5 && firefox https://127.0.0.1/pwndrop" >> $BINARY # pause before opening UI to let it load
echo "exit 0 " >> $BINARY
chmod +x $BINARY # make it executable
curl $GIT_URL | sudo bash # run the self installer - tested 04.17.2020 working OK in DEMON 2.4.6
cp $DAS_DESKTOP_CACHE/pwndrop.desktop $SYS_LOCAL_APPS # copy in the icon into the desktop menu
exit 0
