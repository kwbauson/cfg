import XMonad
import System.Exit
import qualified XMonad.StackSet as W
import XMonad.Layout.TabBarDecoration
import XMonad.Util.EZConfig
import XMonad.Config.Desktop
import Data.Map (fromList)

mk k cmd = ((mod4Mask, k), cmd)
mmk m k cmd = ((mod4Mask .|. m, k), cmd)
mks k = mk k . spawn

myKeys =
  [ mks xK_t "term tmux"
  , mmk shiftMask xK_t $ spawn "term"
  , mks xK_e "term tmux new nvim"
  , mks xK_f "term tmux new ranger"
  , mks xK_w "qtbr"
  , mks xK_z "sleep 0.5 && systemctl suspend"
  , mks xK_space "sleep 0.5 && xset dpms force off"
  , mk xK_n $ windows W.focusDown
  , mmk shiftMask xK_n $ windows W.swapDown
  , mk xK_p $ windows W.focusUp
  , mmk shiftMask xK_p $ windows W.swapUp
  , mmk shiftMask xK_q $ io $ exitWith ExitSuccess
  , mks xK_r "xmonad --recompile && xmonad --restart"
  , mmk shiftMask xK_space $ sendMessage NextLayout
  ]

main = do
  spawn "xmobar"
  xmonad $ desktopConfig
    { modMask = mod4Mask
    , layoutHook = (simpleTabBar (Tall 1 (3/100) (1/2))) ||| Full
    } `additionalKeys` myKeys
