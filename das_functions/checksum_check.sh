#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
# Checksum checker function. This will download files.
# -------------------
#
printf "[INFO]: Initiated Function Script: $0\n"
# Constants:
export DAS_FILE=$1
export DAS_CHECKSUM=$2
export DAS_URL=$3
export DAS_APP=$4

# Workflow:
if [ -f $DAS_FILE ]
  then # File exists, check the checksum given:
    printf "[+] Cached file found: $DAS_FILE\n"
    if [[ ! $(md5sum $DAS_FILE) =~ $DAS_CHECKSUM ]]
      then # failed, re-download
        rm -rf $DAS_FILE # remove borked version
        printf "[i] $DAS_APP Failed checksum check ($DAS_CHECKSUM). Re-downloading file: $DAS_URL \n"
        ./das_functions/download_file.sh $DAS_URL $DAS_APP $DAS_FILE # download
    else
      printf "[+] Checksum ($DAS_CHECKSUM) verified, [ OK ]\n"
    fi
else
  # I am calling the download_file script to do the download
  ./das_functions/download_file.sh $DAS_URL $DAS_APP $DAS_FILE
fi
