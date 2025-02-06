#!/bin/bash

# Set ARG
PLATFORM=$1
TAG=$2
if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
echo "${ARCH}"
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
XRAY_FILE="xray-linux-${ARCH}.zip"
XRAY_LINK="https://github.com/XTLS/Xray-core/releases/download/${TAG}/${XRAY_FILE}"
DGST_FILE="xray-linux-${ARCH}.zip.dgst"
DGST_LINK="https://github.com/XTLS/Xray-core/releases/download/${TAG}/${DGST_FILE}"

# Download Binary
echo "Downloading binary file: ${XRAY_FILE}"
wget --no-check-certificate -O ${PWD}/xray.zip "${XRAY_LINK}"
echo "Downloading binary file: ${DGST_FILE}"
wget --no-check-certificate -O ${PWD}/xray.zip.dgst "${DGST_LINK}"

# Check SHA512
# LOCAL=$(openssl dgst -sha512 xray.zip | sed 's/([^)]*)//g')
# STR=$(cat xray.zip.dgst | grep 'SHA512' | head -n1)
# if [ "${LOCAL}" = "${STR}" ]; then
#     echo " Check passed" && rm -fv xray.zip.dgst
# else
#     echo " Check have not passed yet " && exit 1
# fi

# Prepare
echo "Prepare to use"
unzip xray.zip && chmod +x xray
mv xray /usr/local/bin/
mv geosite.dat geoip.dat /usr/local/share/xray/

