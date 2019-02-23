#!/bin/bash
IFS='$\n'
for file in $(git ls-files . --exclude-standard --others | grep '\.tmp')
do
  echo $file
  git clean -f "$file"
done
IFS=

