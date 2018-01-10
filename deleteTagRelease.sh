#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
. $SCRIPT_DIR/env.sh
. $SCRIPT_DIR/gitCredentials.sh


function deleteReleaseRepo {
  OWNER=$1
  REPO=$2
  if [ -z $OWNER ] ; then
    echo "OWNER is empty and needs to be set."
    exit 1     
  fi
  if [ -z $REPO ] ; then
    echo "REPO is empty and needs to be set."
    exit 1     
  fi
  DATA=$(curl -s -u ${GITHUB_USERNAME}:${GITHUB_PASSWORD} -X GET https://api.github.com/repos/${OWNER}/${REPO}/releases)
  extractId RELEASE_ID "$DATA"

  curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${OWNER}/${REPO}/releases/${RELEASE_ID}"
  curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${OWNER}/${REPO}/git/refs/tags/${TAG_RELEASE_NAME}"
}

for file in $RADIANTBLUE_FILES ; do
  if [ ! -e $file ] ; then
    deleteReleaseRepo radiantbluetechnologies $file
  fi
done

for file in $OSSIMLABS_FILES ; do
  if [ ! -e $file ] ; then
    deleteReleaseRepo ossimlabs $file
  fi
done

deleteReleaseRepo radiantbluetechnologies omar
