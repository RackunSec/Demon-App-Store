#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2020 WeakNet Labs
## Douglas Berdeaux

source ~/.bashrc # Testing this as there seems to be an issue with the $PATH

### Cleanup after CTRL+C:
trap ctrl_c INT
ctrl_c () {
  killall -9 tail
  exit
}

# I chose "DAS_" as a prefix for exportation purposes, "(D)emon (A)pp (S)tore"
# This way I don't accidentally overwrite anything else (hoopefully) in the environment.
export DAS_LOCAL=/var/demon/store/code/Demon-App-Store/
export DAS_CONFIG=${DAS_LOCAL}das_config.txt
export DAS_INST_SCRIPTS_DIR=$(cat $DAS_CONFIG|grep DAS_INST_SCRIPTS_DIR|sed -r 's/[^=]+=//')
export DAS_SPANFONT=$(cat $DAS_CONFIG|grep DAS_SPANFONT|sed -r 's/[^=]+=//')
export DAS_WINDOWICON=$(cat $DAS_CONFIG|grep DAS_WINDOWICON|sed -r 's/[^=]+=//')
export DAS_WINDOWIMAGE=$(cat $DAS_CONFIG|grep DAS_WINDOWIMAGE|sed -r 's/[^=]+=//')
export DAS_WINDOWLONGIMAGE=$(cat $DAS_CONFIG|grep DAS_WINDOWLONGIMAGE|sed -r 's/[^=]+=//')
export DAS_APPNAME=$(cat $DAS_CONFIG|grep DAS_APPNAME|sed -r 's/[^=]+=//')
export DAS_APPTEXT=$(cat $DAS_CONFIG|grep DAS_APPTEXT|sed -r 's/[^=]+=//')
export DAS_APPCACHE=$(cat $DAS_CONFIG|grep DAS_APPCACHE|sed -r 's/[^=]+=//')
export SYS_LOCAL_APPS=$(cat $DAS_CONFIG|grep SYS_LOCAL_APPS|sed -r 's/[^=]+=//')
export DAS_DESKTOP_CACHE=$(cat $DAS_CONFIG|grep DAS_DESKTOP_CACHE|sed -r 's/[^=]+=//')
export DAS_WIDTH=$(cat $DAS_CONFIG|grep DAS_WIDTH|sed -r 's/[^=]+=//')
export DAS_HEIGHT=$(cat $DAS_CONFIG|grep DAS_HEIGHT|sed -r 's/[^=]+=//')
export DAS_CAT_PEN=$(cat $DAS_CONFIG|grep DAS_CAT_PEN|sed -r 's/[^=]+=//')
export DAS_CAT_FOR=$(cat $DAS_CONFIG|grep DAS_CAT_FOR|sed -r 's/[^=]+=//')
export DAS_CAT_SYS=$(cat $DAS_CONFIG|grep DAS_CAT_SYS|sed -r 's/[^=]+=//')
export DAS_CAT_DVR=$(cat $DAS_CONFIG|grep DAS_CAT_DVR|sed -r 's/[^=]+=//')
export DAS_CAT_ENG=$(cat $DAS_CONFIG|grep DAS_CAT_ENG|sed -r 's/[^=]+=//')
export DAS_CAT_NOT=$(cat $DAS_CONFIG|grep DAS_CAT_NOT|sed -r 's/[^=]+=//')
export DAS_CAT_DEV=$(cat $DAS_CONFIG|grep DAS_CAT_DEV|sed -r 's/[^=]+=//')
export DAS_CAT_WEB=$(cat $DAS_CONFIG|grep DAS_CAT_WEB|sed -r 's/[^=]+=//')
export DAS_CAT_COM=$(cat $DAS_CONFIG|grep DAS_CAT_COM|sed -r 's/[^=]+=//')
export DAS_CAT_INFO=$(cat $DAS_CONFIG|grep DAS_CAT_INFO|sed -r 's/[^=]+=//')
export DAS_CAT_MM=$(cat $DAS_CONFIG|grep DAS_CAT_MM|sed -r 's/[^=]+=//')
export DAS_CAT_NET=$(cat $DAS_CONFIG|grep DAS_CAT_NET|sed -r 's/[^=]+=//')
export DAS_CAT_DEM=$(cat $DAS_CONFIG|grep DAS_CAT_DEM|sed -r 's/[^=]+=//')
export DAS_NOTIFY_APP=$(cat $DAS_CONFIG|grep DAS_NOTIFY_APP|sed -r 's/[^=]+=//')
export DAS_NOTIFY_ICON=$(cat $DAS_CONFIG|grep DAS_NOTIFY_ICON|sed -r 's/[^=]+=//')
export DAS_NOTIFY_ICON_GRN=$(cat $DAS_CONFIG|grep DAS_NOTIFY_ICON_GRN|sed -r 's/[^=]+=//')
export DAS_NOTIFY_ICON_RED=$(cat $DAS_CONFIG|grep DAS_NOTIFY_ICON_RED|sed -r 's/[^=]+=//')
export DL_PKG_URL=$(cat $DAS_CONFIG|grep DL_PKG_URL|sed -r 's/[^=]+=//')
export DAS_DL_ICON=$(cat $DAS_CONFIG|grep DAS_DL_ICON|sed -r 's/[^=]+=//')

export DAS_DEBUG="False" # change to "True" to see debug info during app installation / checking ...

export LOCAL_APPS=/usr/share/applications/

### Fail gracefully if ran alone (should be called by demon-app-store.sh):
if [ ! -d /var/demon/store/app-cache ]
  then
    yad --center --window-icon=$DAS_WINDOWICON --image=$DAS_WINDOWIMAGE --text="\nERROR: '<b>demon-app-store-workflow.sh</b>' should not be ran alone.\nPlease run '<b>demon-app-store.sh</b>' instead.\n" \
    --button=Exit:0 --title="!! FATAL !!" --width=480 --fixed
    exit 1337;
fi

### HELP Dialog needs exported to be called from button press:
help () {
  yad --on-top --center --width=550 --height=100 --title="Demon App Store HELP" --fixed --button=Exit:0 --image=$DAS_WINDOWIMAGE --window-icon=$DAS_WINDOWICON \
  --text="\n<b>To install an app:</b> simply click the checkbox under the 'Install' column.\n\
<b>To uninstall an app:</b> simply click the checkbox under the 'Uninstall' column.\n\
Then, click 'Check Out' and all of your changes will be made.\n\
<b>To clean the local cache</b> of downloaded packages, simply click 'Clean Cache'\n\n\
  \n2019 WeakNet Labs (Douglas Berdeaux), DemonLinux.com\n"
}
export -f help # kinda cool. We basically temporarily make a command in our $PATH out of a function.

### start the "installing app: XYZ" progress bar dialog:
progressBar () {
   tail -f /etc/issue |yad --progress --pulsate --auto-close --text="\n$DAS_SPANFONT $1 </span>\n" --width=350 --center\
   --title=$DAS_APPNAME --window-icon=$DAS_WINDOWICON --percentage=13 --progress-text="Please wait ..." --image=$DAS_WINDOWIMAGE --undecorated --no-buttons &
}
export -f progressBar

### This function stops the loading bar message box by killing tail:
killBar () {
 killall -KILL tail 2>/dev/null
}
export -f killBar

### XFCE4 Notification
notify () { # Pass to me the Title,Message,Icon
  notify-send "$1" "$2" "$3"
}
export -f notify

### Clean App-Cache:
cleanCache () {
  progressBar "Cleaning out cache directory ... "
  usage=$(du -h $DAS_APPCACHE | tail -n 1 | awk '{print $1}')
  rm -rf $DAS_APPCACHE/*
  bash -c killBar
  yad --on-top --center --width=550 --height=100 --title="Demon App Store - Cache Cleanup" --fixed --button=Exit:0 --image=$DAS_WINDOWIMAGE --window-icon=$DAS_WINDOWICON \
  --text="\nApp cache area is now clean. \nA total of $usage was freed.\n"
}
export -f cleanCache # now it's a command, so-to-speak.

### Downloading files with progress:
downloadFile () { # pass to me "URI,Title,OutputFile" :)
  wget $1 --no-check-certificate -U mozilla -O $3  2>&1 | sed -u 's/^[a-zA-Z\-].*//; s/.* \{1,2\}\([0-9]\{1,3\}\)%.*/\1\n#Downloading ...\1%/; s/^20[0-9][0-9].*/#Done./'\
  | yad --progress --title="Download in Progress" --window-icon=$DAS_WINDOWICON --image=$DAS_DL_ICON --width=350 --center --text="\nDownloading $2 ... " --auto-close --no-buttons --undecorated
}

### All done?
complete () { # "--fixed" actually fixes a height issue BUG here:
  # I'm aaaalll duuuhhhhh-uuuuhhhnnnnnnne!
  yad --text="\nThank you for visting the Demon Linux App Store.  " --height=10 --fixed --title=$DAS_APPNAME --image=$DAS_WINDOWIMAGE --window-icon=$DAS_WINDOWICON --button=Exit:1
}

### Checksum checker:
checksumCheck () {
  FILE=$1
  CHECKSUM=$2
  URL=$3
  APP=$4
  if [ -f $FILE ]
    then # File exists, check the checksum given:
      printf "[+] Cached file found: $FILE\n"
      if [[ ! $(md5sum $FILE) =~ $CHECKSUM ]]
        then # failed, re-download
          rm -rf $FILE # remove borked version
          printf "[i] $APP Failed checksum check ($CHECKSUM). Re-downloading file: $URL \n"
          downloadFile $URL $APP $LOCALAREA # download
      else
        printf "[+] Checksum ($CHECKSUM) verified, [ OK ]\n"
      fi
  else
    # didn't exist, let's download it:
    downloadFile $URL $APP $LOCALAREA
  fi
}

### Uninstall code blocks for EACH app.
uninstall () { # uninstall Apps here. Remove from $PATH and if uninstaller exists (even "apt remove $app") then run it.
  echo "DEBUG: LOCAL_APPS \"$LOCAL_APPS\""
  app=$1
  app=$(echo $1 | cut -d \| -f 2) # FALSE|PTF|TrustedSec's Pentester's Framework|TRUE|
  progressText="Removing  $app ... "
  printf "\n [! UNINSTALL !] Removing app2: $app ... \n\n"
  progressBar $progressText
  # Spotifail:
  if [[ "$app" =~ potify ]]
    then
      snap remove spotify
      rm ${LOCAL_APPS}/spotify.desktop
  elif [[ "$app" =~ amass ]]
    then
      snap remove amass
  elif [[ "$app" =~ IntelliJ ]]
    then
      snap remove intellij-idea-community
      rm ${LOCAL_APPS}/intellij.desktop
  elif [[ "$app" =~ PTF ]]
    then
      rm -rf /infosec/ptf
      rm /usr/local/bin/ptf
  elif [[ "$app" =~ Bluez ]]
    then
      # we call the uninstaller (new feature)
      $DAS_INST_SCRIPTS_DIR/bluez.sh uninstall
  elif [[ "$app" =~ Demon-Update-Tool ]]
    then
      rm -rf /usr/local/sbin/demon-update* # remove the $PATH object
      rm -rf ${LOCAL_APPS}/demon-updater.desktop # remove the desktop file
      rm -rf /var/demon/updater # remove staging area
  elif [[ "$app" =~ Burp ]]
    then
      /opt/BurpSuiteCommunity/uninstall
      rm ${LOCAL_APPS}/burp.desktop # remove desktop icon from menu
  elif [[ "$app" =~ Tor.Browser ]]
    then
      rm /usr/local/sbin/tor-browser
      rm -rf /opt/tor-browser_en-US
  elif [[ "$app" =~ Cutter ]]
    then
      rm /usr/local/sbin/Cutter
  elif [[ "$app" =~ Atom ]]
    then
      apt remove atom -y
  elif [[ "$app" =~ Eclipse ]]
    then
      rm -rf /opt/eclipse
      rm /usr/local/bin/eclipse # remove binary pointer that we made
  elif [[ "$app" =~ VLC ]]
    then
      apt remove vlc -y
  elif [[ "$app" =~ AFL ]]
    then
      rm -rf /usr/local/bin/afl-analyze
      rm -rf /usr/local/bin/afl-clang
      rm -rf /usr/local/bin/afl-clang++
      rm -rf /usr/local/bin/afl-cmin
      rm -rf /usr/local/bin/afl-fuzz
      rm -rf /usr/local/bin/afl-g++
      rm -rf /usr/local/bin/afl-gcc
      rm -rf /usr/local/bin/afl-gotcpu
      rm -rf /usr/local/bin/afl-plot
      rm -rf /usr/local/bin/afl-showmap
      rm -rf /usr/local/bin/afl-tmin
      rm -rf /usr/local/bin/afl-whatsup
      rm ${LOCAL_APPS}afl.desktop # remove the desktop icon from the menu

    elif [[ "$app" =~ Vulnx ]]
      then
        rm ${LOCAL_APPS}vulnx.desktop # remove menu icon
        rm $(which vulnx) # remove binary

  elif [[ "$app" =~ Brave.Browser ]]
    then
      apt remove brave-browser -y
      rm /usr/bin/brave-browser # remove our pointer binary
  elif [[ "$app" =~ AnyDesk ]]
    then
      apt remove anydesk -y
  elif [[ "$app" =~ Google.Chrome ]]
    then
      apt remove -y google-chrome-stable
      rm /usr/bin/google-chrome
  elif [[ "$app" =~ RTL8812AU ]]
    then # cal installer script to uninstall the module:
      $DAS_INST_SCRIPTS_DIR/awus1900-driver-dkms.sh uninstall
  elif [[ "$app" =~ Sublime.Text ]]
    then
      rm -rf /opt/sublime3
      rm /usr/local/bin/sublime # remove our pointer-binary we made
  elif [[ "$app" =~ Terminus ]]
    then
      apt remove terminus -y
  elif [[ "$app" =~ SimpleNote ]]
    then
      apt remove -y simplenote
  elif [[ "$app" =~ Kdenlive ]]
    then
      rm /usr/local/bin/kdenlive
  elif [[ "$app" =~ Shotcut ]]
    then
      rm /usr/local/bin/shotcut
  elif [[ "$app" =~ Franz ]]
    then
      rm /usr/local/bin/franz
  elif [[ "$app" =~ VisualStudio ]]
    then
      apt -y remove code
      rm /usr/local/bin/VisualStudio
  elif [[ "$app" =~ Maltego ]]
    then
      apt -y remove maltego
  elif [[ "$app" =~ Slack ]]
    then
      apt remove slack-desktop -y
  elif [[ "$app" =~ PyCharm ]]
    then
      rm -rf /opt/pycharm-2019.2
      rm /usr/local/bin/pycharm
      rm ${LOCAL_APPS}/pycharm.desktop
      ls -lah $HOME | grep -i pycharm|awk '{print $9}'|xargs -I {} rm -rf {} # destroy all evidence
  elif [[ "$app" =~ DBeaver ]]
    then
      apt -y remove dbeaver-ce
  elif [[ "$app" =~ Discord ]]
    then
      apt -y remove discord
  elif [[ "$app" =~ CherryTree ]]
    then
      apt -y remove cherrytree
  elif [[ "$app" =~ Grafana ]]
    then
      apt remove grafana -y
      rm /usr/local/sbin/grafana || true # remove the pointer-binary that we made
      rm ${LOCAL_APPS}grafana.desktop # remove the desktop icon from the menu
  elif [[ "$app" =~ Stacer ]]
    then
      apt -y remove stacer
  elif [[ "$app" =~ SERT ]] # Spirion EnCase Reporting Tool
    then
      rm /usr/local/sbin/sert.py # copy the binary into the $PATH
      rm ${LOCAL_APPS}/sert.desktop # remove the desktop file
  elif [[ "$app" =~ APKTool ]]
    then
      apt remove apktool -y
  elif [[ "$app" =~ ApacheDirectoryStudio ]] # LDAP Browser
  then
    rm -rf /opt/ApacheDirectoryStudio
    rm -rf /usr/local/bin/apachedirectorystudio
  elif [[ "$app" == "ZAP" ]]
    then
      /opt/zaproxy/uninstall # TODO check if exists
  elif [[ "$app" =~ SocialBox ]]
    then
      rm -rf /opt/SocialBox
      rm -rf /usr/local/bin/socialbox
  elif [[ "$app" =~ quasar ]]
    then
      rm -rf /opt/quasar
      rm -rf /usr/local/bin/quasar
  elif [[ "$app" =~ Glances ]]
    then
      apt remove glances -y
  elif [[ "$app" =~ IMSI-Catcher ]]
    then
      rm -rf /infosec/rf/IMSI-catcher # remove local git repo
      rm -rf /usr/local/sbin/imsi-catcher # remove binary file
      rm -rf ${LOCAL_APPS}imsi-catcher.desktop # remove the desktop icon
      apt remove -y gr-gsm
  elif [[ "$app" =~ SonarQube ]]
    then
      rm -rf /usr/local/sbin/sonarqube
      rm -rf /opt/sonarqube-7.9.1
  elif [[ "$app" =~ AutoSploit ]]
    then
      rm -rf /infosec/exploit/AutoSploit
      rm -rf /usr/local/sbin/autosploit
      rm -rf /usr/share/applications/autosploit.desktop # remove the desktop/menu icon
  elif [[ "$app" == "WiFi-Pumpkin" ]]
    then
      rm -rf /opt/WiFi-Pumpkin # remove install / build directory
      rm -rf /usr/local/sbin/wifi-pumpkin # remove startup script
      rm -rf ${LOCAL_APPS}wifi-pumpkin.desktop # remove desktop icon
      # I put these two items here, I need to remove them:
      rm -rf /usr/local/sbin/hostapd_cli
      rm -rf /usr/local/sbin/hostapd
  elif [[ "$app" =~ MassDNS ]]
    then
      rm -rf /usr/local/sbin/massdns
  elif [[ "$app" =~ EyeWitness ]]
    then
      rm -rf /opt/EyeWitness
      rm -rf /usr/local/sbin/EyeWitness.sh
  elif [[ "$app" =~ Ghidra ]]
    then
      rm -rf /opt/ghidra # remove local area
      rm -rf ${LOCAL_APPS}/ghidra.desktop # remove menu icon
      rm -rf /usr/local/sbin/ghidra9.sh # remove binary init
      rm -rf /usr/local/sbin/ghidra9
  elif [[ "$app" =~ PWNDrop ]]
    then
      rm -rf /usr/local/pwndrop 2>/dev/null # remove install directory
      rm -rf /usr/local/sbin/pwndrop-start.sh # remove my binary
      rm -rf $SYS_LOCAL_APPS/pwndrop.desktop # remove the desktop menu icon
  elif [[ "$app" =~ WiFiPhisher ]]
    then
      rm -rf /infosec/wifi/wifiphisher # remove the build directory
      rm -rf //usr/local/bin/wifiphisher # remove my script
      rm ${LOCAL_APPS}/wifiphisher.desktop # remove the menu icon
      apt remove dnsmasq  -y # remove dependency
  elif [[ "$app" =~ Tilix ]]
    then
      apt remove tilix tilix-common -y
  elif [[ "$app" =~ GitKraken ]]
    then
      apt -y remove gitkraken # don't forget about meeeeeeeeeeeeeeeee!!!!!!!!!!!!!!!
  elif [[ "$app" =~ "BeEF" ]]
    then
      rm -rf /infosec/exploit/beef # remove the app
      rm -rf /usr/share/applications/beef.desktop # remove the menu entry
      rm -rf /usr/local/sbin/beef # remove the binary file
  elif [[ "$app" =~ "Nessus" ]]
    then
      apt remove nessus -y # using dpkg
      rm -rf /usr/local/sbin/nessus # remove our script
  elif [[ "$app" =~ "PixieWPS" ]]
    then
      rm -rf /infosec/wifi/pixiewps-master # removethe initial build directory
      rm /usr/local/sbin/pixiewps # remove the executable
      rm /usr/share/applications/pixiewps.desktop # remove the desktop/menu icon
  elif [[ "$app" =~ Bluefruit ]]
    then
      rm -rf /infosec/bluetooth/Bluefruit # remove the gitHUB project
      rm -rf /usr/local/sbin/bluefruit_sniffer.sh # remove our binary file
  else
    printf "[+] Recieved $app\n";
  fi
  echo "DEBUG: DAS_NOTIFY_APP \"$DAS_NOTIFY_APP\" DAS_NOTIFY_ICON_RED: \"$DAS_NOTIFY_ICON_RED\""
  notify $DAS_NOTIFY_APP "$app has been uninstalled" $DAS_NOTIFY_ICON_RED
  killBar
}

### Install code blocks for EACH App:
installApp () { # All of the blocks of code to install each app individually:
  app=$1
  if [[ "$app" =~ \|TRUE\|$ ]] # if the last element is "TRUE" uninstall it.
    then # We uninstall it:
      uninstall $app
  else # we install it.
    app=$1
    app=$(echo $app|sed -r 's/TRUE\|([^|]+)\|.*/\1/');
    applower=$app # somehow tr is destroying my variable? wtf?
    applower=$(echo $applower|tr A-Z a-z)
    printf "\n[+] \$app: $app\n"
    progressText="\nInstalling $app ...   "
    # Check if App is already installed (could have been pre-checked in the checklist)
    printf "[+] Checking if "$app" is already installed ... \n";
    apphyphen=$(echo $app|sed -r -e 's/ /-/g')
    applowerhyphen=$(echo $applower|sed 's/ /-/g')
    appdotsh=$(echo ${app}.sh)
    applowerhyphendotsh=$(echo ${applowerhyphen}.sh)
    applowerdotsh=${applower}.sh
    if [[ "$DAS_DEBUG" == "True" ]]
      then
        printf "[i] \$app = \'$app\'\n\
          [i] \$apphyphen = \'$apphyphen\'\n\
          [i] \$appdotsh = \'$appdotsh\'\n\
          [i] \$applower = \'$applower\'\n\
          [i] \$applowerhyphen = \'${applowerhyphen}\'\n\
          [i] \$applowerhyphendotsh = \'${applowerhyphendotsh}\'\n\
          [i] \$applowerdotsh = \'${applowerdotsh}\'\n"
    fi
    if [ $(which "${app,,}"|wc -l) -ne 1 ] \
      && [ $(which $app|wc -l) -ne 1 ] \
      && [ $(which $appdotsh|wc -l) -ne 1 ] \
      && [ $(which $apphyphen|wc -l) -ne 1 ] \
      && [ $(which $applowerdotsh|wc -l) -ne 1 ] \
      && [ $(which $applowerhyphendotsh | wc -l) -ne 1 ] \
      && [ $(which $applowerhyphen | wc -l) -ne 1 ] \
      && [ $(which $applower|wc -l) -ne 1 ] \
      && [ $(dkms status 2>/dev/null| grep -i $app | wc -l) -ne 1 ] \
      && [ $(which "${app}-start.sh"|wc -l) -ne 1 ] \
      && [ $(which "${applower}-start.sh"|wc -l) -ne 1 ] \
      && [ $(which "${applower}-fuzz"|wc -l) -ne 1 ]
      ### We checked all combinations above for the $PATH object.
      then
        ### Spotify
        ### installer, no HTTP
        if [ "$app" == "Spotify" ]
          then # Install Spotify:
            progressBar $progressText
            apt install snapd -y
            snap install spotify
            cp $DAS_DESKTOP_CACHE/spotify.desktop $LOCAL_APPS # copy over the desktop icon
            if [ $(grep /snap/bin ~/.bashrc|wc -l) -eq 0 ]
              then
                echo "export PATH=\$PATH:/snap/bin:/snap/sbin" >> ~/.bashrc # update our PATH
            fi

        ### Apache Studio
        ### Copy, HTTP, Checksum Required
        elif [ "$app" == "ApacheDirectoryStudio" ]
          then
            URL=http://mirrors.gigenet.com/apache/directory/studio/2.0.0.v20180908-M14/ApacheDirectoryStudio-2.0.0.v20180908-M14-linux.gtk.x86_64.tar.gz
            FILE=ApacheDirectoryStudio-2.0.0.v20180908-M14-linux.gtk.x86_64.tar.gz
            CHECKSUM=f9915592978c0b7e1a2f64c80b756a1d
            BINFILE=/usr/local/bin/apachedirectorystudio
            LOCALAREA=$DAS_APPCACHE/$FILE
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar " Installing Apache Directory Studio ... "
              cd $DAS_APPCACHE
              tar vxzf $FILE
              mv ApacheDirectoryStudio /opt/ # just move it.
              echo "#!/usr/bin/env bash" > $BINFILE
              echo "cd /opt/ApacheDirectoryStudio && ./ApacheDirectoryStudio" >> $BINFILE
              chmod +x $BINFILE
            killBar

        ### SocialBox
        ### Copy, GIT
        elif [[ "$app" == "SocialBox" ]]
        then
          progressBar " Installing SocialBox from GitHUB ...    "
            URL=https://github.com/TunisianEagles/SocialBox.git
            LOCALAREA=/opt/SocialBox
            BINFILE=/usr/local/bin/socialbox
            cd /opt && git clone $URL
            cd $LOCALAREA
            chmod +x SocialBox.sh
            chmod +x install-sb.sh
            ./install-sb.sh
            # ./SocialBox.sh
            echo "#!/usr/bin/env bash" > $BINFILE
            echo "cd $LOCALAREA && ./SocialBox.sh" >> $BINFILE
            chmod +x $BINFILE
          killBar

        ### Quasar
        ### Copy, GIT
        elif [[ "$app" == "quasar" ]]
            then
              progressBar " Installing Quasar from GitHUB ...    "
                URL=https://github.com/Cyb0r9/quasar
                LOCALAREA=/opt/quasar
                BINFILE=/usr/local/bin/quasar
                cd /opt/ && git clone $URL
                cd $LOCALAREA
                chmod +x install.sh
                chmod +x quasar.sh
                sed -i -e 's/apt-get/apt-get -y/g' install.sh # whoopsey daisey:
                ./install.sh
                echo "#!/usr/bin/env bash" > $BINFILE
                echo "cd /opt/quasar && ./quasar.sh" >> $BINFILE
                chmod +x $BINFILE
              killBar

        ### AutoSploit
        ### Copy, GIT
        elif [ "$app" == "AutoSploit" ]
          then
            URL=https://github.com/NullArray/AutoSploit
            FILE=AutoSploit
            INSTALLAREA=/infosec/exploit
            BINFILE=/usr/local/sbin/autosploit
            progressBar "Installing AutoSploit ... "
            cd $INSTALLAREA && git clone $URL
            cd $INSTALLAREA/$FILE
            chmod +x install.sh
            ./install.sh
            echo "#!/usr/bin/env bash" > $BINFILE
            echo "cd /infosec/exploit/AutoSploit && ./runsploit.sh" >> $BINFILE
            chmod +x $BINFILE
            cp $DAS_DESKTOP_CACHE/autosploit.desktop $LOCAL_APPS # set the menu/desktop icon

        ### BeEF
        ### GIT, install script
      elif [ "$app" == "BeEF" ]
          then
            URL=https://github.com/beefproject/beef
            LOCALAREA=/infosec/exploit/
            BINFILE=/usr/local/sbin/beef
            progressBar " Installing BeEF ... "
              cd $LOCALAREA && git clone $URL
              cd beef
              sed -ri 's/\s+get_permission//' install # whoopsey daisey!
              sed -ri 's/apt-get install/apt-get install -y/' install # whoopsey daisey!
              ./install
              cp $DAS_DESKTOP_CACHE/beef.desktop $LOCAL_APPS # copy the desktop icon that I made
              echo "#!/usr/bin/env bash" > $BINFILE
              echo "cd /infosec/exploit/beef && ./beef" >> $BINFILE
              chmod +x $BINFILE # make it executable
            killBar

        ### OWASP Amass
        ### Installer, No Apt
        elif [ "$app" == "amass" ]
          then
            progressBar "Installing OWASP Amass ...   "
              snap install amass
            killBar

        ### OWASP ZAP
        ### Installer, HTTP, CHecksum Required
        elif [ "$app" == "ZAP" ]
          then
            URL=https://github.com/zaproxy/zaproxy/releases/download/v2.8.0/ZAP_2_8_0_unix.sh
            FILE=ZAP_2_8_0_unix.sh
            LOCALAREA=$DAS_APPCACHE/$FILE
            CHECKSUM=8a6f8326d3d17ad9b97b66eef790a50c
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            chmod +x $LOCALAREA
            bash -c $LOCALAREA

        ### APKTool
        ### Install, apt, no HTTP
        elif [ "$app" == "APKTool" ]
          then
            apt install apktool -y

        ### Pentester's Framework from TrustedSec
        ### Installer, no HTTP, GIT
        elif [ "$app" == "PTF" ]
          then
            progressBar $progressText
            apt install python-pip python-expect -y
            if [ -d /infosec/ptf ]
              then
                cd /infosec/ptf && git pull
            else
              cd /infosec && git clone https://github.com/trustedsec/ptf
              if [ $(grep ptf ~/.bashrc|wc -l) -eq 0 ]
                then
                  echo "PATH=\$PATH:/infosec/ptf" >> ~/.bashrc # update our PATH
              fi
            fi

        ### Burp Suite
        ### Installer, HTTP, Checksum required
        elif [ "$app" == "BurpSuiteCommunity" ]
          then
            LOCALAREA="$DAS_APPCACHE/burpsuite.sh" # /var/demon/store/app-cache/burpsuite.sh
            URL='https://demonlinux.com/download/packages/burpsuite.sh'
            CHECKSUM=8b56bec4af6ae52a37756ad933dc5345
            checksumCheck $LOCALAREA $CHECKSUM $URL $app # will download file too.
            progressBar $progressText
            chmod +x $DAS_APPCACHE/burpsuite.sh
            killBar # the installer will take over
            $DAS_APPCACHE/burpsuite.sh
            cp $DAS_DESKTOP_CACHE/burp.desktop $LOCAL_APPS # copy the desktop icon that I made

        ### TorBrowser
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Tor-Browser" ]
          then
            FILE=tor-browser-linux64-8.5.4_en-US.tar.xz
            LOCALAREA="${DAS_APPCACHE}/${FILE}"
            URL='https://demonlinux.com/download/packages/tor-browser-linux64-9.0.2_en-US.tar.xz'
            CHECKSUM=255fa2ebbf72710085dfbfc68233be22
            rm -rf $LOCALAREA # just destroy it, the xz shit ruins it's integrity check.
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            cd $DAS_APPCACHE
            tar vxfJ $FILE
            sed -ie 's/`" -eq 0/`" -ne 0/' tor-browser_en-US/Browser/start-tor-browser # whoopsey daisey!
            # We do the below in lieu of altering the .profile or .bashrc. This process will be used throughout this app:
            echo "cd /opt/tor-browser_en-US/Browser && ./start-tor-browser" > /usr/local/sbin/tor-browser # Create binary pointer for app
            chmod +x /usr/local/sbin/tor-browser # make binary executable
            cp -R tor-browser_en-US /opt/ # copy it from the $DAS_APPCACHE into the $PATH

        ### Cutter
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Cutter" ]
          then # Install Cutter:
            URL='https://github.com/radareorg/cutter/releases/download/v1.8.3/Cutter-v1.8.3-x64.Linux.AppImage'
            CHECKSUM=bb98ea36046e3bbc86af73c89580152b
            LOCALAREA=/usr/local/sbin/Cutter
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText # No LOCALAREA Needed (AppImage <3)
            chmod +x $LOCALAREA

        ### Atom "IDE"
        ### Installer, HTTP, Checksum required
        elif [[ "$app" =~ Atom ]]
          then
            URL='https://github.com/atom/atom/releases/download/v1.40.0/atom-amd64.deb'
            LOCALAREA="$DAS_APPCACHE/atom-amd64.deb"
            CHECKSUM=fe3bedd6bec04e6a2ebacb09404c5c9c
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y # just in case-icles

        ### Eclipse for Java Devs
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Eclipse" ]
          then
            URL='http://demonlinux.com/download/packages/eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz'
            FILE=eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz
            LOCALAREA="$DAS_APPCACHE/$FILE"
            CHECKSUM=0
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            cd $DAS_APPCACHE
            tar vxzf $FILE # crack it open
            mv $DAS_APPCACHE/eclipse /opt/ # toss it into a shared space
            binFile=/usr/local/bin/eclipse
            echo "#!/bin/bash " > $binFile
            echo "cd /opt/eclipse && ./eclipse " >> $binFile
            chmod +x $binFile

        ### VLC Media Player
        ### Installer, apt, no HTTP
        elif [ "$app" == "VLC" ]
          then
            progressBar $progressText
            apt install vlc -y
            sed -i 's/geteuid/getppid/' /usr/bin/vlc

        ### Brave little web browser
        ### Installer, apt, no HTTP
        elif [[ "$app" =~ Brave.Browser ]]
          then
            progressBar $progressText
            sudo apt install apt-transport-https curl -y
            curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
            echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ trusty main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-trusty.list
            apt update
            apt install brave-browser -y
            # aaaand finally, a little clean up:
            mv /usr/bin/brave-browser /usr/bin/brave-browser-script
            echo "brave-browser-script --no-sandbox" > /usr/bin/brave-browser
            chmod +x /usr/bin/brave-browser
            mv /usr/bin/brave-browser-stable /usr/bin/brave-browser-script
            echo "brave-browser-script --no-sandbox" > /usr/bin/brave-browser-stable
            chmod +x /usr/bin/brave-browser-stable

        ### Googlefornia's shitty browser
        ### Installer, apt, HTTP, Checksum required
        elif [ "$app" == "Google-Chrome" ]
          then
            URL='http://demonlinux.com/download/packages/google-chrome-stable_current_amd64.deb'
            FILE=google-chrome-stable_current_amd64.deb
            LOCALAREA="$DAS_APPCACHE/$FILE"
            CHECKSUM=fa1dd612eed2003f2293c321c80291a5
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            cd $DAS_APPCACHE
            progressBar $progressText
            dpkg -i $FILE
            apt -f install -y
            # great. Now we have a lot of cleaning up to do for Googlefornia.
            mv /usr/bin/google-chrome /usr/bin/google-chrome-script
            echo "google-chrome-script --no-sandbox" > /usr/bin/google-chrome
            chmod +x /usr/bin/google-chrome
            mv /usr/bin/google-chrome-stable /usr/bin/google-chrome-script
            echo "google-chrome --no-sandbox" > /usr/bin/google-chrome-stable
            chmod +x /usr/bin/google-chrome-stable

        ### Sublime text editor
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Sublime" ]
          then
            URL="https://download.sublimetext.com/sublime_text_3_build_3207_x64.tar.bz2"
            FILE="sublime_text_3_build_3207_x64.tar.bz2"
            CHECKSUM=187d5f46fdf8b628fbc4686984591529
            LOCALAREA=$DAS_APPCACHE/$FILE
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            cd $DAS_APPCACHE
            progressBar $progressText
            binFile=/usr/local/bin/sublime
            tar vjxf $FILE
            mv sublime_text_3 /opt/sublime3
            echo "#!/bin/bash" > $binFile
            echo "cd /opt/sublime3 && ./sublime_text " >> $binFile
            chmod +x $binFile

        ### SimpleNote
        ### Installer no apt, HTTP, Checksum required
        elif [ "$app" == "SimpleNote" ]
          then
            URL='https://github.com/Automattic/simplenote-electron/releases/download/v1.7.0/Simplenote-linux-1.7.0-amd64.deb'
            FILE=Simplenote-linux-1.7.0-amd64.deb
            LOCALAREA=$DAS_APPCACHE/$FILE
            CHECKSUM=0
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            cd $DAS_APPCACHE
            progressBar $progressText
            dpkg -i $FILE
            apt -f install -y

        ### KdenLive
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Kdenlive" ]
          then
            URL='https://files.kde.org/kdenlive/release/Kdenlive-16.12.2-x86_64.AppImage'
            LOCALAREA=/usr/local/bin/kdenlive
            CHECKSUM=0
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            cd $DAS_APPCACHE
            progressBar $progressText
            apt install -y ffmpeg libavc1394-tools dvdauthor genisoimage
            chmod +x $LOCALAREA

        ### ShotCut
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Shotcut" ]
          then
            LOCALAREA=/usr/local/bin/shotcut
            FILE=shotcut
            URL=https://github.com/mltframework/shotcut/releases/download/v19.08.16/Shotcut-190816.glibc2.14-x86_64.AppImage
            CHECKSUM=9ffb51476e2ca5bbf9aa712b6cdc44bd
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            chmod +x $LOCALAREA

        ### Franz Messaging
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "Franz" ]
          then
            LOCALAREA=/usr/local/bin/franz
            CHECKSUM=6d8eaac5f875652496e9a056a443b272
            URL=https://github.com/meetfranz/franz/releases/download/v5.2.0/franz-5.2.0-x86_64.AppImage
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            chmod +x $LOCALAREA

        ### Visual Studio
        ### Installer, apt, repo, no HTTP
        elif [ "$app" == "VisualStudio" ]
          then
            progressBar $progressText
            apt install software-properties-common apt-transport-https curl software-properties-common -y
            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
            add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
            apt update
            apt install code -y
            echo "code --user-data-dir" >/usr/local/bin/VisualStudio
            chmod +x /usr/local/bin/VisualStudio

        ### Maltego CE
        ### Installer, no apt, HTTP, Checksum required
        elif [ "$app" == "Maltego" ]
          then
            FILE=Maltego.v4.2.6.12502.deb
            LOCALAREA="$DAS_APPCACHE/$FILE"
            CHECKSUM=7400f0e8fba47b7fdf8bc2b4a9d23714
            URL=http://www.demonlinux.com/download/packages/Maltego.v4.2.6.12502.deb
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### Slack
        ### Installer, no apt, HTTP, Checksum required
        elif [ "$app" == "Slack" ]
          then
            FILE=slack-desktop-4.0.1-amd64.deb
            LOCALAREA=$DAS_APPCACHE/$FILE
            CHECKSUM=d3738ea4d5761a398a01656b875587cc
            URL=https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.1-amd64.deb
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### PyCharm (FREE)
        ### Copy, HTTP, Checksum required
        elif [ "$app" == "PyCharm" ]
          then
            FILE=/pycharm-professional-2019.2.tar.gz
            LOCALAREA=$DAS_APPCACHE/$FILE
            CHECKSUM=0
            INSTALLAREA=/opt
            URL=https://download.jetbrains.com/python/pycharm-professional-2019.2.tar.gz
            binFile=/usr/local/bin/pycharm
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            cd $DAS_APPCACHE
            tar vxzf $FILE
            mv pycharm-2019.2 $INSTALLAREA
            echo "#!/bin/bash" > $binFile
            echo "cd /opt/pycharm-2019.2/bin && ./pycharm.sh" >> $binFile
            chmod +x $binFile
            cp $DAS_DESKTOP_CACHE/pycharm.desktop $LOCAL_APPS # copy in our shiny new menu/deskop icon

        ### DBeaver
        ### Installer, No apt, HTTP, Checksum required
        elif [ "$app" == "DBeaver" ]
          then
            FILE=dbeaver-ce_latest_amd64.deb
            LOCALAREA=$DAS_APPCACHE/$FILE
            CHECKSUM=697462846ad718bed985fcd1e3308a86
            URL=https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### Discord
        ### Installer, No Apt, HTTP, Checksum required
        elif [ "$app" == "Discord" ]
          then
            FILE=discord-0.0.9.deb
            CHECKSUM=2f6f5eb899f2815fbd26dddea0d2d316
            URL='https://discordapp.com/api/download?platform=linux&format=deb'
            LOCALAREA=$DAS_APPCACHE/$FILE
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### CherryTree
        ### Installer, No apt, HTTP, Checksum Required
        elif [ "$app" == "CherryTree" ]
          then
            # 1. get this: python-gtksourceview2
            FILE=python-gtksourceview2_2.10.1-3_amd64.deb
            URL=https://demonlinux.com/download/packages/cherrytree_0.39.2-0_all.deb
            CHECKSUM=6c2703e74b8a0d2bd9ef9f9360682dd3
            LOCALAREA=$DAS_APPCACHE/$FILE
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            dpkg -i $LOCALAREA
            apt -f install -y
            # 2. get cherry tree:
            FILE=cherrytree_0.38.9-0_all.deb
            LOCALAREA=$DAS_APPCACHE/$FILE
            URL=http://www.giuspen.com/software/cherrytree_0.38.9-0_all.deb
            CHECKSUM=c13200d2e4b13d00978520a24e08d685
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### Grafana
        ### Installer, No apt, HTTP, Checksum Required
        elif [ "$app" == "Grafana" ]
            then
              progressBar " Installing $app ... "
                $DAS_INST_SCRIPTS_DIR/graphana.sh
              killBar

        ### Bluez Blutooth Stack
        ### Checksum required, build, apt involved for deps
        elif [[ "$app" == "Bluez" ]]
          then
            progressBar "Installing $app ... "
              $DAS_INST_SCRIPTS_DIR/bluez.sh
            killBar

        ### Tilix Terminal Emulator
        ### APT
        elif [ "$app" == "Tilix" ]
          then
            progressBar " Installing $app ... "
              $DAS_INST_SCRIPTS_DIR/tilix.sh
            killBar

        ### AnyDesk
        ### Installer, No apt, HTTP, Checksum Required
        elif [ "$app" == "AnyDesk" ]
          then
            CHECKSUM=32f6c378194f0de88a759aa651a3b748
            FILE=anydesk_5.1.1-1_amd64.deb
            URL=http://www.demonlinux.com/download/packages/anydesk_5.1.1-1_amd64.deb
            INSTALLAREA=
            BINFILE=
            LOCALAREA=$DAS_APPCACHE/$FILE
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
            dpkg -i $LOCALAREA
            apt -f install -y

        ### Stacer
        ### Installer, No Apt, HTTP, Checksum Required
        elif [ "$app" == "Stacer" ]
          then
            FILE=stacer_1.1.0_amd64.deb
            LOCALAREA=$DAS_APPCACHE/$FILE
            URL='https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb'
            CHECKSUM=66d9e37ff39ad7b97557eb903386d848
            INSTALLAREA=
            BINFILE=
            checksumCheck $LOCALAREA $CHECKSUM $URL $app
            progressBar $progressText
              dpkg -i $LOCALAREA
              apt -f install -y
            killBar

        ### Glances
        ### Installer, apt
        elif [[ "$app" =~ Glances ]]
          then
            progressBar "Installing $app ... "
              apt install glances -y
            killBar

        ### IntelliJ
        ### Install, snap
        elif [[ "$app" =~ IntelliJ ]]
          then
            progressBar $progressText
              apt install snapd -y
              snap install intellij-idea-community --classic
              cp $DAS_DESKTOP_CACHE/intellij.desktop ${LOCAL_APPS} # copy in our Desktop/Menu icon
            killBar

        ### Sonarqube
        ### Copy, HTTP, Checksum Required
        elif [[ "$app" =~ SonarQube ]]
          then
            progressBar " Installing SonarQube ... "
              $DAS_INST_SCRIPTS_DIR/sonarqube.sh
            killBar

        ### MassDNS
        ### Git, Compile, Copy
        elif [[ "$app" =~ MassDNS ]]
          then
            URL=https://github.com/blechschmidt/massdns
            BINFILE=/usr/local/sbin/massdns
            progressBar " Installing MassDSN from GitHUB ... "
              cd /tmp && git clone $URL
              cd /tmp/massdns && make
              cp /tmp/massdns/bin/massdns $BINFILE
            killBar

        ### NESSUS
        ### HTTP, Checksum Required, Installer
        elif [[ "$app" =~ "Nessus" ]]
          then
            progressBar " Installing Nessus ...   "
              $DAS_INST_SCRIPTS_DIR/nessus.sh
            killBar

        ### Terminus
        ### Git Apt Installer, Checksum required
        elif [[ "$app" =~ "Terminus" ]]
            then
              progressBar " Installing Terminus ... "
                $DAS_INST_SCRIPTS_DIR/terminus.sh
              killBar

        ### IMSI-Catcher
        ### GIT with depends
        elif [[ "$app" =~ "IMSI-Catcher" ]]
            then
              progressBar " Installing IMSI-Catcher ...   "
                $DAS_INST_SCRIPTS_DIR/imsi_catcher.sh
              killBar

        ### PixieWPS
        ### GIT, Compile, Copy
        elif [[ "$app" =~ PixieWPS ]]
          then
            progressBar " Installing PixieWPS ... " # let em know you're compiling.
              $DAS_INST_SCRIPTS_DIR/pixie_wps.sh
            killBar

        ### BlueFruit Sniffing Software (Adafruit)
        ### Git, pip, no checksum required
        elif [[ "$app" =~ Bluefruit ]]
          then
            progressBar "Installing Adafruit\'s Bluetooth Sniffer ... "
              $DAS_INST_SCRIPTS_DIR/bluefruit.sh
            killBar

        ### WiFi-Pumpkin
        ### Git, no checksum, compiled with depends
        elif [[ "$app" == "WiFi-Pumpkin" ]]
          then
            progressBar "Installing WiFi-Pumpkin, this may take a while."
              $DAS_INST_SCRIPTS_DIR/wifi_pumpkin.sh
            killBar

        ### EyeWitness
        ### Git, no checksum or installer
        elif [[ "$app" =~ EyeWitness ]]
          then
            progressBar " Installing EyeWitness ... "
              $DAS_INST_SCRIPTS_DIR/eyewitness.sh
            killBar

        ### PwnDrop
        ### Git Self Installer
      elif  [[ "$app" =~ PWNDrop ]]
          then
            progressBar "Installing PWNDrop ... "
              $DAS_INST_SCRIPTS_DIR/pwndrop.sh
            killBar

        ### SERT.py
        ### Git, no checksum
        elif [[ "$app" =~ SERT ]]
          then
            progressBar "Installing SERT ... "
              $DAS_INST_SCRIPTS_DIR/sert.py.sh
            killBar

        ### America Fuzzy Lop @bunnymeats
        ### Git, Compile, no checksum required
      elif [[ "$app" =~ AFL ]]
          then
            progressBar "Installing American Fuzzy Lop ..."
              $DAS_INST_SCRIPTS_DIR/afl.sh
            killBar

        ### WiFiPhisher
        ### Git, Compile, no checksum required
        elif [[ "$app" =~ WiFiPhisher ]]
          then
            progressBar "Installing WiFiPhisher ..."
              $DAS_INST_SCRIPTS_DIR/wifiphisher.sh
            killBar

        ### Demon Updater Tool
        ### Git, no checksum required
      elif [[ "$app" =~ Vulnx ]]
          then
            progressBar " Installing $app ... "
              $DAS_INST_SCRIPTS_DIR/vulnx.sh
            killBar

        ### Demon Updater Tool
        ### Git, no checksum required
        elif [[ "$app" =~ Demon-Update-Tool ]]
          then
            progressBar " Installing $app ... "
              $DAS_INST_SCRIPTS_DIR/demon_updater_tool.sh
            killBar
      ### Ghidra
      ### unzip, appimage, checksum required
      elif [[ "$app" =~ Ghidra9 ]]
          then
            progressBar " Installing $app ... "
              $DAS_INST_SCRIPTS_DIR/ghidra.sh
            killBar

        ### RTL8812AU
        ### Aircrack-NG GitHUB.com
        elif [[ "$app" =~ RTL8812AU ]]
          then
            progressBar " Installing RTL8812AU Driver with DKMS ... "
              $DAS_INST_SCRIPTS_DIR/awus1900-driver-dkms.sh install
            killBar

        ### GitKraken
        ### Installer, HTTP, CHecksum required
        elif [[ "$app" =~ GitKraken ]]
          then
            URL=http://demonlinux.com/download/packages/gitkraken-amd64.deb
            FILE=gitkraken-amd64.deb
            CHECKSUM=6ad71a6e177e4eda2c3252bee4fceaab
            LOCALAREA=$DAS_APPCACHE/$FILE
            ./das_functions/checksum_check $LOCALAREA $CHECKSUM $URL $app
            progressBar " Installing GitKraken ... "
              $DAS_INST_SCRIPTS_DIR/gitkraken.sh $DAS_APPCACHE/$FILE
            killBar

        ### IDKWTF I GOT LOL
        ### All done.
        else
            printf "[!] Unknown app was requested! $app\n\n"
        fi
        notify $DAS_NOTIFY_APP "$app has been installed" $DAS_NOTIFY_ICON_GRN
        killBar
    fi
  fi
}

main () {
  IFS=$'\n'
  readarray selected < <(yad --width=$DAS_WIDTH --height=$DAS_HEIGHT --title=$DAS_APPNAME --button=Help:"bash -c help" --button="Clean Cache:bash -c cleanCache" --button="Exit:1" --button="Check Out:0" --list --checklist --column="Install" --column="App Name" --column=Category --column=Description --column=Uninstall:CHK --image=$DAS_WINDOWLONGIMAGE --window-icon=$DAS_WINDOWICON \
    --center \
    $(if [[ $(which autosploit|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "AutoSploit" "$DAS_CAT_PEN" "Automated Mass Exploit Tool" false \
    $(if [[ $(which pwndrop-start.sh|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PWNDrop" "$DAS_CAT_PEN" "self-deployable file hosting service for sending out red teaming payloads" false \
    $(if [[ $(which wifi-pumpkin|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "WiFi-Pumpkin" "$DAS_CAT_PEN" "Rogue AP Framework" false \
    $(if [[ $(which bluefruit_sniffer.sh|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Bluefruit" "$DAS_CAT_PEN" "Adafruit's BLE Sniffer" false \
    $(if [[ $(which wifiphisher|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "WiFiPhisher" "$DAS_CAT_PEN" "Rogue AP WiFi Phishing Tool" false \
    $(if [[ $(which EyeWitness.sh|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "EyeWitness" "$DAS_CAT_PEN" "Automated Web Vulnerability Tool" false \
    $(if [[ $(which imsi-catcher|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "IMSI-Catcher" "$DAS_CAT_PEN" "IMSI Catcher Tool" false \
    $(if [[ $(which pixiewps|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PixieWPS" "$DAS_CAT_PEN" "Cracking WPS PIN" false \
    $(if [[ $(which nessus|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Nessus" "$DAS_CAT_PEN" "Tenable's vulnerability scanner" false \
    $(if [[ $(which BurpSuiteCommunity|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "BurpSuiteCommunity" "$DAS_CAT_PEN" "Web vulnerability scanner and proxy" false \
   $(if [[ $(which zap.sh|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "ZAP" "$DAS_CAT_PEN" "OWASP ZAP, Zed Attack Proxy" false \
   $(if [[ $(which amass|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Amass" "$DAS_CAT_PEN" "OWASP Amass, attack surface mapping" false \
   $(if [[ $(which maltego|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Maltego" "$DAS_CAT_PEN" "Paterva's information gathering tool" false \
   $(if [[ $(which ptf|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PTF" "$DAS_CAT_PEN" "TrustedSec's Pentester's Framework" false \
   $(if [[ $(which beef|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "BeEF" "$DAS_CAT_PEN" "The Browser Exploitation Framework" false \
   $(if [[ $(which socialbox|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "SocialBox" "$DAS_CAT_PEN" "Social Media Bruteforce Attack Framework" false \
   $(if [[ $(which quasar|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "quasar" "$DAS_CAT_PEN" "Information Gathering Framework For Penetration Testers" false \
   $(if [[ $(which sert.py|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "SERT" "$DAS_CAT_FOR" "Spirion EnCase Reporting Tool" false \
   $(if [[ $(which vulnx|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Vulnx" "$DAS_CAT_FOR" "Vulnx2.0 CMS Vulnerability Scanner" false \
   \
   $(if [[ $(which massdns|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "MassDNS" "$DAS_CAT_NET" "Simple high-performance DNS stub resolver" false \
   \
   $(if [[ $(which stacer|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Stacer" "$DAS_CAT_SYS" "System optimizer app" false \
   $(if [[ $(which glances|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Glances" "$DAS_CAT_SYS" "Curses-based monitoring tool" false \
   $(if [[ $(which grafana|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Grafana" "$DAS_CAT_SYS" "Open platform for beautiful analytics and monitoring" false \
   $(if [[ $(which anydesk|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "AnyDesk" "$DAS_CAT_SYS" "Remote Desktop App" false \
   $(if [[ $(which terminus|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Terminus" "$DAS_CAT_SYS" "A Terminal for a Modern Age" false \
   $(if [[ $(which tilix|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Tilix" "$DAS_CAT_SYS" "A Tiling Terminal Emulator" false \
   \
   $(if [[ $(dkms status 2>/dev/null|grep -i rtl8812au|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "RTL8812AU" "$DAS_CAT_DVR" "Aircrack-NG DKMS Driver for AWUS1900" false \
   $(if [[ $(which hciconfig|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Bluez" "$DAS_CAT_DVR" "Default Bluetooth Stack Tools" false \
   \
   $(if [[ $(which Cutter|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Cutter" "$DAS_CAT_ENG" "Reverse engineering tool" false \
   $(if [[ $(which afl-analyze|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "AFL" "$DAS_CAT_ENG" "American Fuzzy Lop" false \
   $(if [[ $(which apktool|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "APKTool" "$DAS_CAT_ENG" "Reverse engineering Android APK tool" false \
   $(if [[ $(which ghidra9.sh|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Ghidra9" "$DAS_CAT_ENG" "NSA's Reverse engineering Tool" false \
   \
   $(if [[ $(which cherrytree|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "CherryTree" "$DAS_CAT_NOT" "A hierarchical note taking application" false \
   $(if [[ $(which simplenote|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "SimpleNote" "$DAS_CAT_NOT" "The simplest way to keep notes" false \
   \
   $(if [[ $(which pycharm|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PyCharm" "$DAS_CAT_DEV" "The Python IDE for Professional Developers" false \
   $(if [[ $(which apachedirectorystudio|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "ApacheDirectoryStudio" "$DAS_CAT_DEV" "Complete LDAP directory tooling platform" false \
   $(if [[ $(which sonarqube|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "SonarQube" "$DAS_CAT_DEV" "Code vulnerability scanning tool" false \
   $(if [[ $(which VisualStudio|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "VisualStudio" "$DAS_CAT_DEV" "Microsoft's Visual Studio code editor" false \
   $(if [[ $(which atom|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Atom" "$DAS_CAT_DEV" "Atom IDE" false \
   $(if [[ $(which gitkraken|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "GitKraken" "$DAS_CAT_DEV" "Git Client" false \
   $(if [[ $(which sublime|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Sublime" "$DAS_CAT_DEV" "Sublime text editor" false \
   $(if [[ $(which eclipse|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Eclipse" "$DAS_CAT_DEV" "Eclipse IDE for Java" false \
   $(if [[ $(which intellij-idea-community|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "IntelliJ IDEA Community" "$DAS_CAT_DEV" "Java IDE for Developers"  false \
   \
   $(if [[ $(which dbeaver|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "DBeaver" "$DAS_CAT_DEV" "Database tool for developers" false \
   \
   $(if [[ $(which brave-browser|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Brave-Browser" "$DAS_CAT_WEB" "Much more than a web browser" false \
   $(if [[ $(which google-chrome|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Google-Chrome" "$DAS_CAT_WEB" "Google's web browser" false \
   $(if [[ $(which tor-browser|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Tor-Browser" "$DAS_CAT_WEB" "The Tor Project Browser"  false \
   \
   $(if [[ $(which slack|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Slack" "$DAS_CAT_COM" "Slack collaboration tool" false \
   $(if [[ $(which franz|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Franz" "$DAS_CAT_COM" "Messaging client app" false \
   $(if [[ $(which discord|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Discord" "$DAS_CAT_COM" "Voice and text chat for gamers" false \
   \
   $(if [[ $(which demon-updater.sh |wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Demon-Updater.sh" "$DAS_CAT_DEM" "Demon Linux Update App" false \
   \
   $(if [[ $(which kdenlive|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Kdenlive" "$DAS_CAT_MM" "Video editor program" false \
   $(if [[ $(which shotcut|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Shotcut" "$DAS_CAT_MM" "Video editor program" false \
   $(if [[ $(which spotify|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Spotify" "$DAS_CAT_MM" "Spotify desktop app" false \
   $(if [[ $(which vlc|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "VLC" "Multimedia" "$DAS_CAT_MM player and framework" false)

   for app in "${selected[@]}"
    do
      installApp $app
   done
   # All done!
}
main
complete
