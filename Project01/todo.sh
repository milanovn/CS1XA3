#!/bin/bash
#Want to append lines that contain #TODO in a file called todo.log
#Find all files, next we want to output the cat into a grep that looks for the tag #TODO and output the whole line
>todo.log
find . -name '*' -type f -print0 | while IFS= read -d $'\0' file
do
  if [ $file != $0 ] && [ $file != './todo.log' ]; then
    grep '#TODO' $file >> todo.log
  fi
done
