#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

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

# start clipboard manager if found
if [[ ! "$(which parcellite)" =~ "not found" ]]; then
  parcellite &
fi

exec xmonad
