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
      makeScript = { name, desktopName, content }: (pkgs.makeDesktopItem {
        inherit name desktopName;
        exec = "${pkgs.writeScriptBin name content}/bin/${name}";
        terminal = true;
      });
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
      (makeScript { name = "suspend"; desktopName = "Suspend"; content = "systemctl suspend"; })
      (makeScript { name = "poweroff"; desktopName = "Poweroff"; content = "systemctl poweroff"; })
      (makeScript { name = "reboot"; desktopName = "Reboot"; content = "systemctl reboot"; })
      (makeScript { name = "hibernate"; desktopName = "Hibernate"; content = "systemctl hibernate"; })
    ];
}
