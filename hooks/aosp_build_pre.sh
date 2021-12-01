#!/usr/bin/env bash

cd "${AOSP_BUILD_DIR}"

echo "applying microg patches"
cd "${AOSP_BUILD_DIR}/packages/modules/Permission"
patch -p1 --no-backup-if-mismatch < "${AOSP_BUILD_DIR}/platform/prebuilts/microg/00001-fake-package-sig.patch"
cd "${AOSP_BUILD_DIR}/frameworks/base"
patch -p1 --no-backup-if-mismatch < "${AOSP_BUILD_DIR}/platform/prebuilts/microg/00002-microg-sigspoof.patch"

find ${AOSP_BUILD_DIR} -name mkbootfs.c
tree -d ${AOSP_BUILD_DIR}

cd "${AOSP_BUILD_DIR}/frameworks/base"
patch -p1 --no-backup-if-mismatch < "${AOSP_BUILD_DIR}/platform/prebuilts/magisk/00003-magisk_mkbootfs.patch"

# apply custom hosts file
custom_hosts_file="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
echo "applying custom hosts file ${custom_hosts_file}"
retry wget -q -O "${AOSP_BUILD_DIR}/system/core/rootdir/etc/hosts" "${custom_hosts_file}"
