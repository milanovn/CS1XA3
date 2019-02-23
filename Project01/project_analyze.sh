#!/bin/bash
read -p "Do you wish to execute todo.sh or file_count.sh? (Enter file name) " choice
if [ $choice == 'todo.sh' ]; then
  ./todo.sh
fi
if [ $choice == 'file_count.sh' ]; then
  ./file_count.sh
fi
if [ $choice == 'deltmp.sh' ]; then
  ./deltmp.sh
fi
