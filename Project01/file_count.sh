#!/bin/bash
cd ~/CS1XA3/
Html=$(find . -name '*.html' | wc -l)
JS=$(find . -name '*.js' | wc -l)
CSS=$(find . -name '*.css' | wc -l)
Py=$(find . -name '*.py' | wc -l)
Hs=$(find . -name '*.hs' | wc -l)
Bash=$(find . -name '*.sh' | wc -l)

echo HTML: $Html, Javascript: $JS, CSS: $CSS, Python: $Py, Haskell: $Hs, Bash: $Bash
read -p "Which file extensions would you like to see? [html, js, css, py, hs, sh] " user_input
function_files (){
  if [ $1 == 'html' ]; then
    find . -name '*html'
  fi
  if [ $1 == 'js' ]; then
    find . -name '*.js'
  fi
  if [ $1 == 'css' ]; then
    find . -name '*.css'
  fi
  if [ $1 == 'py' ]; then
    find . -name '*.py'
  fi
  if [ $1 == 'hs' ]; then
    find . -name '*.hs'
  fi
  if [ $1 == 'sh' ]; then
    find . -name '*.sh'
  fi
}
if [ -z "$user_input" ]; then
  exit
else
  printf "%s0" $user_input | while IFS= read -d $'0' arr
  do
    function_files $arr
  done
fi
