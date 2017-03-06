import Control.Exception.Extensible (bracket)
import Data.List
import Data.Time.LocalTime (getZonedTime)
import System.Environment (getEnvironment)
import System.IO (appendFile, hClose, hPutStrLn, IOMode (AppendMode), openFile)

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Config.Gnome (gnomeRun)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks (manageDocks)
import XMonad.Layout
import XMonad.Layout.Accordion
import XMonad.Layout.Circle
import XMonad.Layout.Fullscreen
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.TwoPane  -- consider using DragPane instead
import XMonad.Util.EZConfig
import XMonad.Util.Run (safeSpawn)

import qualified XMonad.Actions.OnScreen as OS
import qualified XMonad.Actions.Plane as P
import qualified XMonad.Actions.Volume as Vol
import qualified XMonad.Hooks.EwmhDesktops as Ewmh
import qualified XMonad.Hooks.ManageDocks as MD
import qualified XMonad.Layout.Spacing as LS
import qualified XMonad.Layout.Spiral as SP
import qualified XMonad.StackSet as W

columns = 10
rows = 4
myWorkspaces = map show [1..(columns * rows)]

-- | Set each screen to the respective workspaceId by index. Applies actions
-- left-to-right so that the left screen is focused by default.
setWorkspaces :: [WorkspaceId] -> X ()
setWorkspaces workspaceIds =
    foldl1 (>>) . map windows . map (uncurry OS.viewOnScreen) $ ids
    where ids = reverse $ zip [0..] workspaceIds

-- | Get list of visible (on screen) workspaces.
visibleWorkspaces :: X [WorkspaceId]
visibleWorkspaces = do
    ws <- gets windowset
    return . map (W.tag . W.workspace) $ W.current ws : W.visible ws

-- | Get the workspace delta places away from the given workspace.
incWorkspaceBy :: Int -> WorkspaceId -> WorkspaceId
incWorkspaceBy delta wid = targetWid
    where delta' = ((length myWorkspaces) + delta) `mod` (length myWorkspaces)
          workspaces = cycle myWorkspaces
          targetWid = case find ((==wid) . fst) $ zip workspaces (drop delta' $ workspaces) of
                           Just (_, twid) -> twid
                           Nothing -> wid

-- | Shift delta workspaces over on each screen.
shiftScreensRightBy :: Int -> X ()
shiftScreensRightBy delta = do
    curWorkspaces <- visibleWorkspaces
    setWorkspaces . map (incWorkspaceBy delta) . sort $ curWorkspaces

-- | Shift delta workspaces over on each screen.
shiftScreensDownBy :: Int -> X ()
shiftScreensDownBy delta = shiftScreensRightBy (delta * columns)

myKeys =
       -- windows
       [ ("M-S-w", kill)
       , ("M-<Space>", sendMessage NextLayout)
       , ("M-S-<Space>", sendMessage FirstLayout)
       , ("M-<Tab>", windows W.focusDown)
       , ("M-S-<Tab>", windows W.focusUp)
       , ("M-j", windows W.focusDown)
       , ("M-k", windows W.focusUp)
       , ("M-S-j", windows W.swapDown)
       , ("M-S-k", windows W.swapUp)

       -- screens
       , ("M-a", nextScreen)
       , ("M-S-a", shiftNextScreen >> nextScreen)

       -- workspaces
       , ("M-`", toggleWS)
       -- TODO: consider moving arrows keys to ijkl, -= to uo, jk to ,.
       -- .. by row
       , ("M-<Left>", prevWS)
       , ("M-<Right>", nextWS)
       , ("M-S-<Left>", shiftToPrev >> prevWS)
       , ("M-S-<Right>", shiftToNext >> nextWS)
       , ("M-C-<Left>", shiftScreensRightBy (-2))
       , ("M-C-<Right>", shiftScreensRightBy 2)
       -- .. by column
       , ("M-<Up>", columnMove P.ToUp)
       , ("M-<Down>", columnMove P.ToDown)
       , ("M-S-<Up>", columnShift P.ToUp)
       , ("M-S-<Down>", columnShift P.ToDown)
       , ("M-C-<Up>", shiftScreensDownBy (-1))
       , ("M-C-<Down>", shiftScreensDownBy 1)

       -- applications
       , ("M-f c", spawn "google-chrome-stable")
       , ("M-f e", spawn "emacs -nw")
       , ("M-f s", spawn "sublime-text --new-window")
       , ("M-f h", spawn "slack")

       -- commands
       , ("M-<F10>", Vol.setMute False >> Vol.lowerVolume 4 >> return ())
       , ("M-<F11>", Vol.setMute False >> Vol.raiseVolume 4 >> return ())
       , ("M-<F12>", spawn "gnome-screensaver-command -l")  -- lock screen
       , ("M-s", sendMessage MD.ToggleStruts) -- toggle xmobar visibility
       ]
       where
          columnMove = P.planeMove (P.Lines rows) P.Finite
          columnShift = P.planeShift (P.Lines rows) P.Finite

-- fullscreenEventHook is a requirement for ewmh
myHandleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook <+> MD.docksEventHook

myLayout =
    MD.avoidStruts $ -- correct for xmobar dock
    --LS.smartSpacing 5 $
    (splitTile ||| squareTile ||| Full)
    where
        splitTile = Tall 1 (1/20) (1/2)
        squareTile = Tall 1 (1/20) (768/1028)
-- other options: Circle ||| Accordion ||| Mirror tiled ||| TwoPane 0 (1/2)  ||| SP.spiral (768/1028)

myLogHook = fadeInactiveLogHook 0.8
myManageHook = manageHook defaultConfig <+> manageDocks

gnomeConfig2 = desktopConfig
    { terminal = "gnome-terminal"
    , startupHook = gnomeRegister >> startupHook desktopConfig }

-- | Register xmonad with gnome.
gnomeRegister :: MonadIO m => m ()
gnomeRegister = io $ do
    x <- lookup "DESKTOP_AUTOSTART_ID" `fmap` getEnvironment
    whenJust x $ \sessionId -> safeSpawn "dbus-send"
            [ "--session"
            , "--print-reply=literal"
            , "--dest=org.gnome.SessionManager"
            , "/org/gnome/SessionManager"
            , "org.gnome.SessionManager.RegisterClient"
            , "string:xmonad"
            , "string:" ++ sessionId]

-- ewmh is a work-around for some applications (like LibreOffice) that try to
-- do their own window positioning (and get it wrong).
-- see: https://code.google.com/p/xmonad/issues/detail?id=200#c15
main = xmonad $ Ewmh.ewmh gnomeConfig2
       { modMask = mod4Mask  -- "super"
       , handleEventHook = myHandleEventHook
       , layoutHook = myLayout
       --, logHook = myLogHook
       , manageHook = myManageHook
       , borderWidth = 3
       , normalBorderColor = "#666666"
       , focusedBorderColor = "#ffffff"
       , startupHook = spawn "~/.xmonad/startup-hook.sh"
       , workspaces = myWorkspaces
       } `additionalKeysP` myKeys
