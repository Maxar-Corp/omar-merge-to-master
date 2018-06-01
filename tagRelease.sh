#!/bin/bash
# This script tags the omar/ossim git repositories with release informatin provided in the
# environment. If this is run from an interactive shell, it will prompt for needed parameters,
# Otherwise, it presumes it is launched from a Jenkins script and will read the following env
# vars provided by the pipeline:
#
#   RELEASE_NAME
#   VERSION_TAG
#   GIT_PUBLIC_SERVER_URL
#   GIT_PRIVATE_SERVER_URL
#   GITHUB_USERNAME
#   GITHUB_PASSWORD
#
#

# Uncomment following line to debug script line by line:
#set -x; trap read debug

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./env.sh
popd >/dev/null

echo RELEASE_NAME = $RELEASE_NAME
echo VERSION_TAG = $VERSION_TAG

#-------------------------------------------------------------------------------------

function releaseRepo {
   ACCOUNT=$1
   REPO=$2
   echo "JSON_DATA:--------------";echo ${JSON_DATA}; echo "--------------";
   curl -d "${JSON_DATA}" -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X POST "https://api.github.com/repos/${ACCOUNT}/${REPO}/releases"
}

#-------------------- MAIN SCRIPT SECTION ---------------------------------------

checkGitURLsAndCreds

# Prompt if needed, and only if interactive shell:
if [ -t 1 ] ; then
   if [ -z "$RELEASE_NAME" ]; then
      read -p "Enter release name: " RELEASE_NAME
   fi
   if [ -z "$VERSION_TAG" ]; then
      read -p "Enter release number: " VERSION_TAG
   fi
fi

if [ -z "$RELEASE_NAME" ] || [ -z "$VERSION_TAG" ]; then
   echo; echo "ERROR: Release name or version tag must be provided. Aborting. "; echo
   exit 1
fi
TAG_RELEASE_NAME=${RELEASE_NAME}-${VERSION_TAG}
echo RELEASE_NAME = $RELEASE_NAME
echo VERSION_TAG = $VERSION_TAG
echo TAG_RELEASE_NAME = $TAG_RELEASE_NAME
setGitJsonData

for repo in $RADIANTBLUE_REPOS ; do
  # if [ ! -e $repo ] ; then
    echo "Tagging $repo"
    releaseRepo radiantbluetechnologies $repo
  # fi
done

for repo in $OSSIMLABS_REPOS ; do
  # if [ ! -e $repo ] ; then
    echo "Tagging $repo"
    releaseRepo ossimlabs $repo
  # fi
done

releaseRepo radiantbluetechnologies omar
