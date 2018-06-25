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
# Checks if github URLs and credentials are available, prompts for creds if not.
# Checks/assigns the following globals:
#
#     GIT_PUBLIC_SERVER_URL
#     GIT_PRIVATE_SERVER_URL
#     GITHUB_USERNAME
#     GITHUB_PASSWORD

   local OSSIMLABS_URL="https://github.com/ossimlabs"
   local RADIANTBLUE_URL="https://github.com/radiantbluetechnologies"

   # Use Jenkins-provided values if available, otherwise use those provided here
   if [ -z "$GIT_PUBLIC_SERVER_URL" ]; then
      GIT_PUBLIC_SERVER_URL=$OSSIMLABS_URL
   fi
   if [ -z "$GIT_PRIVATE_SERVER_URL" ]; then
      GIT_PRIVATE_SERVER_URL=$RADIANTBLUE_URL
   fi

   # Prompt if needed, and only if interactive shell:
   if [ -t 1 ] ; then
      if [ -z "$GITHUB_USERNAME" ]; then
         read -p "Github username: " GITHUB_USERNAME
      fi
      if [ -z "$GITHUB_PASSWORD" ]; then
         read -s -p "Github password: " GITHUB_PASSWORD
         echo
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
      if [ -z "$TAG_DESCRIPTION" ]; then
         read -p "Enter description: " TAG_DESCRIPTION
      fi
   fi
   if [ -z "$RELEASE_NAME" ] || [ -z "$VERSION_TAG" ]; then
      echo; echo "ERROR: Release name or version tag must be provided. Aborting. "; echo
      exit 1
   fi
}
