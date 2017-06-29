#!/bin/bash
pushd `dirname $0` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
. $SCRIPT_DIR/env.sh
. $SCRIPT_DIR/git-credentials.sh


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
  echo $RELEASE_ID


 curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${OWNER}/${REPO}/releases/${RELEASE_ID}"
 curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${OWNER}/${REPO}/git/refs/tags/${TAG_RELEASE_NAME}"
}

function releaseRepo {
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


  exec curl -d "${JSON_DATA}" -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X POST "https://api.github.com/repos/${OWNER}/${REPO}/releases"
}

releaseRepo ossimlabs test-repo
# for file in $RADIANTBLUE_FILES ; do
#   if [ ! -e $file ] ; then
#     releaseRepo radiantbluetechnologies $file
#   fi
# done

# for file in $OSSIMLABS_FILES ; do
#   if [ ! -e $file ] ; then
#     releaseRepo ossimlabs $file
#   fi
# done

# releaseRepo radiantbluetechnologies omar
