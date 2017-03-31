#!/bin/bash
###############################################################################
#
# got = git for OSSIM
#
# Convenience script for performing git operations on multiple OSSIMLABS repos.
# Up to four git parameters are handled, for example:
#
#    got commit -a
#    got log --oneline --graph
#
# Obviously, only commands that make sense to run on all repos will work. You
# can't commit a specific file for example.
#
# Run this script from ossimlabs parent directory (a.k.a. OSSIM_DEV_HOME)
#
###############################################################################
function checkoutFile {
  repoUrl=$1
  repo=$2
  target=$3
  #if [ ! -z $repoUrl -a ! -z $repo -a ! -z $target ] ; then
    git clone $repoUrl/$repo $target
  #else
  #  echo "Usage: checkoutFile <repoUrl> <repo> <target>"
  #  exit 1
  #fi
}

function mergeToMaster {
  FILES=$1
 for file in $FILES ; do
    if [ -e $file ] ; then
      echo "************ PUSHING DIRECTORY $file ************"
      pushd $file
      git checkout dev
      git pull --all
      git checkout master
      git pull --all
      git merge -m "Merging dev into master" dev
      git push
      git checkout dev
      popd
    else
      echo "************ Directory $file is not present. Skipping merge ************"
    fi
  done
 
}

export OSSIMLABS_URL="https://github.com/ossimlabs"
export RADIANTBLUE_URL="https://github.com/radiantbluetechnologies"
export RADIANTBLUE_FILES=("cucumber-oc2s o2-paas ossim-private")
export OSSIMLABS_FILES=("omar ossim ossim-ci ossim-gui ossim-oms ossim-planet ossim-plugins \
 ossim-vagrant ossim-video ossim-wms omar-avro omar-common omar-core omar-download omar-geoscript omar-hibernate-spatial omar-ingest-metrics\
 omar-jpip omar-mensa  omar-oms omar-openlayers omar-opir omar-ossimtools omar-raster omar-security omar-service-proxy\
 omar-services omar-sqs omar-stager omar-superoverlay omar-ui omar-video omar-wcs omar-wfs omar-wms omar-wmts\
 three-disa tlv")

echo "ABOUT TO CHECKOUT FILES"
for file in $RADIANTBLUE_FILES ; do
  if [ ! -e $file ] ; then
    checkoutFile $RADIANTBLUE_URL $file  $file
  fi
done

for file in $OSSIMLABS_FILES ; do
  if [ ! -e $file ] ; then
    checkoutFile $OSSIMLABS_URL $file $file
  fi
done

if [ ! -e oldmar ] ; then
    checkoutFile $RADIANTBLUE_URL omar oldmar
fi


mergeToMaster "${RADIANTBLUE_FILES[@]}"
mergeToMaster "${OSSIMLABS_FILES[@]}"
mergeToMaster "oldmar"


# for file in $FILES ; do
#   if [ -e $file ] ; then
#     echo "************ PUSHING DIRECTORY $file ************"
#     pushd $file
#     git checkout dev
#     git pull --all
#     git checkout master
#     git pull --all
#     git merge -m "Merging dev into master" dev
#     git push
#     git checkout dev
#     popd
#   else
#     echo "************ Directory $file is not present. Skipping merge ************"
#   fi
# done
