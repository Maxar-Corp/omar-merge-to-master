# OC tag script for OMAR apps
#
# .
# Author: cdowin
# Date: 7/26/17
#!/bin/bash
echo
echo "This script has been superceded by o2-paas/openshift/deployment/tag-images.sh."
echo
exit 1

# Get the command line arguments
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
      -f|--from)
      FROM_TAG="$2"
      shift # past argument
      ;;
      -t|--to)
      TO_TAG="$2"
      shift # past argument
      ;;
      --untag)
      UNTAG=true
      shift # past argument
      ;;
      -h|--help)
      HELP=true
      shift # past argument
      ;;
      -o|--openshift)
      OPENSHIFT_URL="$2"
      shift # past argument
      ;;
      -u|--user)
      OPENSHIFT_USER="$2"
      shift # past argument
      ;;
      -p|--password)
      OPENSHIFT_PASSWORD="$2"
      shift # past argument
      ;;
      *)
              # unknown option
      ;;
  esac
  shift # past argument or value
done

#The static list of OMAR apps to tag or untag
OMAR_APPS=("\
omar-oldmar-app \
omar-wcs-app \
omar-wfs-app \
omar-wms-app \
omar-wmts-app \
omar-web-proxy-app \
omar-pki-proxy-app \
omar-config-server \
omar-eureka-server \
omar-stager-app \
omar-avro-app \
omar-avro-metadata \
omar-sqs-app \
omar-docs-app \
omar-download-app \
omar-geoscript-app \
omar-mensa-app \
omar-oms-app \
omar-superoverlay-app \
omar-jpip-app \
omar-opir-app \
isa-ui-app \
omar-ui-app \
tlv-app")

#ossim-msp-service \

## Help function
printHelp()
{
  echo
  echo "The ocTagHelper script provides a simple way to migrate OMAR images across OpenShift projects"
  echo
  echo "The script is meant to be used to tag or untag images from a given Docker image tag to another given tag."
  echo
  echo "Usage:"
  echo
  echo "   ocTagHelper.sh <tag_options> -o <openshift_url> -u <openshift_user> -p <openshift_password> <untag>"
  echo
  echo "      -f | --from        : The name of the tag from which to base the new image."
  echo "      -t | --to          : The name of the new image tag."
  echo "      -o | --openshift   : The OpenShift url."
  echo "      -u | --user        : The OpenShift user name."
  echo "      -p | --password    : The OpenShift password."
  echo "      -h | --help        : Print this help dialog."
  echo "      --untag            : Untag the OMAR images. Omit to tag images. Note this MUST be the final argument to the script."
  exit 1
}

## Untag function
untag()
{
  echo
  echo "Untagging images"

  if [ ! -e $FROM_TAG ] ; then
    echo "Untagging all apps with tag: ${FROM_TAG}"

    ocLogin

    for app in $OMAR_APPS ; do
      if [ ! -e $app ] ; then
        oc tag o2/${app}:$FROM_TAG -d
      fi
    done
  else
    echo "The FROM option must be set for untag (-f|--from)"
  fi

  exit 1
}

## Tag function
tag()
{
  echo
  echo "Tagging images"

  if [[ -n $FROM_TAG && -n $TO_TAG ]] ; then
    echo "  from: ${FROM_TAG}"
    echo "  to: ${TO_TAG}"

    ocLogin

    for app in $OMAR_APPS ; do
      if [ ! -e $app ] ; then
        oc tag o2/${app}:$FROM_TAG o2/${app}:$TO_TAG
      fi
    done
  else
    echo "Both FROM and TO flags must be set (-f|--from and -t|--to)"
  fi

  exit 1
}

ocLogin()
{
  if [[ -n $OPENSHIFT_URL && -n $OPENSHIFT_USER && -n $OPENSHIFT_PASSWORD ]] ; then
    echo
    echo "  ***"
    echo "  Logging into OpenShift"
    echo "  ***"
    echo

    oc login $OPENSHIFT_URL -u $OPENSHIFT_USER -p $OPENSHIFT_PASSWORD

  else
    echo "  OpenShift parameters need to be set!"
    printHelp
  fi
}

## Main function
main()
{
  if [ ! -e $HELP ] ; then
    printHelp
  elif [ ! -e $UNTAG ] ; then
    untag
  else
    # Help and untag were not set, we must be running a tag
    tag
  fi

  exit 1
}

## Run main
main
