#!/bin/bash

the_git_repo=$1

echo "Mining source repo <$the_git_repo>"

cd $the_git_repo

number_of_files=`git ls-tree -r --name-only HEAD | wc -l`

all_counts=`git log --name-status | grep -Ei "^[MA]\s+" | sort | uniq -c | sort -h | sed 's/^ *//g' | grep -Eo ^[0-9]+`
csv=`echo "$all_counts" | tr '\n' ','`
branch=`git branch`
csv_file_name="csv/".$the_git_repo."_"_.`git branch`.".csv"
echo $csv_file_name
# echo "There are <$number_of_files> files in total."
