#!/bin/bash
#
# Performs merge of dev to master branch for all O2 git repositories.

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./env.sh
popd >/dev/null

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
