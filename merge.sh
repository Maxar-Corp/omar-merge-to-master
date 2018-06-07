#!/bin/bash
#
# Performs merge of dev to master branch for all O2 git repositories.

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

#-------------------------------------------------------------------------------------

function cloneRepo {
  local repoUrl=$1
  local repo=$2
  local target=$3
  git clone $repoUrl/$repo $target
}

#-------------------------------------------------------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./O2-Repo-List.sh
. ./common.sh
popd >/dev/null

checkGitURLsAndCreds

echo "ABOUT TO CHECKOUT REPOS"
for repo in $RADIANTBLUE_REPOS ; do
  if [ ! -e $repo ] ; then
    cloneRepo $GIT_PRIVATE_SERVER_URL $repo $repo
  fi
done

for repo in $OSSIMLABS_REPOS ; do
  if [ ! -e $repo ] ; then
    cloneRepo $GIT_PUBLIC_SERVER_URL $repo $repo
  fi
done

#if [ ! -e oldmar ] ; then
#    cloneRepo $RADIANTBLUE_URL omar oldmar
#fi


mergeToMaster "${RADIANTBLUE_REPOS[@]}"
mergeToMaster "${OSSIMLABS_REPOS[@]}"
#mergeToMaster "oldmar"
