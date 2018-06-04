#!/bin/bash

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
