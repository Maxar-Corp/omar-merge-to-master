#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./env.sh
popd >/dev/null

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
