#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
. ./O2-Repo-List.sh
popd >/dev/null


if [ -e branches.txt ] ; then
    rm branches.txt
fi

for repo in $MAXAR_CORP_REPOS ; do
  if [ -e $repo ] ; then
    cd $repo
    git for-each-ref --format="%(authorname) %09 $repo %09 %(refname) %09 %(committerdate)" | grep remotes | grep -v origin/HEAD | grep -v origin/dev | grep -v origin/master >> ../branches.txt
    cd ..
  fi
done

for repo in $OSSIMLABS_REPOS ; do
  if [ -e $repo ] ; then
      cd $repo
      git for-each-ref --format="%(authorname) %09 $repo %09 %(refname) %09 %(committerdate)" | grep remotes | grep -v origin/HEAD | grep -v origin/dev | grep -v origin/master >> ../branches.txt >> ../branches.txt
      cd ..
  fi
done

cat branches.txt | sort -f > branches_sorted.txt
rm branches.txt
