{ lib, config, ... }:
{
  config = lib.mkIf (config.home.hyprland.enable && config.home.hyprland.setup == "desktop") {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "DP-1,1920x1080@144,0x0,1, vrr,1"
        "HDMI-A-1,1920x1080@74.97300,-1920x0,1"
      ];
      workspace = [
        "1, monitor:DP-1, default:true"
        "name:second, monitor:HDMI-A-1, default:true"
      ];
      bind = [
        "\$mod,U,focusmonitor,DP-1"
        "\$mod,O,focusmonitor,HDMI-A-1"
      ];
    };
  };
}

