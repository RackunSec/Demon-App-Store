#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
# Function for downloading files
# -------------------
# Constants:
export DAS_WINDOWICON=$(cat ./das_config.txt|grep DAS_WINDOWICON|sed 's/.*=//')
export DAS_DL_ICON=$(cat ./das_config.txt|grep DAS_DL_ICON|sed 's/.*=//')
# Workflow:
wget $1 --no-check-certificate -U mozilla -O $3  2>&1 | \
sed -u 's/^[a-zA-Z\-].*//; s/.* \{1,2\}\([0-9]\{1,3\}\)%.*/\1\n#Downloading ...\1%/; s/^20[0-9][0-9].*/#Done./'\
  | yad --progress --title="Download in Progress" \
  --window-icon=$DAS_WINDOWICON --image=$DAS_DL_ICON --width=350 --center \
  --text="\nDownloading $2 ... " --auto-close --no-buttons --undecorated
