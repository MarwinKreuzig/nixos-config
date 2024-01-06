{ de-config, ... }:
if de-config == "desktop" then {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1,1920x1080@144,1920x0,1"
      "HDMI-A-1,1920x1080@74.97300,0x0,1"
    ];
    workspace = [
      "name:secondary,monitor:HDMI-A-1"
      "name:TTRPG,monitor:DP-1"
      "name:coding,monitor:DP-1"
      "name:university,monitor:DP-1"
    ];
    windowrulev2 = [
      "workspace name:secondary silent,class:^(ff_secondary)\$"
      "workspace name:TTRPG silent,class:^(ff_ttrpg)\$"
      "workspace name:coding silent,class:^(ff_coding)\$"
      "workspace name:university silent,class:^(ff_university)\$"
    ];
    bind = [
      "\$mod,U,focusmonitor,DP-1"
      "\$mod,O,focuswindow,ff_secondary"
      "\$mod,code:25,focuswindow,discord"
    ];
    exec-once = [ "sh ${./ff-start.sh}" ];
  };
} else { }

