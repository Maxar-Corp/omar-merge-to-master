#!/bin/bash
# If launched from a Jenkins script, will read the following env vars provided by the pipeline:
#
#   RELEASE_NAME
#   VERSION_TAG
#   TAG_DESCRIPTION
#   GIT_PUBLIC_SERVER_URL
#   GIT_PRIVATE_SERVER_URL
#   TAG_RELEASE_BRANCH
#
# Uncomment following line to debug script line by line:
#set -x; trap read debug

#-------------------------------------------------------------------------------------

usage() {
   echo
   echo "This script tags the omar/ossim git repositories with release information provided"
   echo "either via the options or the prompted entries."
   echo "See script for comments on parameter settings via environment variables."
   echo
   echo "Usage:  $0 [options]"
   echo
   echo "Options:"
   echo
   echo "  --branch <label>        Branch HEAD to tag (defaults to 'master')"
   echo "  --description <string>  Release description string"
   echo "  -h, --help              Prints usage. "
   echo "  --release-name <name>   Release Name, e.g., \"Hollywood\"."
   echo "  --tag <version>         Version tag, e.g. \"2.4.0\"."
   echo
   exit 1;
}

#-------------------------------------------------------------------------------------

function tagRepo {
   local ACCOUNT=$1
   local REPO=$2

   echo; echo "Tagging $repo... "
   curl -X POST -d "$JSON_DATA" "https://api.github.com/repos/:$ACCOUNT/$REPO"
   if [ $? != 0 ] ; then
      echo "Failed while pushing new tag."
   fi
   popd > /dev/null
   rm -rf $REPO
}

#-------------------- MAIN SCRIPT SECTION ---------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./O2-Repo-List.sh
. ./common.sh
popd >/dev/null

# Parse command line
while [ $# -gt 0 ]; do
   case $1 in
      --branch) TAG_RELEASE_BRANCH=$2 ; shift ;;
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

if [ -z "$TAG_RELEASE_BRANCH" ]; then
   TAG_RELEASE_BRANCH="master"
fi

TAG_RELEASE_NAME=${RELEASE_NAME}-${VERSION_TAG}
echo RELEASE_NAME = $RELEASE_NAME
echo VERSION_TAG = $VERSION_TAG
echo TAG_RELEASE_NAME = $TAG_RELEASE_NAME
echo TAG_DESCRIPTION = $TAG_DESCRIPTION

JSON_DATA='{
   "tag_name": "${TAG_RELEASE_NAME}",
   "target_commitish": "master",
   "name": "${TAG_RELEASE_NAME}",
   "body": "${TAG_RELEASE_NAME}",
   "draft": false,
   "prerelease": false
}'

for repo in $RADIANTBLUE_REPOS ; do
    tagRepo $GIT_PRIVATE_SERVER_URL $repo
done

for repo in $OSSIMLABS_REPOS ; do
    tagRepo $GIT_PUBLIC_SERVER_URL $repo
done

tagRepo $GIT_PRIVATE_SERVER_URL omar
