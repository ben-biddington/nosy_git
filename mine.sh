#!/bin/bash

the_git_repo=$1

echo "Mining source repo <$the_git_repo>"

cd $the_git_repo

count=`git log --name-status | grep -Ei "^[MA]\s+" | sort | uniq -c | sort -h`

echo "There are <$count> files in the <$the_git_repo> repository"  