#!/bin/bash

function safe_install {
  src=$1
  if [ -n "$2" ]; then
    dest=$2
  else
    dest=$src
  fi


  if [ -f ~/$dest ] || [ -L ~/$dest ] || [ -d ~/$dest ]; then
    if [ -f ~/$dest.bkp ] || [ -L ~/$dest.bkp ] || [ -d ~/$dest.bkp ]; then
     echo "~/$dest and ~/$dest.bkp both exist, doing nothing" 1>&2
     echo "You can restore from the bkp files by running uninstall.sh" 1>&2
     return
   else
     echo "~/$dest already exists, moving to ~/$dest.bkp" 1>&2
     mv ~/$dest ~/$dest.bkp
   fi
 fi
 ln -s $(pwd)/$src ~/$dest
 if [ $? -eq 0 ]; then
   if [[ "$src" == "$dest" ]]; then
     echo "Installed $src"
   else
     echo "Installed $src as $dest"
   fi
 fi
}

set -e

git submodule update --init --recursive

if [ $# -eq 0 ]; then
  safe_install .ctags
  safe_install .gitconfig
  safe_install .gitignore
  safe_install .i3
  safe_install .inputrc
  safe_install .lein
  safe_install .tmux.conf
  safe_install .vim
  safe_install .vimrc
  safe_install .xbindkeysrc
  safe_install .xinitrc
  safe_install .xmodmap
  safe_install .xresources
  safe_install .zshrc
  safe_install zsh-plugins .zsh-plugins
else
  for f in $@; do
    safe_install $f
  done
fi
