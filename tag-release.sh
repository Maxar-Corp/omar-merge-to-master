#!/bin/bash
pushd `dirname $0` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
. $SCRIPT_DIR/env.sh




if [ -z $GITHUB_USER ] ; then
   echo -n "Please enter github username: "
   read GITHUB_USER
fi

if [ -z $GITHUB_PASSWORD ] ; then
   echo -n "Please enter github password: "
   read -s GITHUB_PASSWORD
fi


function repleaseRepo {
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

exec curl -d "${JSON_DATA}" -u $GITHUB_USER:$GITHUB_PASSWORD -X POST "https://api.github.com/repos/${OWNER}/${REPO}/releases"

}

deleteRepleaseRepo ossimlabs test-repo

for file in $RADIANTBLUE_FILES ; do
  if [ ! -e $file ] ; then
    repleaseRepo radiantbluetechnologies $file
  fi
done

for file in $OSSIMLABS_FILES ; do
  if [ ! -e $file ] ; then
    repleaseRepo ossimlabs $file
  fi
done
