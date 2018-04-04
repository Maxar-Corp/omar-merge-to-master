#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SCRIPT_DIR=`pwd -P`
popd >/dev/null
if [ -z $TAG_RELEASE_NAME] ; then
  export TAG_RELEASE_NAME="Gasparilla-2.3.1"
fi

if [ -z $TAG_RELEASE_BRANCH ] ; then
  export TAG_RELEASE_BRANCH="master"
fi

export TAG_DESCRIPTION="Official Gasparilla Release version 2.3.1"
export OSSIMLABS_URL="https://github.com/ossimlabs"
export RADIANTBLUE_URL="https://github.com/radiantbluetechnologies"
export RADIANTBLUE_FILES=(
"isa-ui \
 oc2s-metrics-dashboards \
 o2-paas \
 omar-merge-to-master \
 ossim_kakadu_jpip_server \
 ossim-isa \
 ossim-msp-plugin \
 ossim-private")
export OSSIMLABS_FILES=(
"omar \
 omar-admin-server \
 omar-avro \
 omar-avro-metadata \
 omar-backend-tests \
 omar-base \
 omar-basemap \
 omar-cesium-terrain-builder \
 omar-cesium-terrain-server \
 omar-common \
 omar-config-server \
 omar-core \
 omar-database \
 omar-disk-cleanup \
 omar-docs \
 omar-download \
 omar-eureka-server \
 omar-frontend-tests \
 omar-geoscript \
 omar-git-mirror \
 omar-hibernate-spatial \
 omar-ingest-metrics \
 omar-ingest-tests \
 omar-jpip \
 omar-mapproxy \
 omar-mensa \
 omar-oldmar \
 omar-oms \
 omar-openlayers \
 omar-opir \
 omar-ossim-base \
 omar-ossimtools \
 omar-raster \
 omar-scdf \
 omar-scdf-aggregator \
 omar-scdf-downloader \
 omar-scdf-extractor \
 omar-scdf-file-parser \
 omar-scdf-indexer \
 omar-scdf-image-info
 omar-scdf-kafka \
 omar-scdf-notifier-email \
 omar-scdf-s3-extractor-filter \
 omar-scdf-s3-filter \
 omar-scdf-server \
 omar-scdf-stager \
 omar-scdf-sqs \
 omar-scdf-s3-uploader \
 omar-scdf-zookeeper \
 omar-twofishes \
 omar-turbine-server\
 omar-security \
 omar-service-proxy \
 omar-services \
 omar-sqs \
 omar-sqs-stager \
 omar-stager \
 omar-superoverlay \
 omar-ui \
 omar-wcs \
 omar-web-proxy \
 omar-wfs \
 omar-wms \
 omar-wmts \
 omar-video \
 omar-zipkin-server \
 omar-zuul-server \
 ossim \
 ossim-batch-test \
 ossim-ci \
 ossim-csm-plugin \
 ossim-gui \
 ossim-jpip-server \
 ossim-oms \
 ossim-planet \
 ossim-plugins \
 ossim-vagrant \
 ossim-video \
 ossim-wms \
 ossim-rpm \
 ossim-rpm-dependencies \
 tlv")


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

function extractId {
 eval $1=`echo $2 |grep -o -m1 '"id"\:.*\,'|tr -cd '[:digit:],'|cut -d "," -f1 `
}


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
