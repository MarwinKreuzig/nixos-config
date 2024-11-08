{ pkgs, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "";
      }
    ];
  };
  home.packages =
    let
      logoutScriptName = "logout";
      wlogoutScript =
        (pkgs.writeScriptBin logoutScriptName "wlogout -b 2");
    in
    [
      pkgs.swaylock-effects
      wlogoutScript
      (pkgs.makeDesktopItem {
        name = "wlogout";
        desktopName = "wlogout";
        exec = "${wlogoutScript}/bin/${logoutScriptName}";
        terminal = true;
      })
    ];
}
