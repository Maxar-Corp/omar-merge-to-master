#!/bin/bash
if [ -z $GITHUB_USERNAME ] ; then
   echo -n "Please enter github username: "
   read GITHUB_USERNAME
fi

if [ -z $GITHUB_PASSWORD ] ; then
   echo -n "Please enter github password: "
   read -s GITHUB_PASSWORD
fi
