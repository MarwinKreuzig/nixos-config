{ de-config, ... }:
if de-config == "laptop0" then {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080, 0x0, 1.25"
    ];

    misc = {
      vfr = true;
    };

    exec-once = [
      "nm-applet"
    ];
  };
} else { }
