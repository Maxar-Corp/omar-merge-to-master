#!/bin/bash
# This script tags the omar/ossim git repositories with release informatin provided in the
# environment. If this is run from an interactive shell, it will prompt for needed parameters,
# Otherwise, it presumes it is launched from a Jenkins script and will read the following env
# vars provided by the pipeline:
#
#   RELEASE_NAME
#   VERSION_TAG
#   TAG_DESCRIPTION
#   GIT_PUBLIC_SERVER_URL
#   GIT_PRIVATE_SERVER_URL
#   GITHUB_USERNAME
#   GITHUB_PASSWORD
#
# Uncomment following line to debug script line by line:
#set -x; trap read debug

JSON_DATA=""

#-------------------------------------------------------------------------------------

usage() {
   echo
   echo "This script tags the omar/ossim git repositories with release information provided"
   echo "either via the options or the prompted entries."
   echo
   echo "Usage:  $0 [options]"
   echo
   echo "Options:"
   echo
   echo "  --description <string>  Release description string"
   echo "  -h, --help              Prints usage. "
   echo "  --release-name <name>   Release Name, e.g., \"Hollywood\"."
   echo "  --tag <version>         Version tag, e.g. \"2.4.0\"."
   echo
   exit 1;
}

#-------------------------------------------------------------------------------------

function setGitJsonData {
   JSON_DATA=$(echo   \
   { \"tag_name\": \"${TAG_RELEASE_NAME}\",\
     \"target_commitish\":\"${TAG_RELEASE_BRANCH}\",\
     \"name\":\"${TAG_RELEASE_NAME}\",\
     \"body\":\"${TAG_DESCRIPTION}\",\
     \"draft\":false,\
     \"prerelease\":false\
   })
}

#-------------------------------------------------------------------------------------

function releaseRepo {
   ACCOUNT=$1
   REPO=$2
   echo "JSON_DATA:--------------";echo ${JSON_DATA}; echo "--------------";
   curl -d "${JSON_DATA}" -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X POST "https://api.github.com/repos/${ACCOUNT}/${REPO}/releases"
}

#-------------------- MAIN SCRIPT SECTION ---------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./O2-Repo-List.sh
. ./common.sh
popd >/dev/null

# Parse command line
while [ $# -gt 0 ]; do
   case $1 in
      --description) TAG_DESCRIPTION=$2 ; shift ;;
      -h|--help) usage ;;
      --release-name) RELEASE_NAME=${2} ; shift ;;
      --tag) VERSION_TAG=${2} ; shift ;;
      --) break ;;
      -*|--*) echo "$0: ERROR - unrecognized option $1" 1>&2; usage ;;
   esac
   shift
done

checkGitURLsAndCreds
checkReleaseInfo

TAG_RELEASE_NAME=${RELEASE_NAME}-${VERSION_TAG}
echo RELEASE_NAME = $RELEASE_NAME
echo VERSION_TAG = $VERSION_TAG
echo TAG_RELEASE_NAME = $TAG_RELEASE_NAME
echo TAG_DESCRIPTION = $TAG_DESCRIPTION
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
