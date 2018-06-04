#!/bin/bash
#
# Script assigns the globals
#
#     RADIANTBLUE_REPOS
#     OSSIMLABS_REPOS
#
#  Will be prompted if not provided:
#    GITHUB_USERNAME
#    GITHUB_PASSWORD

# Uncomment following line to debug script line by line:
#set -x; trap read debug

#-------------------------------------------------------------------------------------

pythonScript="
import json, sys
r = {}
r['repositories'] = json.load(sys.stdin)
for item in r['repositories']:
   print item['name']
"

#-------------------------------------------------------------------------------------

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./checkGitURLsAndCreds.sh
popd >/dev/null


rbt_repos_json=`curl -s -u $GITHUB_USERNAME:$GITHUB_PASSWORD "https://api.github.com/orgs/radiantbluetechnologies/repos?type='all',per_page=500"`
RBT_REPOS=("`echo "$rbt_repos_json" | python -c "$pythonScript"`")
echo; echo "In radiantbluetechnologies:"
for repo in $RBT_REPOS ; do
   echo "  $repo"
done

osl_repos_json=`curl -s -u $GITHUB_USERNAME:$GITHUB_PASSWORD "https://api.github.com/orgs/ossimlabs/repos?type='all',per_page=500"`
OSL_REPOS=("`echo "$osl_repos_json" | python -c "$pythonScript"`")
echo; echo "In ossimlabs:"
for repo in $OSL_REPOS ; do
   echo "  $repo"
done
echo
