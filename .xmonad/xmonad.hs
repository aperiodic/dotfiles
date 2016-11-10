import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (docks, docksEventHook, ToggleStruts (ToggleStruts) )
import XMonad.Hooks.SetWMName
import XMonad.Layout.LayoutHints
import qualified XMonad.Layout.LimitWindows as Limit
import qualified XMonad.Layout.VarialColumn as VC
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Move focus
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap windows
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- move right edge of column left or right (or left edge if last column)
    , ((modm,               xK_h     ), withFocused $ \w -> sendMessage $ VC.Embiggen (-dw) 0 w)
    , ((modm,               xK_l     ), withFocused $ \w -> sendMessage $ VC.Embiggen dw 0 w)

    -- move bottom edge of window up or down (or top edge if last window in column)
    , ((modm,               xK_t     ), withFocused $ \w -> sendMessage $ VC.Embiggen 0 dw w)
    , ((modm,               xK_n     ), withFocused $ \w -> sendMessage $ VC.Embiggen 0 (-dw) w)

    -- move windows to prev/next positions (both within and to new columns)
    , ((modm              , xK_comma), withFocused $ \w -> sendMessage $ VC.UpOrLeft w)
    , ((modm              , xK_period), withFocused $ \w -> sendMessage $ VC.DownOrRight w)

    -- balance heights of windows in current column to be equal
    , ((modm              , xK_b), withFocused $ \w -> sendMessage $ VC.EqualizeColumn 1 w)

    -- Return window to tiling (previously M-t)
    , ((modm,               xK_r     ), withFocused $ windows . W.sink)

    -- Toggle the status bar gap
    , ((modm              , xK_s     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_asterisk, xK_parenleft, xK_parenright
                                                 ,xK_braceright, xK_plus, xK_braceleft
                                                 ,xK_bracketright, xK_bracketleft, xK_exclam
                                                 ,xK_equal]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_o, xK_e, xK_u] [2,0,1]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  where
    dw = 0.02

------------------------------------------------------------------------
-- Mouse bindings
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- move windows around to prev/next positions (both within and to new columns)
    , ((modm, button4), \w -> sendMessage $ VC.Embiggen (-dw) 0 w)
    , ((modm, button5), \w -> sendMessage $ VC.Embiggen dw 0 w)
    ]
  where
    dw = 0.005

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
bypassSomeApps = composeAll
    [ className =? "MPlayer"          --> doFloat
    , className =? "Gimp"             --> doFloat
    , className =? "hl_linux"         --> doFloat
    , className =? "streaming_client" --> doFloat
    , resource  =? "desktop_window"   --> doIgnore
    , resource  =? "kdesktop"         --> doIgnore ]

------------------------------------------------------------------------
-- Xmobar
--
-- Configure the workspaces pretty printer
--
myPP = xmobarPP { ppCurrent = xmobarColor "#fdf6e3" "" . wrap "[" "]"
                , ppLayout  = (\x -> case x of
                                          "Varial Columns"         -> "|+"
                                          "First 2 Varial Columns" -> "||"
                                          "Full"                   -> "[]"
                                          _ -> x
                                          )
                }

------------------------------------------------------------------------
-- Main
--
main :: IO ()
main = do
  h <- spawnPipe "xmobar"
  xmonad $
    docks
    desktopConfig
    {
    -- properties
      terminal           = "xfce4-terminal --hide-menubar"
    , focusFollowsMouse  = True
    , clickJustFocuses   = False
    , borderWidth        = 1
    , modMask            = mod1Mask
    , workspaces         = map show [0..9]
    , normalBorderColor  = "#333333"
    , focusedBorderColor = "#cb4b16"

    -- key & mouse bindings
    , keys               = myKeys
    , mouseBindings      = myMouseBindings

    -- behavorial costumization
    , layoutHook         = desktopLayoutModifiers $ tiled ||| twocol ||| Full
    , manageHook         = bypassSomeApps
    , handleEventHook    = hintsEventHook <+> fullscreenEventHook <+> docksEventHook
    , logHook            = dynamicLogWithPP $ myPP { ppOutput = hPutStrLn h }
    , startupHook        = setWMName "LG3D"
  }
  where
    tiled = VC.varial
    twocol = Limit.limitWindows 2 $ VC.varial
