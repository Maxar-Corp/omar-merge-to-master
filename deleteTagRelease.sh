#!/bin/bash
#
# Deletes tag from all O2 Github repositories.
# Expected in environment, will be prompted if not provided:
#
#    TAG_RELEASE_NAME
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
   echo "  --tag <version>         tag to delete, e.g. \"Hollywood-2.4.0\"."
   echo
   exit 1;
}

#-------------------------------------------------------------------------------------

function untagRepo {
   local ACCOUNT=$1
   local REPO=$2

   echo; echo "Untagging $repo... "
   curl -X DELETE "https://api.github.com//repos/$ACCOUNT/$REPO/releases/${TAG_RELEASE_NAME}"
   if [ $? != 0 ] ; then
      echo "Failed while requesting tag deletion."
   fi
}

#-------------------------------------------------------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd`
. ./O2-Repo-List.sh
. ./common.sh
popd >/dev/null

# Parse command line
while [ $# -gt 0 ]; do
   case $1 in
      -h|--help) usage ;;
      --tag) TAG_RELEASE_NAME=${2} ; shift ;;
      --) break ;;
      -*|--*) echo "$0: ERROR - unrecognized option $1" 1>&2; usage ;;
   esac
   shift
done

checkGitURLsAndCreds
TAG_DESCRIPTION="N/A"
checkReleaseInfo

echo TAG_RELEASE_NAME = $TAG_RELEASE_NAME

for repo in $RADIANTBLUE_REPOS ; do
  if [ ! -e $repo ] ; then
    untagRepo radiantbluetechnologies $repo
  fi
done

for repo in $OSSIMLABS_REPOS ; do
  if [ ! -e $repo ] ; then
    untagRepo ossimlabs $repo
  fi
done

untagRepo $GIT_PRIVATE_SERVER_URL omar
