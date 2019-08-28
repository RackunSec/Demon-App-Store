#!/usr/bin/env bash
## Demon Linux App Store - ^vv^
## 2019 WeakNet Labs
## Douglas Berdeaux

source ~/.bashrc # Testing this as there seems to be an issue with the $PATH for Spotifail.

IFS=$'\n' # required for for() loop
SPANFONT="<span font='Ubuntu Condensed 11'>"
WINDOWICON="/usr/share/demon/images/icons/demon-64-white.png"
WINDOWIMAGE="/usr/share/demon/images/icons/demon-store-icon-64-padded.png"
APPNAME="Demon App Store"
APPTEXT="\n\nWelcome to the Demon App Store - where everything's free.\n"

# HELP Dialog needs exported to be called from button press:
help () {
  WINDOWICON="/usr/share/demon/images/icons/demon-64-white.png"
  WINDOWIMAGE="/usr/share/demon/images/icons/demon-store-icon-64-padded.png"
  yad --on-top --center --width=550 --height=100 --title="Demon App Store HELP" --fixed --button=Exit:0 --image=$WINDOWIMAGE --window-icon=$WINDOWICON \
  --text="\n<b>To install an app:</b> simply click the checkbox under the 'Install' column.\n\n<b>To uninstall an app:</b> simply click the checkbox under the 'Uninstall' column.\n"
}
export -f help # kinda cool. We basically temporarily make a command in our $PATH out of a function.

# start the "installing app: XYZ" progress bar dialog:
progressBar () {
 tail -f /etc/issue |yad --progress --pulsate --auto-close --text="\n$SPANFONT $1 </span>\n" --width=350 --center\
 --title=$APPNAME --window-icon=$WINDOWICON --percentage=13 --progress-text="Please wait ..." --image=$WINDOWIMAGE --undecorated --no-buttons &
}

# This function stops the loading bar message box by killing tail:
killBar () {
 killall -KILL tail 2>/dev/null
}

downloadFile () { # pass to me "URI,Title,OutputFile" :)
  wget $1 --no-check-certificate -U mozilla -O $3  2>&1 | sed -u 's/^[a-zA-Z\-].*//; s/.* \{1,2\}\([0-9]\{1,3\}\)%.*/\1\n#Downloading ...\1%/; s/^20[0-9][0-9].*/#Done./'\
  | yad --progress --title="Download in Progress" --window-icon=$WINDOWICON --image=$WINDOWIMAGE --width=350 --center --text="\nDownloading $2 ... " --auto-close --no-buttons --undecorated
}

complete () { # "--fixed" actually fixes a height issue BUG here:
  # I'm aaaalll duuuhhhhh-uuuuhhhnnnnnnne!
  yad --text="\nThank you for visting the Demon Linux App Store.  " --height=10 --fixed --title=$APPNAME --image=$WINDOWIMAGE --window-icon=$WINDOWICON --button=Exit:1
}

updateMe () { # update one's self. TODO - move to a separate binary.
 progressBar "Updating the App Store ... "
 mkdir -p /appdev/ 2>/dev/null
 rm -rf /appdev/Demon-App-Store
 cd /appdev
 git clone https://github.com/weaknetlabs/Demon-App-Store/
 cd /appdev/Demon-App-Store && ./install-app-store.sh
 killBar
}

uninstall () { # uninstall Apps here. Remove from $PATH and if uninstaller exists (even "apt remove $app") then run it.
  app=$1
  appName=$(echo $app | awk -F'|' '{print $2}')
  #printf "[+] \$appName: $appName\n" # DEBUG
  #printf "[+] \$app: \"$app\"\n" # DEBUG
  progressText="Removing  $appName ... "

  progressBar $progressText
  # Spotifail:
  if [[ "$app" =~ potify ]]
    then
      snap remove spotify
  elif [[ "$app" =~ IntelliJ ]]
    then
      snap remove intellij-idea-community
  elif [[ "$app" =~ PTF ]]
    then
      rm -rf /infosec/ptf
      rm /usr/local/bin/ptf
  elif [[ "$app" =~ Burp ]]
    then
      /opt/BurpSuiteCommunity/uninstall
  elif [[ "$app" =~ Tor.Browser ]]
    then
      rm /usr/local/sbin/tor-browser
      rm -rf /opt/tor-browser_en-US
  elif [[ "$app" =~ Cutter ]]
    then
      rm /usr/local/sbin/Cutter
  elif [[ "$app" =~ Atom ]]
    then
      apt remove Atom -y
  elif [[ "$app" =~ Eclipse ]]
    then
      rm -rf /opt/eclipse
      rm /usr/local/bin/eclipse # remove binary pointer that we made
  elif [[ "$app" =~ VLC ]]
    then
      apt remove vlc -y
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
  elif [[ "$app" =~ Sublime.Text ]]
    then
      rm -rf /opt/sublime3
      rm /usr/local/bin/sublime # remove our pointer-binary we made
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
  elif [[ "$app" =~ DBeaver ]]
    then
      apt -y remove dbeaver-ce
  elif [[ "$app" =~ Discord ]]
    then
      apt -y remove discord
  elif [[ "$app" =~ CherryTree ]]
    then
      apt -y remove cherrytree
  elif [[ "$app" =~ Graphana ]]
    then
      apt remove graphana
      rm /usr/local/sbin/graphana # remove the pointer-binary that we made
  elif [[ "$app" =~ Stacer ]]
    then
      apt -y remove stacer
  else
    printf "[+] Recieved $app\n";
  fi
  killBar
}

installApp () { # All of the blocks of code to install each app individually:
  app=$1
  if [[ "$app" =~ \|TRUE\|$ ]]
    then # We uninstall it:
      uninstall $app
  else # we install it:
    app=$1
    app=$(echo $app|sed -r 's/TRUE\|([^|]+)\|.*/\1/');
    progressText="\nInstalling $app ...   "
    # Check if App is already installed (could have been pre-checked in the checklist)
    printf "[+] Checking if "$app" is already installed ... \n";
    if [ $(which "${app,,}"|wc -l) -ne 1 ] && [ $(which $app|wc -l) -ne 1 ] # uses syntax sugar to lowercase the name
      then
        ### Spotify:
        if [ "$app" == "Spotify" ]
          then # Install Spotify:
            progressBar $progressText
            apt install snapd -y
            snap install spotify
            if [ $(grep /snap/bin ~/.bashrc|wc -l) -eq 0 ]
              then
                echo "export PATH=\$PATH:/snap/bin:/snap/sbin" >> ~/.bashrc # update our PATH
            fi
        ### Pentester's Framework from TrustedSec:
        elif [ "$app" == "PTF" ]
          then
            progressBar $progressText
            apt install python-pip python-expect -y
            cd /infosec && git clone https://github.com/trustedsec/ptf
            if [ $(grep ptf ~/.bashrc|wc -l) -eq 0 ]
              then
                echo "PATH=\$PATH:/infosec/ptf" >> ~/.bashrc # update our PATH
            fi
        ### Burp Suite
        elif [ "$app" == "Burp Suite" ]
          then
            downloadFile https://demonlinux.com/download/packages/burpsuite.sh $app "/opt/burpsuite.sh"
            progressBar $progressText
            cd /opt/ && chmod +x burpsuite.sh
            cp /appdev/Demon-App-Store/desktop/burp.desktop /usr/share/applications
            cp /appdev/Demon-App-Store/icons/burp.png /usr/share/demon/images/icons/
            killBar
            ./burpsuite.sh
        ### TorBrowser
        elif [ "$app" == "Tor-Browser" ]
          then
            downloadFile https://www.torproject.org/dist/torbrowser/8.5.4/tor-browser-linux64-8.5.4_en-US.tar.xz "Tor-Browser" "/opt/tor-browser-linux64-8.5.4_en-US.tar.xz"
            cd /opt
            progressBar $progressText
            xz -d tor-browser-linux64-8.5.4_en-US.tar.xz
            tar vxf tor-browser-linux64-8.5.4_en-US.tar
            rm tor-browser-linux64-8.5.4_en-US.tar
            sed -ie 's/`" -eq 0/`" -ne 0/' tor-browser_en-US/Browser/start-tor-browser # whoopsey daisey!
            echo "cd /opt/tor-browser_en-US/Browser && ./start-tor-browser" > /usr/local/sbin/tor-browser
            chmod +x /usr/local/sbin/tor-browser
        ### Cutter
        elif [ "$app" == "Cutter" ]
          then # Install Cutter:
            downloadFile https://github.com/radareorg/cutter/releases/download/v1.8.3/Cutter-v1.8.3-x64.Linux.AppImage $app /usr/local/sbin/Cutter
            killBar
            progressBar $progressText
            chmod +x /usr/local/sbin/Cutter
        ### Atom "IDE":
        elif [ "$app" == "Atom" ]
          then
            downloadFile https://github.com/atom/atom/releases/download/v1.40.0/atom-amd64.deb $app /tmp/atom-amd64.deb
            killBar
            progressBar $progressText
            cd /tmp
            dpkg -i atom-amd64.deb
            apt -f install -y # just in case-icles
        ### Eclipse for Java Devs:
        elif [ "$app" == "Eclipse" ]
          then
            downloadFile 'http://demonlinux.com/download/packages/eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz' $app /tmp/eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz
            progressBar $progressText
            cd /tmp
            tar vxzf eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz # crack it open
            mv /tmp/eclipse /opt/ # toss it into a shared space
            binFile=/usr/local/bin/eclipse
            echo "#!/bin/bash " > $binFile
            echo "cd /opt/eclipse && ./eclipse " >> $binFile
            chmod +x $binFile
        ### VLC Media Player:
        elif [ "$app" == "VLC" ]
          then
            progressBar $progressText
            apt install vlc -y
            sed -i 's/geteuid/getppid/' /usr/bin/vlc
        ### Brave little web browser:
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
        ### Googlefornia's shitty browser:
        elif [ "$app" == "Google-Chrome" ]
          then
            downloadFile 'http://demonlinux.com/download/packages/google-chrome-stable_current_amd64.deb' 'Google-Chrome' '/tmp/google-chrome-stable_current_amd64.deb'
            cd /tmp
            progressBar $progressText
            dpkg -i google-chrome-stable_current_amd64.deb
            apt -f install -y
            # great. Now we have a lot of cleaning up to do for Googlefornia.
            mv /usr/bin/google-chrome /usr/bin/google-chrome-script
            echo "google-chrome-script --no-sandbox" > /usr/bin/google-chrome
            chmod +x /usr/bin/google-chrome
            mv /usr/bin/google-chrome-stable /usr/bin/google-chrome-script
            echo "google-chrome --no-sandbox" > /usr/bin/google-chrome-stable
            chmod +x /usr/bin/google-chrome-stable
        ### Sublime text editor:
      elif [ "$app" == "Sublime_Text" ]
          then
            downloadFile "https://download.sublimetext.com/sublime_text_3_build_3207_x64.tar.bz2" $app "/tmp/sublime_text_3_build_3207_x64.tar.bz2"
            cd /tmp
            progressBar $progressText
            binFile=/usr/local/bin/sublime
            tar vjxf sublime_text_3_build_3207_x64.tar.bz2
            mv sublime_text_3 /opt/sublime3
            echo "#!/bin/bash" > $binFile
            echo "cd /opt/sublime3 && ./sublime_text " >> $binFile
            chmod +x $binFile
        ### SimpleNote
        elif [ "$app" == "SimpleNote" ]
          then
            downloadFile 'https://github.com/Automattic/simplenote-electron/releases/download/v1.7.0/Simplenote-linux-1.7.0-amd64.deb' $app "/tmp/Simplenote-linux-1.7.0-amd64.deb"
            cd /tmp
            progressBar $progressText
            dpkg -i Simplenote-linux-1.7.0-amd64.deb
            apt -f install -y
        ### KdenLive:
        elif [ "$app" == "Kdenlive" ]
          then
            LOCALAREA=/usr/local/bin/kdenlive
            downloadFile 'https://files.kde.org/kdenlive/release/Kdenlive-16.12.2-x86_64.AppImage' $app $LOCALAREA
            cd /tmp
            progressBar $progressText
            apt install -y ffmpeg libavc1394-tools dvdauthor genisoimage
            chmod +x $LOCALAREA
        ### ShotCut:
        elif [ "$app" == "Shotcut" ]
          then
            LOCALAREA=/usr/local/bin/shotcut
            downloadFile https://github.com/mltframework/shotcut/releases/download/v19.08.16/Shotcut-190816.glibc2.14-x86_64.AppImage $app $LOCALAREA
            progressBar $progressText
            chmod +x $LOCALAREA
        ### Franz Messaging:
        elif [ "$app" == "Franz" ]
          then
            LOCALAREA=/usr/local/bin/franz
            downloadFile https://github.com/meetfranz/franz/releases/download/v5.2.0/franz-5.2.0-x86_64.AppImage $app $LOCALAREA
            progressBar $progressText
            chmod +x $LOCALAREA
        ### Visual Studio:
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
        ### Maltego CE:
        elif [ "$app" == "Maltego" ]
          then
            LOCALAREA=/tmp/Maltego.v4.2.6.12502.deb
            downloadFile http://www.demonlinux.com/download/packages/Maltego.v4.2.6.12502.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i Maltego.v4.2.6.12502.deb
            apt -f install -y
        ### Slack:
        elif [ "$app" == "Slack" ]
          then
            LOCALAREA=/tmp/slack-desktop-4.0.1-amd64.deb
            downloadFile  https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.1-amd64.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i slack-desktop-4.0.1-amd64.deb
            apt -f install -y
        ### PyCharm (FREE)
        elif [ "$app" == "PyCharm" ]
          then
            LOCALAREA=/opt/pycharm-professional-2019.2.tar.gz
            downloadFile 'https://download.jetbrains.com/python/pycharm-professional-2019.2.tar.gz' $app $LOCALAREA
            progressBar $progressText
            cd /opt/
            tar vxzf pycharm-professional-2019.2.tar.gz
            rm pycharm-professional-2019.2.tar.gz
            binFile=/usr/local/bin/pycharm
            echo "#!/bin/bash" > $binFile
            echo "cd /opt/pycharm-2019.2/bin && ./pycharm.sh" >> $binFile
            chmod +x $binFile
        ### DBeaver
        elif [ "$app" == "DBeaver" ]
          then
            LOCALAREA=/tmp/dbeaver-ce_latest_amd64.deb
            downloadFile https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i dbeaver-ce_latest_amd64.deb
            apt -f install -y
        ### Discord:
        elif [ "$app" == "Discord" ]
          then
            LOCALAREA=/tmp/discord-0.0.9.deb
            downloadFile 'https://discordapp.com/api/download?platform=linux&format=deb' $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i discord-0.0.9.deb
            apt -f install -y
        ### CherryTree
        elif [ "$app" == "CherryTree" ]
          then
            LOCALAREA=/tmp/python-gtksourceview2_2.10.1-3_amd64.deb
            downloadFile http://ftp.de.debian.org/debian/pool/main/p/pygtksourceview/python-gtksourceview2_2.10.1-3_amd64.deb "CherryTree Dependency" $LOCALAREA
            cd /tmp
            dpkg -i python-gtksourceview2_2.10.1-3_amd64.deb
            apt -f install -y
            LOCALAREA=/tmp/cherrytree_0.38.9-0_all.deb
            downloadFile http://www.giuspen.com/software/cherrytree_0.38.9-0_all.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i cherrytree_0.38.9-0_all.deb
            apt -f install -y
        ### Graphana
        elif [ "$app" == "Graphana" ]
          then
            LOCALAREA=/tmp/grafana_6.3.3_amd64.deb
            downloadFile https://dl.grafana.com/oss/release/grafana_6.3.3_amd64.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i grafana_6.3.3_amd64.deb
            apt -f install -y
            echo "#!/bin/bash" > /usr/local/sbin/graphana
            echo "service grafana-server start" >> /usr/local/sbin/graphana
            echo "/opt/firefox/firefox-bin http://127.0.0.1:3000" >> /usr/local/sbin/graphana
            chmod +x /usr/local/sbin/graphana
        ### AnyDesk
        elif [ "$app" == "AnyDesk" ]
          then
            LOCALAREA=/tmp/anydesk_5.1.1-1_amd64.deb
            downloadFile http://www.demonlinux.com/download/packages/anydesk_5.1.1-1_amd64.deb $app $LOCALAREA
            progressBar $progressText
            cd /tmp
            dpkg -i anydesk_5.1.1-1_amd64.deb
            apt -f install -y
        ### Stacer:
        elif [ "$app" == "Stacer" ]
          then
            LOCALAREA=/tmp/stacer_1.1.0_amd64.deb
            downloadFile 'https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb' $app $LOCALAREA
            cd /tmp
            progressBar $progressText
            dpkg -i stacer_1.1.0_amd64.deb
            apt -f install -y
        elif [[ "$app" =~ IntelliJ ]]
          then
            progressBar $progressText
            apt install snapd -y
            snap install spotify
            snap install intellij-idea-community --classic
        else
            printf "[!] Unknown app was requested! $app\n\n"
        fi
        sleep 1 # DEBUG
        killBar
    fi
  fi
}

main () {
 # Update Me:
  #updateMe # This will pull the latest version each time. # comment out during development
  # This may seem crazy, but it's for the UI/UX sake:
  for app in $(yad --width=685 --height=400 --title=$APPNAME\
    --button=Help:"bash -c help" --button=Cancel:1 --button="Make Changes:0"\
   --list --column=Install:CHK --column="App Name" --column=Description \
   --column="Uninstall:CHK" \
   --image=$WINDOWIMAGE \
   --window-icon=$WINDOWICON \
   --text=$APPTEXT \
   $(if [[ $(which spotify|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Spotify" "Spotify desktop app" false \
   $(if [[ $(which graphana|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Graphana" "open platform for beautiful analytics and monitoring" false \
   $(if [[ $(which BurpSuiteCommunity|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Burp Suite" "Web vulnerability scanner and proxy." false \
   $(if [[ $(which cherrytree|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "CherryTree" "A hierarchical note taking application" false \
   $(if [[ $(which slack|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Slack" "Slack collaboration tool" false \
   $(if [[ $(which discord|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Discord" "Voice and text chat for gamers" false \
   $(if [[ $(which tor-browser|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Tor-Browser" "The Tor Project Browser"  false \
   $(if [[ $(which pycharm|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PyCharm" "The Python IDE for Professional Developers"  false \
   $(if [[ $(which intellij-idea-community|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "IntelliJ IDEA Community" "Java IDE for Developers"  false \
   $(if [[ $(which ptf|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "PTF" "TrustedSec's Pentester's Framework" false \
   $(if [[ $(which dbeaver|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "DBeaver" "Database tool for developers" false \
   $(if [[ $(which maltego|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Maltego" "Paterva's information gathering tool" false \
   $(if [[ $(which Cutter|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Cutter" "Reverse engineering tool" false \
   $(if [[ $(which atom|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Atom" "Atom IDE" false \
   $(if [[ $(which eclipse|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Eclipse" "Eclipse IDE for Java" false \
   $(if [[ $(which vlc|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "VLC" "Multimedia player and framework" false \
   $(if [[ $(which anydesk|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "AnyDesk" "Remote Desktop App" false \
   $(if [[ $(which brave-browser|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Brave-Browser" "Much more than a web browser" false \
   $(if [[ $(which google-chrome|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Google-Chrome" "Google's web browser" false \
   $(if [[ $(which sublime|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Sublime_Text" "Sublime text editor" false \
   $(if [[ $(which simplenote|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "SimpleNote" "The simplest way to keep notes" false \
   $(if [[ $(which kdenlive|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Kdenlive" "Video editor program" false \
   $(if [[ $(which shotcut|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Shotcut" "Video editor program" false \
   $(if [[ $(which franz|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Franz" "Messaging client app" false \
   $(if [[ $(which VisualStudio|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "VisualStudio" "Microsoft's Visual Studio code editor" false \
   $(if [[ $(which stacer|wc -l) -eq 1 ]]; then printf "true"; else printf "false"; fi) "Stacer" "System optimizer app" ); do installApp $app; done
  # All done!
}
main
complete
