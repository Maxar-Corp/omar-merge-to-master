#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
. $SCRIPT_DIR/env.sh
. $SCRIPT_DIR/gitCredentials.sh

function releaseRepo {
   OWNER=$1
   REPO=$2

   if [ -z $OWNER ] ; then
      echo "OWNER is empty and needs to be set."
      exit 1
   fi
   if [ -z $REPO ] ; then
      echo "REPO is empty and needs to be set."
      exit 1
   fi


   curl -d "${JSON_DATA}" -u $GITHUB_USERNAME:$GITHUB_PASSWORD -X POST "https://api.github.com/repos/${OWNER}/${REPO}/releases"
}

for file in $RADIANTBLUE_FILES ; do
  # if [ ! -e $file ] ; then
    echo "Release $file"
    releaseRepo radiantbluetechnologies $file
  # fi
done

for file in $OSSIMLABS_FILES ; do
  # if [ ! -e $file ] ; then
    echo "Release $file"
    releaseRepo ossimlabs $file
  # fi
done

releaseRepo radiantbluetechnologies omar
