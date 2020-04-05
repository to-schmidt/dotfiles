import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as XS
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run(spawnPipe, safeSpawn)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Layout.Magnifier
import XMonad.Layout.Grid
import XMonad.Layout.WindowArranger
import XMonad.Layout.Spacing
import XMonad.Layout.Circle
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Hooks.FadeInactive
import qualified XMonad.StackSet as W

import System.IO
import qualified Data.Map.Strict as M
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)

myLayoutHook = (avoidStruts $ gaps [(U,10),(L,10),(R,10),(D,10)] $  spacing 10 $ (layout_tiled ||| layout_spiral ||| layout_grid ||| layout_full))
  where
    layout_tiled = Tall 1 (5/100) (1/2)
    layout_grid = Grid
    layout_spiral = spiral (6 / 7)
    layout_full = Full

myModMask = mod4Mask
myTerminal = "terminator"

myManageHook = composeAll [className =? "Kodi" --> doFloat]

myForegroundColor = "#002A35"
myFocusedColor = "#6C6FC3"
myBorderWidth = 0

polybarLogHook = def
    { ppOutput = polybarOutput
    , ppCurrent = wrap "%{F#aaff77}" "%{F-}"
    , ppVisible = wrap "" ""
    , ppUrgent = wrap "%{F#ff5555}" "%{F-}"
    , ppHidden = wrap "%{F#66}" "%{F-}"
    , ppWsSep = "  "
    , ppSep = "    "
    , ppTitle = \_ -> ""
    }

myStartupHook = do
    spawn "$HOME/.config/polybar/launch.sh"
    spawn "feh --bg-fill $HOME/.wallpaper"

polybarOutput str = do
  io $ appendFile "/tmp/.xmonad-info" (str ++ "\n")

main = do
  safeSpawn "mkfifo" ["/tmp/.xmonad-info"]

  xmonad $ ewmh
    defaultConfig
      { modMask = myModMask
      , terminal = myTerminal
      , normalBorderColor = myForegroundColor
      , focusedBorderColor = myFocusedColor
      , borderWidth = myBorderWidth
      , manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig
      , layoutHook = myLayoutHook
      , handleEventHook =
          ewmhDesktopsEventHook <+>
          handleEventHook defaultConfig <+> docksEventHook
      , logHook = fadeInactiveLogHook 0.9 <+> (dynamicLogWithPP polybarLogHook)
      , startupHook = myStartupHook <+> ewmhDesktopsStartup >> setWMName "LG3D"
      , workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
      } `additionalKeys`
    [ ((myModMask, xK_t), spawn myTerminal)
    , ((myModMask, xK_d), spawn "rofi -show run")
    , ((myModMask, xK_c), kill)
    , ((myModMask, xK_f), spawn "chromium")
    , ((myModMask, xK_n), spawn "thunar")
    , ((myModMask, xK_k), spawn "~/.bin/toggle-layout")
    , ((0, 0x1008FF11), spawn "amixer set Master 2%-")
    , ((0, 0x1008FF13), spawn "amixer set Master 2%+")
    , ((0, 0x1008FF12), spawn "amixer set Master toggle")
    , ((0, 0x1008FF02), spawn "light -A 10")
    , ((0, 0x1008FF03), spawn "light -U 10")
    , ((myModMask, xK_m), spawn "thunderbird")
    , ( (myModMask, xK_l)
      , spawn
          "xset dpms 10 && alock -bg shade -i frame:width=1 && xset dpms 600")
    , ( (myModMask, xK_x)
      , do sendMessage ToggleGaps
           toggleScreenSpacingEnabled
           toggleWindowSpacingEnabled
           sendMessage Toggle
           refresh)
    , ( (myModMask .|. shiftMask, xK_x)
      , do sendMessage ToggleStruts
           refresh)
    , ((myModMask, xK_v), withFocused $ windows . W.sink)
    , ((myModMask, xK_Left), sendMessage Shrink)
    , ((myModMask, xK_Right), sendMessage Expand)
    ]
