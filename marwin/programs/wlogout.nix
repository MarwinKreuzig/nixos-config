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
      scriptName = "logout";
      wlogoutScript =
        (pkgs.writeScriptBin scriptName "wlogout -b 2");
    in
    [
      wlogoutScript
      (pkgs.makeDesktopItem {
        name = "wlogout";
        desktopName = "wlogout";
        exec = "${wlogoutScript}/bin/${scriptName}";
        terminal = true;
      })
    ];
}
