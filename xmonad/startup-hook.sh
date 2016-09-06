#!/bin/bash
#
# xmonad "startup hook" script. This gets run after xmonad is initialized,
# via the startupHook facility provided by xmonad. It's useful for
# running any programs which you want to use within xmonad but
# which don't need to be initialized before xmonad is running.

# dropbox start -i

# fixes various issues with gnome desktop
gnome-settings-daemon &

# launch xmobar
if [ -z "$(pgrep xmobar)" ] ; then
    ~/.cabal/bin/xmobar ~/.xmonad/xmobar.hs --screen 1 &
fi