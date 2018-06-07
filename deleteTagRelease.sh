#!/bin/bash
#
# Deletes tag from all O2 Github repositories.
# Expected in environment:
#
#    TAG_RELEASE_NAME
#
#  Will be prompted if not provided:
#    GITHUB_USERNAME
#    GITHUB_PASSWORD

# Uncomment following line to debug script line by line:
#set -x; trap read debug


pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd`
. ./O2-Repo-List.sh
popd >/dev/null

#-------------------------------------------------------------------------------------

function extractId {
 eval $1=`echo $2 |grep -o -m1 '"id"\:.*\,'|tr -cd '[:digit:],'|cut -d "," -f1 `
}

#-------------------------------------------------------------------------------------

function deleteReleaseRepo {
  local ACCOUNT=$1
  local REPO=$2
  local DATA=$(curl -s -u ${GITHUB_USERNAME}:${GITHUB_PASSWORD} -X GET https://api.github.com/repos/${ACCOUNT}/${REPO}/releases)
  extractId RELEASE_ID "$DATA"

  curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${ACCOUNT}/${REPO}/releases/${RELEASE_ID}"
  curl -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X DELETE "https://api.github.com/repos/${ACCOUNT}/${REPO}/git/refs/tags/${TAG_RELEASE_NAME}"
}

#-------------------------------------------------------------------------------------

checkGitURLsAndCreds

for repo in $RADIANTBLUE_REPOS ; do
  if [ ! -e $repo ] ; then
    deleteReleaseRepo radiantbluetechnologies $repo
  fi
done

for repo in $OSSIMLABS_REPOS ; do
  if [ ! -e $repo ] ; then
    deleteReleaseRepo ossimlabs $repo
  fi
done

deleteReleaseRepo radiantbluetechnologies omar
