#!/bin/bash
scripts=("todo.sh" "file_count.sh" "deltmp.sh" "quit")
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
    "quit")
      break
  esac
done

