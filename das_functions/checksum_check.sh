#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
# Checksum checker function. This will download files.
# -------------------
# Constants:
FILE=$1
CHECKSUM=$2
URL=$3
APP=$4
# Workflow:
if [ -f $FILE ]
  then # File exists, check the checksum given:
    printf "[+] Cached file found: $FILE\n"
    if [[ ! $(md5sum $FILE) =~ $CHECKSUM ]]
      then # failed, re-download
        rm -rf $FILE # remove borked version
        printf "[i] $APP Failed checksum check ($CHECKSUM). Re-downloading file: $URL \n"
        ./das_functions/download_file.sh $URL $APP $LOCALAREA # download
    else
      printf "[+] Checksum ($CHECKSUM) verified, [ OK ]\n"
    fi
else
  # I am calling the download_file script to do the download
  ./das_functions/download_file.sh $URL $APP $LOCALAREA
fi
