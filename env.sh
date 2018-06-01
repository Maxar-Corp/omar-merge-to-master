#!/bin/bash

# Must be regularly maintained:
. ./O2-Repo-List

JSON_DATA=""

if [ -z $TAG_RELEASE_BRANCH ] ; then
  TAG_RELEASE_BRANCH="master"
fi
if [ -z $TAG_DESCRIPTION ] ; then
  TAG_DESCRIPTION="NOT PROVIDED"
fi

#-------------------------------------------------------------------------------------

function setGitJsonData {
   JSON_DATA=$(cat  << EOF
   {"tag_name": "${TAG_RELEASE_NAME}",
   "target_commitish":"${TAG_RELEASE_BRANCH}",
   "name":"${TAG_RELEASE_NAME}",
   "body":"${TAG_DESCRIPTION}",
   "draft":false,
   "prerelease":false
   }
   EOF
   )
}
#-------------------------------------------------------------------------------------

function extractId {
 eval $1=`echo $2 |grep -o -m1 '"id"\:.*\,'|tr -cd '[:digit:],'|cut -d "," -f1 `
}

#-------------------------------------------------------------------------------------

function cloneRepo {
  local repoUrl=$1
  local repo=$2
  local target=$3
  git clone $repoUrl/$repo $target
}

#-------------------------------------------------------------------------------------

function checkGitURLsAndCreds {

   local OSSIMLABS_URL="https://github.com/ossimlabs"
   local RADIANTBLUE_URL="https://github.com/radiantbluetechnologies"

   # Use Jenkins-provided values if available, otherwise use those provided here
   if [ -z "$GIT_PUBLIC_SERVER_URL" ]; then
      GIT_PUBLIC_SERVER_URL=$OSSIMLABS_URL
   fi
   if [ -z "$GIT_PRIVATE_SERVER_URL" ]; then
      GIT_PUBLIC_SERVER_URL=$RADIANTBLUE_URL
   fi

   # Prompt if needed, and only if interactive shell:
   if [ -t 1 ] ; then
      if [ -z "$GITHUB_USERNAME" ]; then
         read -p "Github username: " GITHUB_USERNAME
      fi
      if [ -z "$GITHUB_PASSWORD" ]; then
         read -p "Github password: " GITHUB_PASSWORD
      fi
   fi
}

#-------------------------------------------------------------------------------------

function mergeToMaster {
   local REPOS=$1
   local repo=""
   for repo in $REPOS ; do
      if [ -e $repo ] ; then
         echo "************ PUSHING DIRECTORY $repo ************"
         pushd $repo
         git checkout dev
         git pull --all
         git checkout master
         git pull --all
         git merge -m "Merging dev into master" dev
         git push
         git checkout dev
         popd
      else
         echo "************ Directory $repo is not present. Skipping merge ************"
      fi
   done
}
