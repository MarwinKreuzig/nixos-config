#!/usr/bin/env bash
# until ping -c1 google.com; do sleep 1; done;
/etc/profiles/per-user/marwin/bin/firefox --name "ff_secondary" - P Secondary &
/etc/profiles/per-user/marwin/bin/firefox --name "ff_ttrpg" - P TTRPG &
/etc/profiles/per-user/marwin/bin/firefox --name "ff_coding" - P Coding &
/etc/profiles/per-user/marwin/bin/firefox --name "ff_university" - P University &
