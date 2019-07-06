import XMonad
import XMonad.Config.Azerty

import XMonad.Hooks.EwmhDesktops
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    spawnPipe "xscreensaver"
    xmproc <- spawnPipe "xmobar"

    xmonad $ ewmh $ fullscreenSupport $ azertyConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , terminal = "alacritty"
        , layoutHook = avoidStruts $ noBorders $ layoutHook 
defaultConfig
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") -- ;xset dpms force off
        , ((mod4Mask,               xK_a), spawn "rofi -combi-modi window,drun,run -show combi")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((mod4Mask, xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1")
        , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume 0 +3%")
        , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume 0 -3%")
        , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask .|. shiftMask, xK_f), sendMessage ToggleStruts)
        ]
