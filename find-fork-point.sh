#!/bin/bash

if test "$#" -ne 2; then
  echo "illegal number of parameters"
  echo "Usage: "
  echo "   find-fork-point <range of commits> <commit reference>"
  echo "Examples: "
  echo "   find-fork-point 1cb1d..e172 d67e"
  echo "   find-fork-point master~10..master 27c235cecee2"
  exit 1
fi

commit_range=$1
commit_to_compare_with=$2

list_of_commits=($(git rev-list $commit_range))
num_of_commits=${#list_of_commits[@]}
minimal_diff_count=100000000

if test $num_of_commits -eq 0; then
  echo
  echo Error: Did not find any commits in the range $commit_range
  echo
  exit 1
fi

echo
echo Info: Found $num_of_commits commits in the range $commit_range
echo

count_lines_of_diff() { git diff $1 $2 | wc -l; }

for c in "${list_of_commits[@]}"
do
  diff_count=$(count_lines_of_diff $commit_to_compare_with $c)
  echo ${c:0:4} differs from ${commit_to_compare_with:0:4} by $diff_count lines
  if [ $diff_count -lt $minimal_diff_count ]
  then
    most_similar_commit=$c
    minimal_diff_count=$diff_count
  fi
done

echo
echo Most similar commit to $commit_to_compare_with is $most_similar_commit
