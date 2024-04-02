#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:rounding 0; \
        keyword decoration:active_opacity 1.0; \
        keyword decoration:inactive_opacity 1.0;"
    exit
fi
hyprctl reload
