#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -s ~/.xmodmap ]; then
  xmodmap ~/.xmodmap
fi

if [ -s ~/.xresources ]; then
  xrdb -merge ~/.xresources
fi

# this synchronizes the clipboard and primary selections
/usr/bin/autocutsel -fork &
/usr/bin/autocutsel -selection PRIMARY -fork &

/usr/bin/xscreensaver -no-splash &

exec xmonad