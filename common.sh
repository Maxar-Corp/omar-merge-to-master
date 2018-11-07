#!/bin/bash

#-------------------------------------------------------------------------------------
# Runs shell command and exits on error

function runCommand {
  echo;echo "> $*"
  eval $*
  if [ $? != 0 ] ; then
    echo "ERROR: Failed while executing command: <$*>."
    echo; exit 1;
  fi
}

#-------------------------------------------------------------------------------------

function checkGitURLsAndCreds {
#
# Checks if git URLs and credentials are available, prompts for creds if not.
# Checks/assigns the following globals:
#
#     GIT_PUBLIC_SERVER_URL
#     GIT_PRIVATE_SERVER_URL

   # Low-side defaults only used if GIT URLs not provided in environment
   if [ "$WWW_CONNECTED" == "true" ]; then
      if [ -z "$GIT_PUBLIC_SERVER_URL" ]; then
         GIT_PUBLIC_SERVER_URL="git@github.com:ossimlabs"
      fi
      if [ -z "$GIT_PRIVATE_SERVER_URL" ]; then
         GIT_PRIVATE_SERVER_URL="git@github.com:Maxar-Corp"
      fi
   fi
}

#-------------------------------------------------------------------------------------

function checkReleaseInfo {
#
# Checks if release name and number are set. Prompt if needed, and only if interactive shell.
# Checks/assigns the following globals:
#
#     RELEASE_NAME
#     VERSION_TAG
#     TAG_DESCRIPTION

   if [ -t 1 ] ; then
      if [ -z "$RELEASE_NAME" ]; then
         read -p "Enter release name: " RELEASE_NAME
      fi
      if [ -z "$VERSION_TAG" ]; then
         read -p "Enter release number: " VERSION_TAG
      fi
      #if [ -z "$TAG_DESCRIPTION" ]; then
      #   read -p "Enter description: " TAG_DESCRIPTION
      #fi
   fi
   if [ -z "$RELEASE_NAME" ] || [ -z "$VERSION_TAG" ]; then
      echo; echo "ERROR: Release name or version tag must be provided. Aborting. "; echo
      exit 1
   fi
}
