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


# FUNCTION: do_git <repo_name> <cmd_line_arg_1> <cmd_line_arg_2> <cmd_line_arg_3> <cmd_line_arg_4>
function do_git {
  if [ -d $1 ]; then
    echo; 
    echo "*************************** $(basename $1) ***************************"
    echo "*************************** git $2 $3 $4 $5 $6 $7 $8 $9***************************"

    pushd $1 > /dev/null
    git $2 $3 $4 $5 $6 $7 $8 $9
    popd > /dev/null
    echo; 
  fi
}
export -f do_git

# FUNCTION: usage <script_basename> 
function usage {
  echo; echo "Runs specified git command across all ossimlabs repositories. Usage:"
  echo; echo "  $1 <git-arg1> [<git-arg2> [<git-arg3>]]"
  echo; echo "This script must be run from the ossimlabs parent directory."
  echo; echo "Examples:"; echo 
  echo "  $1 status"
  echo "  $1 log --oneline --graph"; echo  
  exit 0
}

# Check for incorrect usage:
#if [ -z $1 ]; then
#  usage `basename "$0"`
#fi
#export FILES=`find . -maxdepth 1 -type d -name "ossim*"`
# Loop over all ossim repos in working dir:
#do_git {} $*" \;

export FILES=("cucumber-oc2s o2-paas omar ossim ossim-ci ossim-gui ossim-oms ossim-planet ossim-plugins ossim-private\
 ossim-vagrant ossim-video ossim-wms")

for file in $FILES ; do
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
done

# Check OMAR as well...
#if [ -d omar ]; then
#  bash -c "do_git omar $*"
#fi

#if [ -d o2-paas ]; then
#  bash -c "do_git o2-paas $*"
#fi


