#!/bin/bash

function restore {
  if [[ ! -e ~/$1.bkp ]]; then
    echo "No ~/$1.bkp file to revert from, skipping ~/$1"
  else
    mv ~/$1.bkp ~/$1
    echo "Reverted $1"
  fi
}

echo "All files installed by install.sh will be restored from their backups, if"
echo "possible. Any files without a backup will not be modified"
printf "Continue? [y/n]: "
read confirm

if [[ ! $confirm =~ "y" ]]; then
  exit 1
fi

set -e

if [ $# -eq 0 ]; then
  restore .bashrc
  restore .zshrc
  restore .inputrc
  restore .tmux.conf

  restore .vim
  restore .vimrc
else
  for f in $@; do
    restore $f
  done
fi
