#!/bin/bash

function revert_or_rm {
  if [[ -e ~/$1.bkp ]]; then
    mv ~/$1.bkp ~/$1
    echo "Reverted $1"
  else
    if [ $NUKE ]; then
      rm ~/$1
      echo "Deleted ~/$1"
    else
      ls -lh ~/$1
      printf "Delete '~/$1'? [y/n]: "
      read _del_confirm
      if [[ $_del_confirm -eq "y" ]]; then
        rm ~/$1
      fi
      # this might not be necessary; i don't really know bash variable scoping
      unset _del_confirm
    fi
  fi
}

ARG_COUNT=$#

while getopts "y" opt; do
  case "$opt" in
    y) NUKE=true; ARG_COUNT=$((ARG_COUNT - 1));;
    ?) echo "unrecognized option '$opt'!"; exit 1;;
  esac
done

if [ $NUKE ]; then
  echo "I say we take off and nuke the entire site from orbit."
  echo "    - Ellen Ripley"
fi

if [ ! $NUKE ]; then
  echo "All files installed by install.sh will be either restored from backups or"
  echo "removed. You will have a chance to review any files without a backup and elect"
  echo "to preserve them. To skip this process and automatically delete files without"
  echo "backups, rerun this script and pass the '-y' flag."
  printf "Continue? [y/n]: "
  read confirm
fi

if [[ ! $confirm -eq "y" && ! $NUKE ]]; then
  exit 1
fi

set -e

if [ $ARG_COUNT -eq 0 ]; then
  revert_or_rm .gitconfig
  revert_or_rm .gitignore
  revert_or_rm .inputrc
  revert_or_rm .lein
  revert_or_rm .tmux.conf
  revert_or_rm .vim
  revert_or_rm .vimrc
  revert_or_rm .xbindkeysrc
  revert_or_rm .xinitrc
  revert_or_rm .xmodmap
  revert_or_rm .xresources
  revert_or_rm .zshrc
else
  for f in $@; do
    revert_or_rm $f
  done
fi
