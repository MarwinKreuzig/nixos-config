{ config, inputs, ... }:
{
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];
  programs.ironbar = {
    enable = false;
    config = {
      position = "top";
      height = 20;
      start = [
        {
          type = "workspaces";
        }
        {
          type = "focused";
          truncate = "start";
        }
      ];
      center = [
        {
          type = "clock";
        }
      ];
      end = [
        {
          type = "clipboard";
        }
        {
          type = "tray";
        }
      ];
      style = builtins.readFile ./ironbar.css;
      # packages = inputs.ironbar;
      features = [ ];
    };
  };
}
