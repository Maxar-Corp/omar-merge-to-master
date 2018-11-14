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
  echo
  echo repoUrl=$repoUrl
  echo repo=$repo
  echo target=$target
  # git clone $repoUrl/$repo $target
  git clone https://${GIT_USER}:${GIT_PASSWORD}@github.com/{GIT_USER}/$repo.git $target
}

#-------------------------------------------------------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./O2-Repo-List.sh
. ./common.sh
popd >/dev/null

checkGitURLsAndCreds

if [ -d repositories ]; then
   rm -rf repositories
fi 
mkdir repositories
pushd repositories

echo "ABOUT TO CHECKOUT REPOS"
for repo in $MAXAR_CORP_REPOS ; do
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
#    cloneRepo $MAXAR_CORP_URL omar oldmar
#fi


mergeToMaster "${MAXAR_CORP_REPOS[@]}"
mergeToMaster "${OSSIMLABS_REPOS[@]}"
popd
#mergeToMaster "oldmar"
