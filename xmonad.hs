-- import System.Taffybar.Hooks.PagerHints (pagerHints)
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ZoomRow
import XMonad.Util.Cursor
import XMonad.Util.EZConfig
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import qualified Data.List 	 as L
import qualified Data.Map        as M
import qualified XMonad.StackSet as W


myLauncher = "rofi -show run"
myRootLauncher = "sudo rofi -show run"
mySwitcher = "rofi -show window"
myTerminal = "konsole"
mySelectScreenshot = "screenshot-tool"

myWorkspaces = ["1: term","2: web","3: research","4: media"] ++ map show [5..9]


myManageHook = composeAll
    [
        className =? "firefox"  --> doShift "2:web"
      , className =? "virt-manager"  --> doShift "3:research"
      , className =? "zoom"     --> doFloat
      , className =? "screenshot-tool"     --> doFloat
--      , role =? "pop-up" 	--> doFloat
      , isFullscreen            --> (doF W.focusDown <+> doFullFloat)
    ]

-- XMobar
xmobarTitleColor = "#C678DD"
xmobarCurrentWorkspaceColor = "#51AFEF"

-- Keys
myModMask = mod4Mask
altMask = mod1Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ -- Daily drivers
    ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
  , ((modMask .|. shiftMask, xK_q), kill)
  , ((modMask, xK_b), sendMessage ToggleStruts)
  , ((modMask, xK_f), sendMessage $ Toggle FULL)
  , ((modMask .|. shiftMask, xK_space), withFocused $ windows . W.sink) -- Sink a floating window back into tiling
  , ((modMask, xK_p), spawn myLauncher)
  , ((modMask, xK_P), spawn myRootLauncher)
  , ((modMask, xK_Tab), spawn mySwitcher)
  , ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")
-- Todo; xbacklight -inc 10
  ]
  ++

  [ -- Workspaces
    ((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]
  ++

  [ -- Physical Screens
     ((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
       | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
       , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]


myStartupHook = do
  setWMName "LG3D"
  spawn     "bash ~/.xmonad/startup.sh"
  setDefaultCursor xC_left_ptr


main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc.hs"
  xmonad $ docks
         -- $ withNavigation2DConfig myNav2DConf
         $ additionalNav2DKeys (xK_Up, xK_Left, xK_Down, xK_Right)
         [
           (mod4Mask,               windowGo  )
             , (mod4Mask .|. shiftMask, windowSwap)
         ] False
         $ ewmh
         $ defaults {
           logHook = dynamicLogWithPP xmobarPP {
                     ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
                   , ppTitle = xmobarColor xmobarTitleColor "" . shorten 50
                   , ppSep = "   "
                   , ppOutput = hPutStrLn xmproc
            } >> updatePointer (0.75, 0.75) (0.75, 0.75)
         }

defaults = def {
    -- simple stuff
    terminal           = myTerminal,
    -- focusFollowsMouse  = myFocusFollowsMouse,
    -- borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    -- normalBorderColor  = myNormalBorderColor,
    -- focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    -- mouseBindings      = myMouseBindings,

    -- hooks, layouts
    -- layoutHook         = myLayout,
    layoutHook         = avoidStruts $ layoutHook def,
    -- handleEventHook    = E.fullscreenEventHook,
    handleEventHook    = fullscreenEventHook,
    manageHook         = manageDocks <+> myManageHook,
    startupHook        = myStartupHook
}

-- https://github.com/randomthought/xmonad-config/blob/master/xmonad.hs
