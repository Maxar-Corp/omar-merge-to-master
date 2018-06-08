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

#-------------------------------------------------------------------------------------

usage() {
   echo
   echo "This script deletes the specified tag from the collection of OMAR/OSSIM github repos."
   echo "User will be prompted if release info is not provided via options."
   echo "See script for comments on parameter settings via environment variables."
   echo
   echo "Usage:  $0 [options]"
   echo
   echo "Options:"
   echo
   echo "  -h, --help              Prints usage. "
   echo "  --release-name <name>   Release Name, e.g., \"Hollywood\"."
   echo "  --tag <version>         Version tag, e.g. \"2.4.0\"."
   echo
   exit 1;
}

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

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd`
. ./O2-Repo-List.sh
popd >/dev/null

# Parse command line
while [ $# -gt 0 ]; do
   case $1 in
      -h|--help) usage ;;
      --release-name) RELEASE_NAME=${2} ; shift ;;
      --tag) VERSION_TAG=${2} ; shift ;;
      --) break ;;
      -*|--*) echo "$0: ERROR - unrecognized option $1" 1>&2; usage ;;
   esac
   shift
done

checkGitURLsAndCreds
TAG_DESCRIPTION="N/A"
checkReleaseInfo

TAG_RELEASE_NAME=${RELEASE_NAME}-${VERSION_TAG}
echo TAG_RELEASE_NAME = $TAG_RELEASE_NAME

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
