#!/bin/bash

function safe_install {
  if [ -f ~/$1 ] || [ -L ~/$1 ] || [ -d ~/$1 ]; then
    if [ -f ~/$1.bkp ] || [ -L ~/$1.bkp ] || [ -d ~/$1.bkp ]; then
     echo "~/$1 and ~/$1.bkp both exist, doing nothing" 1>&2
     echo "You can restore from the bkp files by running restore.sh" 1>&2
     return
   else
     echo "~/$1 already exists, moving to ~/$1.bkp" 1>&2
     mv ~/$1 ~/$1.bkp
   fi
 fi
 ln -s $(pwd)/$1 ~/$1
 if [ $? -eq 0 ]; then
   echo "Installed $1"
 fi
}

set -e

git submodule init
git submodule update

if [ $# -eq 0 ]; then
  safe_install .gitignore
  safe_install .inputrc
  safe_install .lein
  safe_install .tmux.conf
  safe_install .vim
  safe_install .vimrc
  safe_install .xinitrc
  safe_install .xmodmap
  safe_install .xresources
  safe_install .zshrc
else
  for f in $@; do
    safe_install $f
  done
fi
