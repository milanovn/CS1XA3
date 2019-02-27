#!/bin/bash
scripts=("todo.sh" "file_count.sh" "deltmp.sh" "diskspace.sh" "quit")
select opt in "${scripts[@]}"
do
  case $opt in
    "todo.sh")
      ./todo.sh
      ;;
    "file_count.sh")
      ./file_count.sh
      ;;
    "deltmp.sh")
      ./deltmp.sh
      ;;
    "diskspace.sh")
      ./diskspace.sh
      ;;
    "quit")
      break
  esac
done

