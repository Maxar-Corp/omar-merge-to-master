#!/bin/bash
if [ -z $1 ] ; then
 echo "Need to specify a tag.  Example:  $0 dev or $0 master"
 exit 1
fi
COMMAND="aws s3 rm --recursive s3://o2-delivery/$1" 


${COMMAND}/docker
${COMMAND}/jars
${COMMAND}/o2-rpms
${COMMAND}/o2-install-guide
${COMMAND}/ossim
${COMMAND}/src



