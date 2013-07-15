import XMonad
import XMonad.Hooks.EwmhDesktops

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myTerminal = "urxvt"
myFocusFollowsMouse = True
myBorderWidth = 1
myModMask = mod4Mask


myWorkspaces = ["(", ")", "}", "+", "{", "]", "[", "!", "="]

myNormalBorderColor = "#888888"
myFocusedBorderColor = "#ff3333"


main = xmonad defaults
  where
    defaults = defaultConfig {
      terminal           = myTerminal,
      focusFollowsMouse  = myFocusFollowsMouse,
      borderWidth        = myBorderWidth,
      modMask            = myModMask,
      workspaces         = myWorkspaces,
      normalBorderColor  = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor
    }
