#!/bin/bash

commit_to_compare_with=d67e
commit_range=1cb1d..e172

list_of_commits=($(git rev-list $commit_range))
num_of_commits=${#list_of_commits[@]}
minimal_diff_count=100000000

echo
echo Found $num_of_commits commits in the range $commit_range
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