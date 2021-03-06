#!/bin/bash
current=$HOME/CS1XA3/public_html
cd $HOME
>$current/variable.js
other=0
for folder in $(ls -a)
do
  if [ -d ]; then
    if [[ $folder == \.* ]]; then
      if [[ $folder != \.\. && $folder != \. ]]; then
        hiddenSize=$(du -sm $folder | cut -f 1)
        other=$(( $hiddenSize + $other))
      fi
    else
  	   file=$(du -sm $folder)
       filesize=$(echo $file | cut -f 1 -d ' ')
       filename=$(echo $file | cut -f 2 -d ' ')
       #echo var $filename = $filesize >> $current/size.txt
       arrData+=$(echo -n $filesize,)
       arrLabel+=$(echo -n \"$filename\",)
    fi
  fi
done
  echo var graphData = [$arrData$other] >> $current/variable.js
  echo var graphLabel = [$arrLabel\"Hidden Files\"] >> $current/variable.js
  echo View your results at "<https://mac1xa3.ca/u/milanovn/>" !!
