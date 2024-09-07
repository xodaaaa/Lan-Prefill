#!/bin/bash
Cyan='\033[0;36m'
RED='\033[0;31m'
Yellow='\033[0;33m'
NC='\033[0m' # No Color

# Checking for required software
if ! [ -x "$(command -v curl)" ]; then
  echo -e "${RED}Required software curl is not installed.${NC}" >&2
  exit 1
fi
if ! [ -x "$(command -v jq)" ]; then
  echo -e "${RED}Required software jq is not installed.${NC}" >&2
  exit 1
fi
if ! [ -x "$(command -v unzip)" ]; then
  echo -e "${RED}Required software unzip is not installed.${NC}" >&2
  exit 1
fi
if ! [ -x "$(command -v wget)" ]; then
  echo -e "${RED}Required software wget is not installed.${NC}" >&2
  exit 1
fi

# Defining the version to download
VERSION="2.3.1"

# Download URL
DOWNLOAD_URL="https://github.com/tpill90/steam-lancache-prefill/releases/download/v${VERSION}/SteamPrefill-${VERSION}-linux-x64.zip"

# Downloading latest version
echo -e "${Yellow} Downloading... ${NC}"
wget -q -nc --show-progress --progress=bar:force:noscroll $DOWNLOAD_URL

# Unzip
echo -e "${Yellow} Unzipping... ${NC}"
unzip -q -j -o SteamPrefill-${VERSION}-linux-x64.zip

# Required so executable permissions don't get overwritten by unzip
chmod +x SteamPrefill update.sh

# Cleanup
rm SteamPrefill-${VERSION}-linux-x64.zip

echo -e " ${Cyan} Complete! ${NC}"