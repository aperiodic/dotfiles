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

setxkbmap -model pc104 -layout us -variant dvp -option ctrl:nocaps

if [ -s ~/.xresources ]; then
  xrdb -merge ~/.xresources
fi

/usr/bin/xscreensaver -no-splash &
xbindkeys

# start clipboard manager if found
if [[ ! "$(which parcellite)" =~ "not found" ]]; then
  parcellite &
fi

# start syndaemon if found
if [[ ! "$(which syndaemon)" =~ "not found" ]]; then
  syndaemon -i 1.5 -k &
fi

xrdb -m ~/.xresources

exec xmonad
